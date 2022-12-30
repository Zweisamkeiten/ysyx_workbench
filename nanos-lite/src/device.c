#include <common.h>

#if defined(MULTIPROGRAM) && !defined(TIME_SHARING)
# define MULTIPROGRAM_YIELD() yield()
#else
# define MULTIPROGRAM_YIELD()
#endif

#define NAME(key) \
  [AM_KEY_##key] = #key,

static const char *keyname[256] __attribute__((used)) = {
  [AM_KEY_NONE] = "NONE",
  AM_KEYS(NAME)
};

size_t serial_write(const void *buf, size_t offset, size_t len) {
  size_t written = 0;
  while (written < len) {
    putch(*((char *)(buf) + written));
    written++;
  }
  return written;
}

size_t events_read(void *buf, size_t offset, size_t len) {
  AM_INPUT_KEYBRD_T ev = io_read(AM_INPUT_KEYBRD);

  if (ev.keycode == AM_KEY_NONE) return 0;

  size_t read_n = 0;
  if (ev.keydown) {
    read_n += snprintf(buf, 3, "kd "); // keydown
  } else {
    read_n += snprintf(buf, 3, "ku "); // keyup
  }

  read_n += sprintf(buf + read_n, "%s\n", keyname[ev.keycode]);

  return read_n;
}

/* 合法的 `/proc/dispinfo`文件例子如下:
   WIDTH : 640
   HEIGHT: 480
*/
size_t dispinfo_read(void *buf, size_t offset, size_t len) {
  int w = io_read(AM_GPU_CONFIG).width;
  int h = io_read(AM_GPU_CONFIG).height;
  printf("width = %d, height = %d\n", w, h);

  return sprintf(buf, "WIDTH: %d\nHEIGHT: %d\n", w, h);
}

size_t fb_write(const void *buf, size_t offset, size_t len) {
  return 0;
}

void init_device() {
  Log("Initializing devices...");
  ioe_init();
}
