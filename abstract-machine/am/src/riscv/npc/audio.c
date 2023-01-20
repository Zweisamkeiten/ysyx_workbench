#include <am.h>
#include <npc.h>
#include <klib.h>

#define AUDIO_FREQ_ADDR      (AUDIO_ADDR + 0x00)
#define AUDIO_CHANNELS_ADDR  (AUDIO_ADDR + 0x04)
#define AUDIO_SAMPLES_ADDR   (AUDIO_ADDR + 0x08)
#define AUDIO_SBUF_SIZE_ADDR (AUDIO_ADDR + 0x0c)
#define AUDIO_INIT_ADDR      (AUDIO_ADDR + 0x10)
#define AUDIO_COUNT_ADDR     (AUDIO_ADDR + 0x14)

static int write_point = 0; // 读写队列 读的结尾, 写的开头
static int sbufsize = 0;

void __am_audio_init() {
  sbufsize = inl(AUDIO_SBUF_SIZE_ADDR);
}

void __am_audio_config(AM_AUDIO_CONFIG_T *cfg) {
  cfg->present = inl(AUDIO_INIT_ADDR);
  // cfg->present = true;
  // cfg->bufsize = inl(AUDIO_SBUF_SIZE_ADDR);
  cfg->bufsize = 0x10000;
  sbufsize = cfg->bufsize;
}

void __am_audio_ctrl(AM_AUDIO_CTRL_T *ctrl) {
  outl(AUDIO_FREQ_ADDR, ctrl->freq);
  outl(AUDIO_CHANNELS_ADDR, ctrl->channels);
  outl(AUDIO_SAMPLES_ADDR, ctrl->samples);
}

void __am_audio_status(AM_AUDIO_STATUS_T *stat) {
  stat->count = inl(AUDIO_COUNT_ADDR);
}

static void audio_write(uint8_t *buf, int len) {
  int nwrite = 0;
  while (nwrite < len) {
    int count = inl(AUDIO_COUNT_ADDR);
    int free = sbufsize - count;
    if (free > len) {
      int free_to_end = sbufsize - write_point; // 写入点距离缓冲区末尾的空闲空间
      if (free_to_end >= len) {
        memcpy((void *)(uint64_t)(AUDIO_SBUF_ADDR + write_point), buf, len);
        write_point += len;
      } else {
        memcpy((void *)(uint64_t)(AUDIO_SBUF_ADDR + write_point), buf, free_to_end);
        write_point = 0;
        memcpy((void *)(uint64_t)(AUDIO_SBUF_ADDR + write_point), buf + free_to_end, len - free_to_end);
        write_point = len - free_to_end;
      }
      count += len;
      outl(AUDIO_COUNT_ADDR, count);
      nwrite += len;
    }
  }
}

void __am_audio_play(AM_AUDIO_PLAY_T *ctl) {
  int len = ctl->buf.end - ctl->buf.start;
  audio_write(ctl->buf.start, len);
}
