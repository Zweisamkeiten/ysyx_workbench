#include <NDL.h>
#include <SDL.h>
#include <stdlib.h>

static uint32_t interval = 0;
static void * userdata = NULL;
static void (*usercallback)(void *userdata, uint8_t *stream, int len) = NULL;

void CallbackHelper() {
  static uint32_t last_time = 0;
  static uint32_t now = 0;

  now = SDL_GetTicks();
  if (now - last_time > interval) {
    int len = NDL_QueryAudio();
    uint8_t * stream = (uint8_t *)calloc(len, 1);
    usercallback(userdata, stream, len);
    last_time = now;
  }
  
}

int SDL_OpenAudio(SDL_AudioSpec *desired, SDL_AudioSpec *obtained) {
  NDL_OpenAudio(desired->freq, desired->channels, desired->samples);

  interval = desired->samples / desired->freq; // freq = 每秒采样个数, samples = 用户每次需要采样数量

  usercallback = desired->callback;

  userdata = desired->userdata;

  return 0;
}

void SDL_CloseAudio() {
  NDL_CloseAudio();
}

void SDL_PauseAudio(int pause_on) {
  TODO();
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
  TODO();
}

void SDL_UnlockAudio() {
  TODO();
}
