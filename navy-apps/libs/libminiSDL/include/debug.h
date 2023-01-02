#include <assert.h>

#define Assert(cond, format, ...) \
  do { \
    if (!(cond)) { \
      fflush(stdout), fprintf(stderr, format "\n", ##  __VA_ARGS__); \
      assert(cond); \
    } \
  } while (0)

#define panic(format, ...) Assert(0, format, ## __VA_ARGS__)

#define TODO() \
  printf("\033[91m" "%s: please implement me." "\33[0m\n", __func__);

