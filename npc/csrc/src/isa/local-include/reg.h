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

#ifndef __RISCV64_REG_H__
#define __RISCV64_REG_H__

#include <common.h>

static inline int check_reg_idx(int idx) {
  extern int nr_regs;
  IFDEF(CONFIG_RT_CHECK, assert(idx >= 0 && idx < nr_regs));
  return idx;
}

#define gpr(idx) (cpu.gpr[check_reg_idx(idx)])
#define csr(idx) (cpu.csr[check_reg_idx(idx) - 32]) // csr idx bigger than 32;

enum {
  MSTATUS,
  MTVEC,
  MEPC,
  MCAUSE,
  NR_CSRS
};

static inline const char* reg_name(int idx, int width) {
  extern const char* regs[];
  return regs[check_reg_idx(idx)];
}

#endif
