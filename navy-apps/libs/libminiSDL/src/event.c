#include <NDL.h>
#include <SDL.h>
#include <string.h>

#define keyname(k) #k,

static uint8_t keyboardState[SDLK_NR] = {};

static const char *keyname[] = {
  "NONE",
  _KEYS(keyname)
};

int SDL_PushEvent(SDL_Event *ev) {
  TODO();
  return 0;
}

int SDL_PollEvent(SDL_Event *ev) {
  CallbackHelper();
  char buf[64];
  ev->key.keysym.sym = SDLK_NONE;

  if (NDL_PollEvent(buf, sizeof(buf))) {
    char *event_type = strtok(buf, " ");
    if (strcmp(event_type, "ku") == 0) {
      ev->type = SDL_KEYUP;
      ev->key.type = SDL_KEYUP;
    } else if (strcmp(event_type, "kd") == 0) {
      ev->type = SDL_KEYDOWN;
      ev->key.type = SDL_KEYDOWN;
    }

    char *key_code = event_type + strlen(event_type) + 1;
    key_code[strlen(key_code) - 1] = '\0';
    for (int i = 0; i < SDLK_NR; i++) {
      if (strcmp(key_code, keyname[i]) == 0) {
        ev->key.keysym.sym = i;
        keyboardState[i] = ev->key.type == SDL_KEYDOWN ? 1 : 0;
      }
    }

    // return 1 on success
    return 1;
  }
  return 0;
}

int SDL_WaitEvent(SDL_Event *event) {
  char buf[64];
  event->key.keysym.sym = SDLK_NONE;

  while (NDL_PollEvent(buf, sizeof(buf)) == 0);

  char *event_type = strtok(buf, " ");
  if (strcmp(event_type, "ku") == 0) {
    event->type = SDL_KEYUP;
    event->key.type = SDL_KEYUP;
  } else if (strcmp(buf, "kd") == 0) {
    event->type = SDL_KEYDOWN;
    event->key.type = SDL_KEYDOWN;
  }

  char *key_code = event_type + strlen(event_type) + 1;
  key_code[strlen(key_code) - 1] = '\0';
  for (int i = 0; i < SDLK_NR; i++) {
    if (strcmp(key_code, keyname[i]) == 0) {
      event->key.keysym.sym = i;
    }
  }

  // return 1 on success
  return 1;
}

int SDL_PeepEvents(SDL_Event *ev, int numevents, int action, uint32_t mask) {
  TODO();
  return 0;
}

uint8_t* SDL_GetKeyState(int *numkeys) {
  if (numkeys != NULL) *numkeys = SDLK_NR;
  return keyboardState;
}
