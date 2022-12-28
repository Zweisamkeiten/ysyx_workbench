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

// syscall functions
extern uint64_t sys_exit(void);
extern uint64_t sys_yield(void);
extern uint64_t sys_open(void);
extern uint64_t sys_read(void);
extern uint64_t sys_write(void);
extern uint64_t sys_kill(void);
extern uint64_t sys_getpid(void);
extern uint64_t sys_close(void);
extern uint64_t sys_lseek(void);
extern uint64_t sys_brk(void);
extern uint64_t sys_fstat(void);
extern uint64_t sys_time(void);
extern uint64_t sys_signal(void);
extern uint64_t sys_execve(void);
extern uint64_t sys_fork(void);
extern uint64_t sys_link(void);
extern uint64_t sys_unlink(void);
extern uint64_t sys_wait(void);
extern uint64_t sys_times(void);
extern uint64_t sys_gettimeofday(void);

// An array mapping syscall numbers from syscall.h
// to the function that handles the system call.
static uint64_t (*syscalls[])(void) = {
  [SYS_exit] = sys_exit,
  [SYS_yield] = sys_yield,
  [SYS_open] = sys_open,
  [SYS_read] = sys_read,
  [SYS_write] = sys_write,
  [SYS_kill] = sys_kill,
  [SYS_getpid] = sys_getpid,
  [SYS_close] = sys_close,
  [SYS_lseek] = sys_lseek,
  [SYS_brk] = sys_brk,
  [SYS_fstat] = sys_fstat,
  [SYS_time] = sys_time,
  [SYS_signal] = sys_signal,
  [SYS_execve] = sys_execve,
  [SYS_fork] = sys_fork,
  [SYS_link] = sys_link,
  [SYS_unlink] = sys_unlink,
  [SYS_wait] = sys_wait,
  [SYS_times] = sys_times,
  [SYS_gettimeofday] = sys_gettimeofday
};

static uintptr_t a[4];

void do_syscall(Context *c) {
  a[0] = c->GPR1;
  a[1] = c->GPR2;
  a[2] = c->GPR3;
  a[3] = c->GPR4;

  int num = a[0]; // syscall num

  if (num > 0 && num < NR_SYSCALLS && syscalls[num]) {
    c->GPRx = syscalls[num](); // return value
  } else {
    panic("Unhandled syscall ID = %d", num);
  }

  #ifdef CONFIG_STRACE
  printf("\033[93m" "STACE: %s() = %ld" "\33[0m\n", syscall_name_table[num], c->GPRx);
  #endif
}

uint64_t sys_yield(void) {
  yield();
  return 0;
}

uint64_t sys_exit(void) {
  halt(a[1]);
  return 0;
}

uint64_t sys_open(void) {
  TODO();
}

uint64_t sys_read(void) {
  TODO();
}

uint64_t sys_write(void) {
  int fd = a[1];
  const void *buf = (void *)a[2];
  size_t count = a[3];
  if (fd == 1 || fd == 2) {
  uint64_t written = 0;
    while (written <= count) {
      putch(*((char *)(buf) + written));
      written++;
    }
    return written;
  } else {
    return -1;
  }
}

uint64_t sys_kill(void) {
  TODO();
}

uint64_t sys_getpid(void) {
  TODO();
}

uint64_t sys_close(void) {
  TODO();
}

uint64_t sys_lseek(void) {
  TODO();
}

uint64_t sys_brk(void) {
  return 0;
}

uint64_t sys_fstat(void) {
  TODO();
}

uint64_t sys_time(void) {
  TODO();
}

uint64_t sys_signal(void) {
  TODO();
}

uint64_t sys_execve(void) {
  TODO();
}

uint64_t sys_fork(void) {
  TODO();
}

uint64_t sys_link(void) {
  TODO();
}

uint64_t sys_unlink(void) {
  TODO();
}

uint64_t sys_wait(void) {
  TODO();
}

uint64_t sys_times(void) {
  TODO();
}

uint64_t sys_gettimeofday(void) {
  TODO();
}

