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

#include <isa.h>
#include "local-include/reg.h"

const char *regs[] = {
  // gprs
  "$0", "ra", "sp", "gp", "tp", "t0", "t1", "t2",
  "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5",
  "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7",
  "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6"
};

csr csr_table[] = {
  {"mstatus", 0x300, MSTATUS},
  {"mtvec", 0x305, MTVEC},
  {"mepc", 0x341, MEPC},
  {"mcause", 0x342, MCAUSE},
};

void isa_reg_display() {
  printf(ANSI_FMT("GPRS:\n", ANSI_FG_MAGENTA));
  for (int i = 0; i < 16; ++i) {
    printf(ANSI_FMT("%-2d %s:", ANSI_FG_BLUE) ANSI_FMT("\t" FMT_WORD "\t", ANSI_FG_GREEN) ANSI_FMT("%020lu\t", ANSI_FG_MAGENTA), 2*i, reg_name(2 * i + 0, 64), gpr(2 * i + 0), gpr(2 * i + 0));
    printf(ANSI_FMT("%-2d %s:", ANSI_FG_BLUE) ANSI_FMT("\t" FMT_WORD "\t", ANSI_FG_GREEN) ANSI_FMT("%020lu\n", ANSI_FG_MAGENTA), 2*i+1, reg_name(2 * i + 1, 64), gpr(2 * i + 1), gpr(2 * i + 1));
  }
  printf(ANSI_FMT("CSRS:\n", ANSI_FG_MAGENTA));
  for (int i = 0; i < NR_CSREGS; i++) {
    printf(ANSI_FMT("%-7s:", ANSI_FG_BLUE) ANSI_FMT(FMT_WORD "\n", ANSI_FG_GREEN), csr_table[i].name, csr(csr_table[i].index));
  }
  printf(ANSI_FMT("PC:\n", ANSI_FG_MAGENTA));
  printf(ANSI_FMT("%-7s:", ANSI_FG_BLUE) ANSI_FMT(FMT_WORD "\n", ANSI_FG_GREEN), "pc", cpu.pc);
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
