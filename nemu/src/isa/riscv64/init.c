/***************************************************************************************
* Copyright (c) 2014-2022 Zihao Yu, Nanjing University
*
* NEMU is licensed under Mulan PSL v2.
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

#include <isa.h>
#include <memory/paddr.h>
#include "local-include/reg.h"

// this is not consistent with uint8_t
// but it is ok since we do not access the array directly
static const uint32_t img [] = {
  0x00000413,
0x50008117,
0xffc10113,
0x0b0000ef,
0x01b77d85,
0x003701c5,
0xff130101,
0x20050513,
0x84058593,
0x00113423,
0x00813023,
0x040000ef,
0x07c000ef,
0x00000417,
0x1a440413,
0x04800513,
0x00140413,
0x01c000ef,
0x00044503,
0xfe051ae3,
0x00813083,
0x00013403,
0x01010113,
0x00008067,
0x100007b7,
0x00a78023,
0x00008067,
0xff010113,
0x00050793,
0x00813023,
0x00113423,
0x10000437,
0x00058513,
0x0047959b,
0xf8300793,
0x00f401a3,
0x084000ef,
0x0ff57513,
0x00a40023,
0x00813083,
0x00013403,
0x01010113,
0x00008067,
0x100007b7,
0x00300713,
0x00e781a3,
0x00008067,
0xff010113,
0x00000517,
0x12850513,
0x00113423,
0xf45ff0ef,
0x0000006f,
0x02051513,
0x02059593,
0x00008293,
0x03c000ef,
0x0005051b,
0x00028067,
0x02051513,
0x02059593,
0x02055513,
0x0205d593,
0x00008293,
0x01c000ef,
0x0005851b,
0x00028067,
0xfff00293,
0x0a558c63,
0x06054063,
0x0605c663,
0x00058613,
0x00050593,
0xfff00513,
0x02060c63,
0x00100693,
0x00b67a63,
0x00c05863,
0x00161613,
0x00169693,
0xfeb66ae3,
0x00000513,
0x00c5e663,
0x40c585b3,
0x00d56533,
0x0016d693,
0x00165613,
0xfe0696e3,
0x00008067,
0x00008293,
0xfb5ff0ef,
0x00058513,
0x00028067,
0x40a00533,
0x00b04863,
0x40b005b3,
0xf9dff06f,
0x40b005b3,
0x00008293,
0xf91ff0ef,
0x40a00533,
0x00028067,
0x00008293,
0x0005ca63,
0x00054c63,
0xf79ff0ef,
0x00058513,
0x00028067,
0x40b005b3,
0xfe0558e3,
0x40a00533,
0xf61ff0ef,
0x40b00533,
0x00028067,
0x01f29293,
0xf45514e3,
0x00008067,
0x00000000,
0x6c6c6548,
0x6f57206f,
0x21646c72,
0x0000000a,
  0x00009117,  // auipc sp, 0x9
  0x00100513,  // li      a0,1
  0x00200593,  // li      a1,2
  0x00200613,  // li      a2,2
  0x00200693,  // li      a3,2
  0x00c58933,  // add     s2,a1,a2
  0x00a13423,  // sd      a0,8(sp)
  0x00100073,  // ebreak (used as nemu_trap)
  0xdeadbeef,  // some data
};

static void restart() {
  /* Set the initial program counter. */
  cpu.pc = RESET_VECTOR;

  /* The zero register is always 0. */
  cpu.gpr[0] = 0;

  // riscv64 mstatus initial 0xa00001800;
  cpu.csr[MSTATUS] = 0xa00001800;
}

void init_isa() {
  /* Load built-in image. */
  memcpy(guest_to_host(RESET_VECTOR), img, sizeof(img));

  /* Initialize this virtual computer system. */
  restart();
}
