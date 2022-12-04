#include <am.h>
#include <nemu.h>

#define SYNC_ADDR (VGACTL_ADDR + 4)

void __am_gpu_init() {
  // int i;
  // int w = io_read(AM_GPU_CONFIG).width;  // TODO: get the correct width
  // int h = io_read(AM_GPU_CONFIG).height;  // TODO: get the correct height
  // uint32_t *fb = (uint32_t *)(uintptr_t)FB_ADDR;
  // for (i = 0; i < w * h; i ++) fb[i] = i;
  // outl(SYNC_ADDR, 1);
}

void __am_gpu_config(AM_GPU_CONFIG_T *cfg) {
  uint32_t size = inl(VGACTL_ADDR);
  *cfg = (AM_GPU_CONFIG_T) {
    .present = true, .has_accel = false,
    .width = size >> 16, .height = size & 0xFFFF,
    .vmemsz = 0
  };
}

void __am_gpu_fbdraw(AM_GPU_FBDRAW_T *ctl) {
  if (ctl->sync) {
    outl(SYNC_ADDR, 1);
  }

  int w = io_read(AM_GPU_CONFIG).width;
  if (ctl->w == 0 || ctl->h == 0) return;
  uint32_t *fb = (uint32_t *)(uintptr_t)FB_ADDR;
  for (int row = ctl->y; row < ctl->y + ctl->h; row++) {
    for (int column = ctl->x; column < ctl->x + ctl->w; column++) {
      fb[row * w + column] = *(uint32_t *)(ctl->pixels);
      ctl->pixels++;
    }
  }
}

void __am_gpu_status(AM_GPU_STATUS_T *status) {
  status->ready = true;
}
