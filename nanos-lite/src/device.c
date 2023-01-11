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

static int screen_w = 0;
static int screen_h = 0;
static bool audio_present = false;
static int audio_bufsize = 0;

size_t serial_write(const void *buf, size_t offset, size_t len) {
  assert(buf != NULL);
  size_t written = 0;
  while (written < len) {
    putch(*((char *)(buf) + written));
    written++;
  }
  return written;
}

size_t events_read(void *buf, size_t offset, size_t len) {
  assert(buf != NULL);
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
  assert(buf != NULL);
  sprintf(buf, "WIDTH: %d\nHEIGHT: %d\n", screen_w, screen_h);

  return 0; // open_offset always == 0
}

size_t fb_write(const void *buf, size_t offset, size_t len) {
  assert(buf != NULL);
  size_t pixel_offset = offset / 4; // 00RRGGBB 4 byte
  int x = pixel_offset % screen_w;
  int y = pixel_offset / screen_w;
  io_write(AM_GPU_FBDRAW, x, y, (void *)buf, len / 4, 1, true);
  return len;
}

size_t sb_write(const void *buf, size_t offset, size_t len) {
  Area sbuf;
  sbuf.start = (void *)buf;
  sbuf.end = sbuf.start + len;
  io_write(AM_AUDIO_PLAY, sbuf);

  return 0; // open_offset always == 0
}

size_t sbctl_read(void *buf, size_t offset, size_t len) {
  assert(buf != NULL);

  assert(offset == 0);

  AM_AUDIO_STATUS_T audio_status = io_read(AM_AUDIO_STATUS);

  snprintf((char *)buf, len, "%d", audio_status.count);

  return 0; // open_offset always == 0
}

size_t sbctl_write(const void *buf, size_t offset, size_t len) {
  assert(buf != NULL);

  assert(len == 3 * 4);

  assert(offset == 0);

  int * write_data = (int *)buf;

  io_write(AM_AUDIO_CTRL, write_data[0], write_data[1], write_data[2]);

  return 0; // open_offset always == 0
}

void init_device() {
  Log("Initializing devices...");
  ioe_init();

  AM_GPU_CONFIG_T gpu_info = io_read(AM_GPU_CONFIG);
  screen_w = gpu_info.width;
  screen_h = gpu_info.height;
  printf("width = %d, height = %d\n", screen_w, screen_h);

  AM_AUDIO_CONFIG_T audio_info = io_read(AM_AUDIO_CONFIG);
  audio_present = audio_info.present;
  audio_bufsize = audio_info.bufsize;
}
