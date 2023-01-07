#include <am.h>
#include <libam.h>

int main(const char *args);
Area heap;

#ifndef MAINARGS
#define MAINARGS ""
#endif
static const char mainargs[] = MAINARGS;

void putch(char ch) {
  putchar(ch);
}

void halt(int code) {
  if (code == 0) printf("\033[38;5;120m" "AM app successful return!" "\033[0m\n");
  while(1);
}

static void _trm_init() __attribute__((constructor));
void _trm_init() {
  int ret = main(mainargs);
  halt(ret);
}
