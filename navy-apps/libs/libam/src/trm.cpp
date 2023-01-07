#include <am.h>
#include <libam.h>

#define RANGE(st, ed)       (Area) { .start = (void *)(st), .end = (void *)(ed) }

int main(const char *args);
Area heap;

#define PMEM_START (void *)0x1000000  // for nanos-lite with vme disabled
#define PMEM_SIZE (128 * 1024 * 1024) // 128MB
static int pmem_fd = 0;
static void *pmem = NULL;

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
  pmem_fd = memfd_create("pmem", 0);
  assert(pmem_fd != -1);
  assert(0 == ftruncate(pmem_fd, PMEM_SIZE));

  pmem = mmap(PMEM_START, PMEM_SIZE, PROT_READ | PROT_WRITE | PROT_EXEC,
      MAP_SHARED | MAP_FIXED, pmem_fd, 0);
  assert(pmem != (void *)-1);

  // set up the AM heap
  heap = RANGE(pmem, (uint8_t *)pmem + PMEM_SIZE);

  int ret = main(mainargs);
  halt(ret);
}
