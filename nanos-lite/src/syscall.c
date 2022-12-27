#include <common.h>
#include "syscall.h"
void do_syscall(Context *c) {
  uintptr_t a[4];
  a[0] = c->GPR1;

  switch (a[0]) {
    case SYS_yield: sys_yield(); break;
    default: panic("Unhandled syscall ID = %d", a[0]);
  }
}

int sys_yield(void) {
  yield();
  return 0;
}
