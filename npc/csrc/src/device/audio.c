/***************************************************************************************
* Copyright (c) 2014-2022 Zihao Yu, Nanjing University
*
* NPC is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

#include <common.h>
#include <device/map.h>
#include <SDL2/SDL.h>
#include <unistd.h>

enum {
  reg_freq,
  reg_channels,
  reg_samples,
  reg_sbuf_size,
  reg_init,
  reg_count,
  nr_reg
};

static uint8_t *sbuf = NULL;
static uint32_t *audio_base = NULL;

static volatile int count = 0;
static SDL_AudioSpec s = {};
static int read_point = 0;

#ifdef CONFIG_HAS_AUDIO

static void audio_play(void *userdata, uint8_t *stream, int len) {
  int nread = len;
  if (count < len) nread = count;
  int b = 0;
  while (b < nread) {
    int size = (count < nread) ? count : nread;
    // printf("read_point: %d\n", read_point);
    int read_to_end = CONFIG_SB_SIZE - read_point; // 读入点距离缓冲区末尾的距离
    if (read_to_end > nread) {
      memcpy(stream, sbuf + read_point, size);
      read_point += size;
    } else {
      memcpy(stream, sbuf + read_point, read_to_end);
      read_point = 0;
      memcpy(stream + read_to_end, sbuf + read_point, size - read_to_end);
      read_point = size - read_to_end;
    }
    b += size;
  }

  count -= nread;
  if (len > nread) {
    memset(stream + nread, 0, len - nread);
  }
}

static void init_sound() {
  s.format = AUDIO_S16SYS; // 假设系统中音频数据的格式总是使用16位有符号数来表示
  s.callback = audio_play;
  s.userdata = NULL; // 不使用
  // printf("freq: %d\n", s.freq);
  // printf("channels: %d\n", s.channels);
  // printf("samples: %d\n", s.samples);

  count = 0;
  int ret = SDL_InitSubSystem(SDL_INIT_AUDIO);
  if (ret == 0) {
    SDL_OpenAudio(&s, NULL);
    SDL_PauseAudio(0);
  }
}

#endif

static void audio_io_handler(uint32_t offset, int len, bool is_write) {
  if (is_write) {
    switch (offset / 4) {
      case reg_freq: s.freq = audio_base[reg_freq]; break;
      case reg_channels: s.channels = audio_base[reg_channels]; break;
      case reg_samples: s.samples = audio_base[reg_samples]; init_sound(); break; // 照顺序写入, samples最后一个写入, 之后初始化音频设备
      case reg_count: count = audio_base[reg_count]; break;
      default: panic("offset illegal");
    }
  }
  else  {
    printf("offset: %d\n", offset);
    switch (offset / 4) {
      case reg_sbuf_size: audio_base[reg_sbuf_size] = CONFIG_SB_SIZE; break;
      case reg_init: audio_base[reg_init] = true; break;
      case reg_count: audio_base[reg_count] = count; break;
      default: panic("offset illegal");
      // default: audio_base[offset/4] = 0; break;
    }
  }
}

void init_audio() {
  uint32_t space_size = sizeof(uint32_t) * nr_reg;
  audio_base = (uint32_t *)new_space(space_size);
#ifdef CONFIG_HAS_PORT_IO
  add_pio_map ("audio", CONFIG_AUDIO_CTL_PORT, audio_base, space_size, audio_io_handler);
#else
  add_mmio_map("audio", CONFIG_AUDIO_CTL_MMIO, audio_base, space_size, audio_io_handler);
#endif

  sbuf = (uint8_t *)new_space(CONFIG_SB_SIZE);
  add_mmio_map("audio-sbuf", CONFIG_SB_ADDR, sbuf, CONFIG_SB_SIZE, NULL);
}
