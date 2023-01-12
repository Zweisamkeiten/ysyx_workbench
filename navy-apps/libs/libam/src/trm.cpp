#include <am.h>
#include <libam.h>

#define RANGE(st, ed)       (Area) { .start = (void *)(st), .end = (void *)(ed) }

int main(const char *args);
Area heap;
extern uint8_t _end;
void *_heap_start = &_end;
#define PMEM_SIZE (128 * 1024 * 1024)

#ifndef MAINARGS
#define MAINARGS ""
#endif
static const char mainargs[] = MAINARGS;

void putch(char ch) {
  putchar(ch);
}

void halt(int code) {
  if (code == 0) printf("\033[38;5;120m" "AM app successful return!" "\033[0m\n");
  exit(0);
  // while(1); // for the kernel/hello an unfinished loop
}

void _trm_init() __attribute__((constructor));
void _trm_init() {
  // set up the AM heap
  heap = RANGE(_heap_start, (uint8_t *)_heap_start + PMEM_SIZE);

  int ret = main(mainargs);
  halt(ret);
}
