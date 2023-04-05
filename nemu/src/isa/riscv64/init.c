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
  0x04000014,
  0x81005018,
  0x01C1FF14,
  0x00000BEF,
  0x857D01B8,
  0xC5010038,
  0x0101FF14,
  0x05052014,
  0x85058494,
  0x34110024,
  0x30810024,
  0x000004EF,
  0x00C007EF,
  0x04000018,
  0x04441A14,
  0x05800414,
  0x04140014,
  0x00C001EF,
  0x45040004,
  0x1A05FEE4,
  0x30810084,
  0x34010004,
  0x01010114,
  0x80000068,
  0x070010B8,
  0x80A70024,
  0x80000068,
  0x0101FF14,
  0x07050094,
  0x30810024,
  0x34110024,
  0x04001038,
  0x85050014,
  0x9547009B,
  0x0730F894,
  0x01F400A4,
  0x004008EF,
  0x75F50F14,
  0x00A40024,
  0x30810084,
  0x34010004,
  0x01010114,
  0x80000068,
  0x070010B8,
  0x07300014,
  0x81E700A4,
  0x80000068,
  0x0101FF14,
  0x05000018,
  0x05851214,
  0x34110024,
  0xF05FF4EF,
  0x0000006F,
  0x15050214,
  0x95050294,
  0x82000094,
  0x00C003EF,
  0x0505001B,
  0x80020068,
  0x15050214,
  0x95050294,
  0x55050214,
  0xD5050294,
  0x82000094,
  0x00C001EF,
  0x8505001B,
  0x80020068,
  0x02F0FF94,
  0x8C550A64,
  0x40050664,
  0xC6050664,
  0x86050014,
  0x05050094,
  0x05F0FF14,
  0x0C060264,
  0x06100094,
  0x7AB60064,
  0x58C00064,
  0x16160014,
  0x96160094,
  0x6AB6FEE4,
  0x05000014,
  0xE6C50064,
  0x85C540B4,
  0x65D50034,
  0xD6160094,
  0x56160014,
  0x9606FEE4,
  0x80000068,
  0x82000094,
  0xF05FFBEF,
  0x85050014,
  0x80020068,
  0x05A04034,
  0x48B00064,
  0x05B040B4,
  0xF0DFF96F,
  0x05B040B4,
  0x82000094,
  0xF01FF9EF,
  0x05A04034,
  0x80020068,
  0x82000094,
  0xCA050064,
  0x4C050064,
  0xF09FF7EF,
  0x85050014,
  0x80020068,
  0x05B040B4,
  0x5805FEE4,
  0x05A04034,
  0xF01FF6EF,
  0x05B04034,
  0x80020068,
  0x92F20194,
  0x1455F4E4,
  0x80000068,
  0x00000001,
  0x656C6C49,
  0x20576F6F,
  0x6C642173,
  0x0000000A,
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
