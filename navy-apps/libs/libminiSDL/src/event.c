#include <NDL.h>
#include <SDL.h>
#include <string.h>
#include <assert.h>

#define keyname(k) #k,

static const char *keyname[] = {
  "NONE",
  _KEYS(keyname)
};
#define KEY_CNT 83

#define EVENT_QUENE_SIZE 64
static SDL_Event event_queue[EVENT_QUENE_SIZE] = {0};
static int ev_r = 0,ev_f = 0;

static inline bool event_queue_empty() {
  return ev_r == ev_f;
}
static inline bool event_queue_full() {
  return (ev_r+1)%EVENT_QUENE_SIZE == ev_f;
}

static int get_event(SDL_Event *ev) {
  if(ev == NULL) return 1;
  if(event_queue_empty()) return 0;
  *ev = event_queue[ev_f];
  ev_f = (ev_f+1)%EVENT_QUENE_SIZE;
  return 1;
}

int SDL_PushEvent(SDL_Event *ev) {
  if(event_queue_full() == false) {
    event_queue[ev_r] = *ev;
    ev_r = (ev_r+1)%EVENT_QUENE_SIZE;
    return 1;
  }
  return 0;
}

static uint8_t key_state[KEY_CNT] = {0};
int SDL_PollEvent(SDL_Event *ev) {  
  int ret = get_event(ev);
  if(ret == 1) return 1;
  // printf("SDL_PollEvent\n");
  char buf[64] = {0};
  int len = NDL_PollEvent(buf,sizeof(buf));
  if(len == 0) return 0;
  buf[len] = '\0';
  char keydown,name[32];
  if(buf[0] == 'k') {
    int match = sscanf(buf,"k%c %s",&keydown,name);
    if(match != 2) return 0;
    uint8_t keycode = 0;
    for (uint8_t code = 0; code < KEY_CNT; code++)
    {
      if(strcmp(keyname[code],name) == 0) {
        keycode = code;
        break;
      }
    }
    if(keycode == 0) return 0;
    if(keydown == 'd') {
      key_state[keycode] = 1;
      ev->type = ev->key.type = SDL_KEYDOWN;
    }
    else if(keydown == 'u') {
      key_state[keycode] = 0;
      ev->type = ev->key.type = SDL_KEYUP;
    } 
    else assert(0);
    // printf("keycode:%d buf:%s",keycode,buf);
    ev->key.keysym.sym = keycode;
    return 1;
  } else  return 0;
}

int SDL_WaitEvent(SDL_Event *event) {
  while (SDL_PollEvent(event) == 0)
  {
    // printf("SDL_WaitEvent\n");
  }
  // printf("SDL_WaitEvent\n");
  
  return 1;
}

int SDL_PeepEvents(SDL_Event *ev, int numevents, int action, uint32_t mask) {
  printf("SDL_PeepEvents\n");
  return 0;
}

uint8_t* SDL_GetKeyState(int *numkeys) {
  if(numkeys) {
    int num = 0;
    for (int i = 0; i < KEY_CNT; i++)
    {
      num += key_state[i];
    }  
  }
  
  return key_state;
}
