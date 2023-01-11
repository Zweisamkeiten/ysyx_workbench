#include <NDL.h>
#include <SDL.h>
#include <stdlib.h>

static uint32_t interval = 0;
static bool is_locked = 0;
static SDL_AudioSpec device;

void CallbackHelper() {
  if (is_locked == false) return;

  static uint32_t last_time = 0;
  static uint32_t now = 0;

  now = SDL_GetTicks();
  if (now - last_time > interval) {
    printf("123\n");
    int len = device.format / 8 * device.samples;
    int query = NDL_QueryAudio();
    if (query > len) {
      uint8_t * stream = (uint8_t *)malloc(len);
      device.callback(device.userdata, stream, len);
      last_time = now;
      NDL_PlayAudio(stream, len);
      free(stream);
    }
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
  TODO();
}

SDL_AudioSpec *SDL_LoadWAV(const char *file, SDL_AudioSpec *spec, uint8_t **audio_buf, uint32_t *audio_len) {
  TODO();
  return NULL;
}

void SDL_FreeWAV(uint8_t *audio_buf) {
  TODO();
}

void SDL_LockAudio() {
  is_locked = false;
}

void SDL_UnlockAudio() {
  is_locked = true;
}
