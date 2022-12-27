#include <common.h>
#include "syscall.h"

#ifdef CONFIG_STRACE
static char *syscall_name_table[] = {
  [SYS_exit] = "exit",
  [SYS_yield] = "yield",
  [SYS_open] = "open",
  [SYS_read] = "read",
  [SYS_write] = "write",
  [SYS_kill] = "kill",
  [SYS_getpid] = "getpid",
  [SYS_close] = "close",
  [SYS_lseek] = "lseek",
  [SYS_brk] = "brk",
  [SYS_fstat] = "fstat",
  [SYS_time] = "time",
  [SYS_signal] = "signal",
  [SYS_execve] = "execve",
  [SYS_fork] = "fork",
  [SYS_link] = "link",
  [SYS_unlink] = "unlink",
  [SYS_wait] = "wait",
  [SYS_times] = "times",
  [SYS_gettimeofday] = "gettimeofday"
};
#endif

void do_syscall(Context *c) {
  uintptr_t a[4];
  a[0] = c->GPR1;
  a[1] = c->GPR2;

  long int ret = 0;

  switch (a[0]) {
    case SYS_yield: ret = sys_yield(); break;
    case SYS_exit: ret = sys_exit(a[1]); break;
    default: panic("Unhandled syscall ID = %d", a[0]);
  }

  #ifdef CONFIG_STRACE
  printf("\033[93m" "STACE: %s() = %ld" "\33[0m\n", syscall_name_table[a[0]], ret);
  #endif
}

long sys_yield(void) {
  yield();
  return 0;
}

long sys_exit(int state) {
  halt(state);
  return 0;
}
