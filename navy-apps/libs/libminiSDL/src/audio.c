#include <NDL.h>
#include <SDL.h>
#include <stdlib.h>
#include <string.h>
#include <SDL_wave.h>

static uint32_t interval = 0;
static bool is_locked = 0;
static SDL_AudioSpec device;

void CallbackHelper() {
  if (is_locked == false) return;

  static bool reenter_flag = false;
  static uint32_t last_time = 0;
  static uint32_t now = 0;

  if (reenter_flag) return;

  now = SDL_GetTicks();
  if (now - last_time > interval) {
    int len = device.format / 8 * device.samples;
    int query = NDL_QueryAudio();
    if (query > len) {
      uint8_t * stream = (uint8_t *)malloc(len);
      reenter_flag = !reenter_flag;
      device.callback(device.userdata, stream, len);
      reenter_flag = !reenter_flag;
      NDL_PlayAudio(stream, len);
      free(stream);
    }
    last_time = now;
  }
}

int SDL_OpenAudio(SDL_AudioSpec *desired, SDL_AudioSpec *obtained) {
  NDL_OpenAudio(desired->freq, desired->channels, desired->samples);

  interval = desired->samples / desired->freq; // freq = 每秒采样个数, samples = 用户每次需要采样数量

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
  int multiple = volume / SDL_MIX_MAXVOLUME;

  for (int i = 0; i < len; i++) {
    switch (device.format) {
      case AUDIO_U8:
        dst = (uint8_t)(((uint8_t *)src) * volume);
      case AUDIO_S8:
        (uint8_t *)dst = (uint8_t *)src * volume;
    }
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
  memcpy(*audio_buf, wavefile.data.data, spec->size);

  *audio_len = spec->size;

  return spec;
}

void SDL_FreeWAV(uint8_t *audio_buf) {
  free(audio_buf);
}

void SDL_LockAudio() {
  is_locked = false;
}

void SDL_UnlockAudio() {
  is_locked = true;
}
