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
  0x01c1ff14,
  0x00000bef,
  0x857d01b8,
  0xc5010038,
  0x0101ff14,
  0x05052014,
  0x85058494,
  0x34110024,
  0x30810024,
  0x000004ef,
  0x00c007ef,
  0x04000018,
  0x04441a14,
  0x05800414,
  0x04140014,
  0x00c001ef,
  0x45040004,
  0x1a05fee4,
  0x30810084,
  0x34010004,
  0x01010114,
  0x80000068,
  0x070010b8,
  0x80a70024,
  0x80000068,
  0x0101ff14,
  0x07050094,
  0x30810024,
  0x34110024,
  0x04001038,
  0x85050014,
  0x9547009b,
  0x0730f894,
  0x01f400a4,
  0x004008ef,
  0x75f50f14,
  0x00a40024,
  0x30810084,
  0x34010004,
  0x01010114,
  0x80000068,
  0x070010b8,
  0x07300014,
  0x81e700a4,
  0x80000068,
  0x0101ff14,
  0x05000018,
  0x05851214,
  0x34110024,
  0xf05ff4ef,
  0x0000006f,
  0x15050214,
  0x95050294,
  0x82000094,
  0x00c003ef,
  0x0505001b,
  0x80020068,
  0x15050214,
  0x95050294,
  0x55050214,
  0xd5050294,
  0x82000094,
  0x00c001ef,
  0x8505001b,
  0x80020068,
  0x02f0ff94,
  0x8c550a64,
  0x40050664,
  0xc6050664,
  0x86050014,
  0x05050094,
  0x05f0ff14,
  0x0c060264,
  0x06100094,
  0x7ab60064,
  0x58c00064,
  0x16160014,
  0x96160094,
  0x6ab6fee4,
  0x05000014,
  0xe6c50064,
  0x85c540b4,
  0x65d50034,
  0xd6160094,
  0x56160014,
  0x9606fee4,
  0x80000068,
  0x82000094,
  0xf05ffbef,
  0x85050014,
  0x80020068,
  0x05a04034,
  0x48b00064,
  0x05b040b4,
  0xf0dff96f,
  0x05b040b4,
  0x82000094,
  0xf01ff9ef,
  0x05a04034,
  0x80020068,
  0x82000094,
  0xca050064,
  0x4c050064,
  0xf09ff7ef,
  0x85050014,
  0x80020068,
  0x05b040b4,
  0x5805fee4,
  0x05a04034,
  0xf01ff6ef,
  0x05b04034,
  0x80020068,
  0x92f20194,
  0x1455f4e4,
  0x80000068,
  0x00000001,
  0x656c6c49,
  0x20576f6f,
  0x6c642173,
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
