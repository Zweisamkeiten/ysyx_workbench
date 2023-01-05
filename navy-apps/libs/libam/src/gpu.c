#include <am.h>
#include <libam.h>

void __am_gpu_init() {
  NDL_Init(0);
}

static int w = 0;

void __am_gpu_config(AM_GPU_CONFIG_T *cfg) {
  *cfg = (AM_GPU_CONFIG_T) {
    .present = true, .has_accel = false,
    .vmemsz = 0
  };
  int dispdev = open("/proc/dispinfo", 0, 0);
  if (dispdev != -1) {
    char buf[32];
    int nread = read(dispdev, buf, sizeof(buf));
    sscanf(buf, "WIDTH : %d\nHEIGHT : %d\n", &(cfg->width), &(cfg->height));
    w = cfg->width;
    close(dispdev);
  }
}

void __am_gpu_fbdraw(AM_GPU_FBDRAW_T *ctl) {
  TODO();
}

void __am_gpu_status(AM_GPU_STATUS_T *status) {
  status->ready = true;
}
