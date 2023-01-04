#include <isa.h>
#include "local-include/reg.h"

const char *regs[] = {
  "$0", "ra", "sp", "gp", "tp", "t0", "t1", "t2",
  "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5",
  "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7",
  "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6"
};

void isa_reg_display() {
  for (int i = 0; i < 16; ++i) {
    printf(ANSI_FMT("%s:", ANSI_FG_BLUE) ANSI_FMT("\t0x%016lx\t", ANSI_FG_GREEN) ANSI_FMT("%020lu\t", ANSI_FG_MAGENTA), reg_name(2 * i + 0, 64), gpr(2 * i + 0), gpr(2 * i + 0));
    printf(ANSI_FMT("%s:", ANSI_FG_BLUE) ANSI_FMT("\t0x%016lx\t", ANSI_FG_GREEN) ANSI_FMT("%020lu\n", ANSI_FG_MAGENTA), reg_name(2 * i + 1, 64), gpr(2 * i + 1), gpr(2 * i + 1));
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
