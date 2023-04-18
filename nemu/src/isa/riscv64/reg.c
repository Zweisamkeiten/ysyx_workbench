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
#include "local-include/reg.h"

const int csrs_addr[] = {
  [MSTATUS] = MSTATUS,
  [MTVEC]   = MTVEC,
  [MEPC]    = MEPC,
  [MCAUSE]  = MCAUSE,
};

const char *regs[] = {
  // gprs
  "$0", "ra", "sp", "gp", "tp", "t0", "t1", "t2",
  "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5",
  "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7",
  "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6"
};

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


void isa_reg_display() {
  printf(ANSI_FMT("GPRS:\n", ANSI_FG_MAGENTA));
  for (int i = 0; i < 16; ++i) {
    printf(ANSI_FMT("%s:", ANSI_FG_BLUE) ANSI_FMT("\t" FMT_WORD "\t", ANSI_FG_GREEN) ANSI_FMT("%020lu\t", ANSI_FG_MAGENTA), reg_name(2 * i + 0, 64), gpr(2 * i + 0), gpr(2 * i + 0));
    printf(ANSI_FMT("%s:", ANSI_FG_BLUE) ANSI_FMT("\t" FMT_WORD "\t", ANSI_FG_GREEN) ANSI_FMT("%020lu\n", ANSI_FG_MAGENTA), reg_name(2 * i + 1, 64), gpr(2 * i + 1), gpr(2 * i + 1));
  }
  printf(ANSI_FMT("CSRS:\n", ANSI_FG_MAGENTA));
  for (int i = 0; i < NR_CSREGS; i++) {
    printf(ANSI_FMT("%-7s:", ANSI_FG_BLUE) ANSI_FMT(FMT_WORD "\n", ANSI_FG_GREEN), csr_table[i].name, csr(csr_table[i].addr));
  }
}

word_t isa_reg_str2val(const char *s, bool *success) {
  *success = false;
  for (int i = 0; i < 32; ++i) {
    if (strcmp(s, reg_name(i, 64)) == 0) {
      *success = true;
      return gpr(i);
    }
  }
  if (strcmp(s, "pc") == 0) {
    *success = true;
    return cpu.pc;
  }
  return 0;
}

typedef struct {
  uint64_t *gpr;
  uint32_t inst;
  vaddr_t pc;
} Dut_CPU_state;

void isa_diff_set_regs(void* diff_context) {
  Dut_CPU_state * ctx = (Dut_CPU_state *)diff_context;
  for (int i = 1; i < 32; i++) {
    cpu.gpr[i] = ctx->gpr[i];
  }
  // cpu.pc = ctx->pc;
}

void isa_diff_get_regs(void *diff_context) {
  Dut_CPU_state * ctx = (Dut_CPU_state *)diff_context;
  for (int i = 1; i < 32; i++) {
    ctx->gpr[i] = cpu.gpr[i];
  }
  // ctx->pc = cpu.pc;
}
