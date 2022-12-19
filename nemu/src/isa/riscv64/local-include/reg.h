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

#ifndef __RISCV64_REG_H__
#define __RISCV64_REG_H__

#include <common.h>

static inline int check_reg_idx(int idx) {
  IFDEF(CONFIG_RT_CHECK, assert(idx >= 0 && idx < 32));
  return idx;
}

static inline int check_csr_addr(int addr) {
  IFDEF(CONFIG_RT_CHECK, assert(addr >= 0 && addr < 4096));
  return addr;
}

#define gpr(idx) (cpu.gpr[check_reg_idx(idx)])
#define csr(addr) (cpu.csr[check_csr_addr(addr)])

typedef enum {
  MSTATUS = 0x300,
  MTVEC = 0x305,
  MEPC = 0x341,
  MCAUSE = 0x342
} csr_addr;

struct {
  const char *name;
  const int addr;
} csr_table[] = {
  {"mstatus", MSTATUS},
  {"mtvec", MTVEC},
  {"mepc", MEPC},
  {"mcause", MCAUSE},
};

#define NR_CSREGS ARRLEN(csr_table)

static inline const char* reg_name(int idx, int width) {
  extern const char* regs[];
  return regs[check_reg_idx(idx)];
}

#endif
