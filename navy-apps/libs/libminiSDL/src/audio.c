#include <NDL.h>
#include <SDL.h>
#include <stdlib.h>
#include <SDL_wave.h>

static uint32_t interval = 0;
static bool is_locked = 0;
static SDL_AudioSpec device;

void CallbackHelper() {
  if (is_locked == true) return;

  static bool reenter_flag = false;
  static uint32_t last_time = 0;
  static uint32_t now = 0;

  if (reenter_flag) return;

  now = SDL_GetTicks();
  if (now - last_time > interval) {
    // 空间 = 一个采样点的大小 * 采样点数量 = 样本格式((format & 0xff) / 8) * 通道数 * 采样点数量
    int len = (device.format & 0xff) / 8 * device.samples * device.channels;
    int query = NDL_QueryAudio();
    if (query > len) {
      uint8_t * stream = (uint8_t *)malloc(len * sizeof(uint8_t));
      reenter_flag = !reenter_flag;
      device.callback(device.userdata, stream, len);
      NDL_PlayAudio(stream, len);
      free(stream);
      reenter_flag = !reenter_flag;
    }
    last_time = now;
  }
}

int SDL_OpenAudio(SDL_AudioSpec *desired, SDL_AudioSpec *obtained) {
  NDL_OpenAudio(desired->freq, desired->channels, desired->samples);
  printf("%d, %d, %d\n", desired->freq, desired->channels, desired->samples);

  interval = desired->samples * 1000 / desired->freq; // freq = 每秒采样个数, samples = 用户每次需要采样数量, *1000 秒 转 毫秒

  device.freq = desired->freq;
  device.channels = desired->channels;
  device.format = desired->format;
  device.samples = desired->samples;
  device.callback = desired->callback;
  device.userdata = desired->userdata;

  return 0;
}

void SDL_CloseAudio() {
  NDL_CloseAudio();
}

void SDL_PauseAudio(int pause_on) {
  pause_on == 0 ? SDL_UnlockAudio() : SDL_LockAudio();
}

void SDL_MixAudio(uint8_t *dst, uint8_t *src, uint32_t len, int volume) {
  int multiple = SDL_MIX_MAXVOLUME / volume;

  uint32_t samples_len = len / ((device.format & 0xff) / 8);

    switch (device.format) {
      case AUDIO_U8: {
      for (int i = 0; i < samples_len; i++) {
        uint8_t * dstp = (uint8_t *)dst + i;
        uint8_t * srcp = (uint8_t *)src + i;
        uint8_t data = (*srcp / multiple + *dstp);
        *dstp = data;
      }
        break;
      }
      case AUDIO_S8: {
      for (int i = 0; i < samples_len; i++) {
        int8_t * dstp = (int8_t *)dst + i;
        int8_t * srcp = (int8_t *)src + i;
        int16_t data = ((int16_t)*srcp / multiple + (int16_t)*dstp);
        data = data > 127 ? 127 : data;
        data = data < -127 ? -127 : data;
        *dstp = (int8_t)data;
      }
        break;
      }
      case AUDIO_U16: {
      for (int i = 0; i < samples_len; i++) {
        uint16_t * dstp = (uint16_t *)dst + i;
        uint16_t * srcp = (uint16_t *)src + i;
        uint16_t data = (*srcp / multiple + *dstp);
        *dstp = data;
      }
        break;
      }
      case AUDIO_S16: {
      for (int i = 0; i < samples_len; i++) {
        int16_t * dstp = (int16_t *)dst + i;
        int16_t * srcp = (int16_t *)src + i;
        int32_t data = ((int32_t)*srcp / multiple + (int32_t)*dstp);

        data = data > 32767 ? 32767 : data;
        data = data < -32767 ? -32767 : data;
        *dstp = (int16_t)data;
      }
        break;
      }
      case AUDIO_S32: {
      for (int i = 0; i < samples_len; i++) {
        int32_t * dstp = (int32_t *)dst + i;
        int32_t * srcp = (int32_t *)src + i;
        int64_t data = ((int64_t)*srcp / multiple + (int64_t)*dstp);
        data = data > 2147483647 ? 2147483647 : data;
        data = data < -2147483647 ? -2147483647 : data;
        *dstp = (int32_t)data;
      }
        break;
      }
      default:
        fprintf(stderr, "Unexpected %u-bit PCM data format", (unsigned int)(device.format));
    }
}

SDL_AudioSpec *SDL_LoadWAV(const char *file, SDL_AudioSpec *spec, uint8_t **audio_buf, uint32_t *audio_len) {
  FILE * fp = fopen(file, "rb");
  WaveFile wavefile;
  fread(&wavefile, sizeof(WaveFile), 1, fp);

  spec->freq = wavefile.format.sampleRate;
  spec->channels = wavefile.format.numChannels;
  spec->samples = 4096;       /* Good default buffer size */

  switch (wavefile.format.audioFormat) {
    case PCM_CODE:
      switch (wavefile.format.bitsPerSample) {
        case 8:
          spec->format = AUDIO_U8;
          break;
        case 16:
          spec->format = AUDIO_S16;
          break;
        case 24: /* Has been shifted to 32 bits. */
        case 32:
          spec->format = AUDIO_S32LSB;
          break;
        default:
          /* Just in case something unexpected happened in the checks. */
          fprintf(stderr, "Unexpected %u-bit PCM data format", (unsigned int)(wavefile.format.bitsPerSample));
          return NULL;
      }
      break;
  }

  spec->size = wavefile.data.subchunk2Size;
  *audio_buf = malloc(spec->size);
  assert(*audio_buf);
  fread(*audio_buf, spec->size, 1, fp);
  fclose(fp);

  *audio_len = spec->size;

  return spec;
}

void SDL_FreeWAV(uint8_t *audio_buf) {
  free(audio_buf);
}

void SDL_LockAudio() {
  is_locked = true;
}

void SDL_UnlockAudio() {
  is_locked = false;
}
