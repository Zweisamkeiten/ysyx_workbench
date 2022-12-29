#include <stdio.h>
#include <sys/time.h>
#include <stdint.h>

static uint64_t boot_time = 0;

static uint64_t get_time_internal() {
  struct timeval now;
  gettimeofday(&now, NULL);
  uint64_t us = now.tv_sec * 1000000 + now.tv_usec;
  return us;
}

uint64_t get_time() {
  if (boot_time == 0) boot_time = get_time_internal();
  uint64_t now = get_time_internal();
  return now - boot_time;
}

int main() {
  int halfsec = 1;
  while (1) {
    while(get_time() / 500000 < halfsec) ;
    printf("time pass 0.5s\n");
    halfsec++;
  }

  return 0;
}
