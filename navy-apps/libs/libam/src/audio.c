#include <am.h>
#include <klib.h>
#include <libam.h>

static int write_point = 0; // 读写队列 读的结尾, 写的开头

void __am_audio_init() {
  TODO();
}

void __am_audio_config(AM_AUDIO_CONFIG_T *cfg) {
  TODO();
}

void __am_audio_ctrl(AM_AUDIO_CTRL_T *ctrl) {
  TODO();
}

void __am_audio_status(AM_AUDIO_STATUS_T *stat) {
  TODO();
}

static void audio_write(uint8_t *buf, int len) {
  TODO();
}

void __am_audio_play(AM_AUDIO_PLAY_T *ctl) {
  TODO();
}
