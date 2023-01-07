#include <am.h>
#include <libam.h>

#define keyname(k) #k,

static const char *keyname[] = {
  "NONE",
  AM_KEYS(keyname)
};

#define NR_KEY sizeof(keyname)/sizeof(char *)

void __am_input_keybrd(AM_INPUT_KEYBRD_T *kbd) {
  char buf[64];
  kbd->keycode = AM_KEY_NONE;
  kbd->keydown = 0;

  if (NDL_PollEvent(buf, sizeof(buf))) {
    char *event_type = strtok(buf, " ");
    if (strcmp(event_type, "kd") == 0) {
      kbd->keydown = 1;
    } else {
      kbd->keydown = 0;
    }

    char *key_code = event_type + strlen(event_type) + 1;
    key_code[strlen(key_code) - 1] = '\0';
    for (int i = 0; i < NR_KEY; i++) {
      if (strcmp(key_code, keyname[i]) == 0) {
        kbd->keycode = i;
      }
    }
  }
  return;
}
