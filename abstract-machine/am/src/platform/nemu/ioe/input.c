#include <am.h>
#include <nemu.h>

#define KEYDOWN_MASK 0x8000

void __am_input_keybrd(AM_INPUT_KEYBRD_T *kbd) {
  uint32_t scancode = inw(KBD_ADDR);
  // printf("scancode: %d\n", scancode);
  kbd->keydown = (scancode & KEYDOWN_MASK ? true : false);
  kbd->keycode = scancode & ~KEYDOWN_MASK;
}
