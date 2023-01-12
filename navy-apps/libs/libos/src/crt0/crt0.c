#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#ifdef MAINARGS
int main(const char *args);
static const char mainargs[] = MAINARGS;
#else
int main(int argc, char *argv[], char *envp[]);
#endif
extern char **environ;
void call_main(uintptr_t *args) {
  #ifdef MAINARGS
  // set up the AM heap
  printf("hhhhhhhhhhhhhhhhhhhhhhhh\n");
  _heap_start = malloc(PMEM_SIZE);
  heap = RANGE(_heap_start, (uint8_t *)_heap_start + PMEM_SIZE);

  exit(main(mainargs));
  #else
  char *empty[] =  {NULL };
  environ = empty;
  exit(main(0, empty, empty));
  assert(0);
  #endif /* MAINARGS */
}
