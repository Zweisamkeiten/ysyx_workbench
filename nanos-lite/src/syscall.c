#include <common.h>
#include "syscall.h"
void do_syscall(Context *c) {
  uintptr_t a[4];
  a[0] = c->GPR1;
  a[1] = c->GPR2;

  switch (a[0]) {
    case SYS_yield: sys_yield(); break;
    case SYS_exit: sys_exit(a[1]); break;
    default: panic("Unhandled syscall ID = %d", a[0]);
  }
}

int sys_yield(void) {
  yield();
  return 0;
}

int sys_exit(int state) {
  halt(state);
  return 0;
}
