#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/time.h>
#include <assert.h>

static int evtdev = -1;
static int fbdev = -1;
static int screen_w = 0, screen_h = 0;
static int canvas_w = 0, canvas_h = 0;
static uint32_t boot_time = 0;
static int eventsdev = -1;
static int dispdev = -1;
static int sbdev = -1;
static int sbctldev = -1;

uint32_t NDL_GetTicks() {
  struct timeval now;
  gettimeofday(&now, NULL);
  uint32_t ms = now.tv_sec * 1000 + now.tv_usec / 1000;

  return ms - boot_time;
}

int NDL_PollEvent(char *buf, int len) {
  assert(eventsdev != -1);
  // 读出一条事件信息, 将其写入`buf`中, 最长写入`len`字节
  // 若读出了有效的事件, 函数返回1, 否则返回0
  if (read(eventsdev, buf, len) != 0) {
    return 1;
  }
  return 0;
}

void NDL_OpenCanvas(int *w, int *h) {
  if (getenv("NWM_APP")) {
    int fbctl = 4;
    fbdev = 5;
    screen_w = *w; screen_h = *h;
    char buf[64];
    int len = sprintf(buf, "%d %d", screen_w, screen_h);
    // let NWM resize the window and create the frame buffer
    write(fbctl, buf, len);
    while (1) {
      // 3 = evtdev
      int nread = read(3, buf, sizeof(buf) - 1);
      if (nread <= 0) continue;
      buf[nread] = '\0';
      if (strcmp(buf, "mmap ok") == 0) break;
    }
    close(fbctl);
  }

  assert(*w >= 0 && *h >= 0);

  if (*w == 0 && *h == 0) {
    *w = screen_w;
    *h = screen_h;
  }

  canvas_w = *w;
  canvas_h = *h;
}

void NDL_DrawRect(uint32_t *pixels, int x, int y, int w, int h) {
  assert(canvas_w != 0 && canvas_h != 0);

  assert(fbdev != -1);

  // center the canvas
  int draw_x = x + (screen_w - canvas_w) / 2;
  int draw_y = y + (screen_h - canvas_h) / 2;
  for (int row = 0; row < h; row++) {
    lseek(fbdev, ((draw_y + row) * screen_w + draw_x) * 4, SEEK_SET);
    write(fbdev, pixels + row * w, w * 4);
  }
}

void NDL_OpenAudio(int freq, int channels, int samples) {
  assert(sbctldev != -1);

  int buf[3] = {freq, channels, samples};
  write(sbctldev, buf, sizeof(buf));
}

void NDL_CloseAudio() {
  close(sbdev);
  close(sbctldev);
}

int NDL_PlayAudio(void *buf, int len) {
  assert(sbdev != -1);

  write(sbdev, buf, len);
  return len;
}

int NDL_QueryAudio() {
  assert(sbctldev != -1);

  int free_size = 0;
  char buf[30] = {};
  read(sbctldev, buf, 30);
  sscanf(buf, "%d", &free_size);
  return free_size;
}

int NDL_Init(uint32_t flags) {
  if (getenv("NWM_APP")) {
    evtdev = 3;
  }

  boot_time = NDL_GetTicks();

  eventsdev = open("/dev/events", 0, 0);

  dispdev = open("/proc/dispinfo", 0, 0);
  if (dispdev != -1) {
    char buf[32];
    int nread = read(dispdev, buf, sizeof(buf));
    sscanf(buf, "WIDTH : %d\nHEIGHT : %d\n", &screen_w, &screen_h);
    printf("\033[32mNDL_INIT: WIDTH: %d, HEIGHT: %d" "\33[0m\n", screen_w, screen_h);
    canvas_w = screen_w;
    canvas_h = screen_h;
    close(dispdev);
  }

  fbdev = open("/dev/fb", 0, 0);

  sbdev = open("/dev/sb", 0, 0);

  sbctldev = open("/dev/sbctl", 0, 0);

  return 0;
}

void NDL_Quit() {
}
