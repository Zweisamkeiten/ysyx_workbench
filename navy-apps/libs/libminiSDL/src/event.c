#include <NDL.h>
#include <SDL.h>
#include <string.h>

#define keyname(k) #k,

static const char *keyname[] = {
  "NONE",
  _KEYS(keyname)
};

int SDL_PushEvent(SDL_Event *ev) {
  return 0;
}

int SDL_PollEvent(SDL_Event *ev) {
  return 0;
}

int SDL_WaitEvent(SDL_Event *event) {
  char buf[64];
  event->key.keysym.sym = SDLK_NONE;
  if (NDL_PollEvent(buf, sizeof(buf))) {
    if (strncmp(buf, "ku", 2) == 0) {
      event->type = SDL_KEYUP;
      event->key.type = SDL_KEYUP;
    } else if (strncmp(buf, "kd", 2) == 0) {
      printf("%s", buf);
      event->type = SDL_KEYDOWN;
      event->key.type = SDL_KEYDOWN;
    }

    char *blank = strchr(buf, ' ');
    char *end = strchr(blank + 1, '\n');
    for (int i = 0; i < SDLK_NR; i++) {
      if (strncmp(blank + 1, keyname[i], end - blank - 1) == 0) {
        event->key.keysym.sym = i;
      }
    }

    // return 1 on success
    return 1;
  }
  return 0;
}

int SDL_PeepEvents(SDL_Event *ev, int numevents, int action, uint32_t mask) {
  return 0;
}

uint8_t* SDL_GetKeyState(int *numkeys) {
  return NULL;
}
