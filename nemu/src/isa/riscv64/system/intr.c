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
#include "../local-include/reg.h"

word_t isa_raise_intr(word_t NO, vaddr_t epc) {
  /* TODO: Trigger an interrupt/exception with ``NO''.
   * Then return the address of the interrupt/exception vector.
   */

  cpu.csr[MEPC] = epc;
  cpu.csr[MCAUSE] = NO;

#ifdef CONFIG_ETRACE
  if (ETRACE_COND) log_write(ANSI_FMT("[ETRACE] Exception occurs at pc [", ANSI_FG_CYAN)
                             ANSI_FMT(FMT_WORD , ANSI_FG_RED)
                             ANSI_FMT("] Exception code: ", ANSI_FG_CYAN)
                             ANSI_FMT("%lu ", ANSI_FG_RED)
                             ANSI_FMT("and pc trap into [", ANSI_FG_CYAN)
                             ANSI_FMT(FMT_WORD, ANSI_FG_RED)
                             ANSI_FMT("]", ANSI_FG_CYAN)
                             , epc, NO, cpu.csr[MTVEC]);
  printf(ANSI_FMT("[ETRACE] Exception occurs at pc [", ANSI_FG_CYAN)
         ANSI_FMT(FMT_WORD , ANSI_FG_RED)
         ANSI_FMT("] Exception code:", ANSI_FG_CYAN)
         ANSI_FMT("%lu", ANSI_FG_RED)
         ANSI_FMT("and pc trap into [", ANSI_FG_CYAN)
         ANSI_FMT(FMT_WORD, ANSI_FG_RED)
         ANSI_FMT("]\n", ANSI_FG_CYAN)
         , epc, NO, cpu.csr[MTVEC]);
#endif

  return cpu.csr[MTVEC];
}

word_t isa_query_intr() {
  return INTR_EMPTY;
}
