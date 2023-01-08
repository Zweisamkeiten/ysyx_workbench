#define _GNU_SOURCE
#include <fcntl.h>
#include <unistd.h>
#include <klib.h>
#include <SDL2/SDL.h>

static int rfd = -1, wfd = -1;
static volatile int count = 0;
// static int write_point = 0;
// static int read_point = 0;
static uint8_t *sbuf = NULL;

void __am_audio_init() {
  int fds[2];
  int ret = pipe2(fds, O_NONBLOCK);
  assert(ret == 0);
  rfd = fds[0];
  wfd = fds[1];
  sbuf = (uint8_t *)malloc(0x10000);
}

static void audio_play(void *userdata, uint8_t *stream, int len) {
  int nread = len;
  if (count < len) nread = count;
  int b = 0;
  while (b < nread) {
    int n = read(rfd, stream, nread);
    if (n > 0) b += n;
  }

  count -= nread;
  if (len > nread) {
    memset(stream + nread, 0, len - nread);
  }
}
// static void audio_play(void *userdata, uint8_t *stream, int len) {
//   int nread = len;
//   if (count < len) nread = count;
//   int b = 0;
//   while (b < nread) {
//     int size = (count < nread) ? count : nread;
//     // printf("read_point: %d\n", read_point);
//     int read_to_end = 0x10000 - read_point; // 读入点距离缓冲区末尾的距离
//     if (read_to_end > nread) {
//       memcpy(stream, sbuf + read_point, size);
//       read_point += size;
//     } else {
//       memcpy(stream, sbuf + read_point, read_to_end);
//       read_point = 0;
//       memcpy(stream + read_to_end, sbuf + read_point, size - read_to_end);
//       read_point = size - read_to_end;
//     }
//     b += size;
//   }

//   count -= nread;
//   if (len > nread) {
//     memset(stream + nread, 0, len - nread);
//   }
// }

static void audio_write(uint8_t *buf, int len) {
  int nwrite = 0;
  while (nwrite < len) {
    int n = write(wfd, buf, len);
    if (n == -1) n = 0;
    count += n;
    nwrite += n;
  }
}
// static void audio_write(uint8_t *buf, int len) {
//   int nwrite = 0;
//   int sbufsize = 0x10000;
//   while (nwrite < len) {
//     int free = sbufsize - count;
//     if (free > len) {
//       int free_to_end = sbufsize - write_point; // 写入点距离缓冲区末尾的空闲空间
//       if (free_to_end >= len) {
//         memcpy(sbuf + write_point, buf, len);
//         write_point += len;
//       } else {
//         memcpy(sbuf + write_point, buf, free_to_end);
//         write_point = 0;
//         memcpy(sbuf + write_point, buf + free_to_end, len - free_to_end);
//         write_point = len - free_to_end;
//       }
//       count += len;
//       nwrite += len;
//     }
//   }
// }

void __am_audio_ctrl(AM_AUDIO_CTRL_T *ctrl) {
  SDL_AudioSpec s = {};
  s.freq = ctrl->freq;
  s.format = AUDIO_S16SYS;
  s.channels = ctrl->channels;
  s.samples = ctrl->samples;
  s.callback = audio_play;
  s.userdata = NULL;

  count = 0;
  int ret = SDL_InitSubSystem(SDL_INIT_AUDIO);
  if (ret == 0) {
    SDL_OpenAudio(&s, NULL);
    SDL_PauseAudio(0);
  }
}

void __am_audio_status(AM_AUDIO_STATUS_T *stat) {
  stat->count = count;
}

void __am_audio_play(AM_AUDIO_PLAY_T *ctl) {
  int len = ctl->buf.end - ctl->buf.start;
  audio_write(ctl->buf.start, len);
}

void __am_audio_config(AM_AUDIO_CONFIG_T *cfg) {
  cfg->present = true;
  cfg->bufsize = 0x10000; //fcntl(rfd, F_GETPIPE_SZ);
}
