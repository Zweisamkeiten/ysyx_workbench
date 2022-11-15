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

#include <cpu/cpu.h>
#include <cpu/decode.h>
#include <cpu/difftest.h>
#include <locale.h>
#ifdef CONFIG_WATCHPOINT
extern void diff_watchpoint_value();
#endif

/* The assembly code of instructions executed is only output to the screen
 * when the number of instructions executed is less than this value.
 * This is useful when you use the `si' command.
 * You can modify this value as you want.
 */
#define MAX_INST_TO_PRINT 10

CPU_state cpu = {};
uint64_t g_nr_guest_inst = 0;
static uint64_t g_timer = 0; // unit: us
static bool g_print_step = false;

#ifdef CONFIG_ITRACE
void disassemble_inst_to_buf(char *logbuf, size_t bufsize, uint8_t * inst_val, vaddr_t pc, vaddr_t snpc) {
  char *p = logbuf;
  p += snprintf(p, bufsize, FMT_WORD ":", pc);
  int ilen = snpc - pc;
  int i;
  uint8_t *inst = (uint8_t *)&inst_val;
  for (i = ilen - 1; i >= 0; i --) {
    p += snprintf(p, 4, " %02x", inst[i]);
  }
  int ilen_max = MUXDEF(CONFIG_ISA_x86, 8, 4);
  int space_len = ilen_max - ilen;
  if (space_len < 0) space_len = 0;
  space_len = space_len * 3 + 1;
  memset(p, ' ', space_len);
  p += space_len;

  void disassemble(char *str, int size, uint64_t pc, uint8_t *code, int nbyte);
  disassemble(p, logbuf + bufsize - p,
      MUXDEF(CONFIG_ISA_x86, snpc, pc), (uint8_t *)&inst_val, ilen);
}
#ifdef CONFIG_IRINGTRACE
static int iringbuf_index = 0;
static char *iringbuf[16] = {NULL};
static MUXDEF(CONFIG_ISA_x86, uint64_t, uint32_t) *last_inst;
static vaddr_t *snpc;

void print_iringbuf() {
  Log(ANSI_FMT("INSTRUCTIONS RING STRACE:\n", ANSI_FG_RED));
  char logbuf[128];
  disassemble_inst_to_buf(logbuf, 128, (uint8_t *)&last_inst, cpu.pc, *snpc);
  int arrow_len = strlen(" --> ");
  iringbuf[iringbuf_index] = realloc(iringbuf[iringbuf_index], arrow_len + strlen(logbuf) + 1);
  char *p = iringbuf[iringbuf_index];
  memset(p, ' ', arrow_len);
  p += arrow_len;
  strcpy(p, logbuf);

  memmove(iringbuf[iringbuf_index], " --> ", 4);
  for (int i = 0; iringbuf[i] != NULL && i < 16; i++) {
    if (i == iringbuf_index) {
      Log(ANSI_FMT("%s", ANSI_FG_RED), iringbuf[i]);
    }
    else {
      Log(ANSI_FMT("%s", ANSI_FG_GREEN), iringbuf[i]);
    }
    free(iringbuf[i]);
  }
}
#endif
#endif

void device_update();

static void trace_and_difftest(Decode *_this, vaddr_t dnpc) {
#ifdef CONFIG_ITRACE_COND
  if (ITRACE_COND) {
    log_write("%s\n", _this->logbuf);
    #ifdef CONFIG_IRINGTRACE
    int arrow_len = strlen(" --> ");
    iringbuf[iringbuf_index] = realloc(iringbuf[iringbuf_index], arrow_len + strlen(_this->logbuf) + 1);
    char *p = iringbuf[iringbuf_index];
    memset(p, ' ', arrow_len);
    p += arrow_len;
    strcpy(p, _this->logbuf);
    iringbuf_index++;
    iringbuf_index %= 16;
    #endif
  }
#endif
  if (g_print_step) { IFDEF(CONFIG_ITRACE, puts(_this->logbuf)); }
  IFDEF(CONFIG_DIFFTEST, difftest_step(_this->pc, dnpc));
  IFDEF(CONFIG_WATCHPOINT, diff_watchpoint_value());
}

static void exec_once(Decode *s, vaddr_t pc) {
  s->pc = pc;
  s->snpc = pc;
#ifdef CONFIG_IRINGTRACE
  last_inst = &s->isa.inst.val;
  snpc = &s->snpc;
#endif
  isa_exec_once(s);
  cpu.pc = s->dnpc;
#ifdef CONFIG_ITRACE
  disassemble_inst_to_buf(s->logbuf, 128, (uint8_t *)&s->isa.inst.val, s->pc, s->snpc);
#endif
}

static void execute(uint64_t n) {
  Decode s;
  for (;n > 0; n --) {
    exec_once(&s, cpu.pc);
    g_nr_guest_inst ++;
    trace_and_difftest(&s, cpu.pc);
    if (nemu_state.state != NEMU_RUNNING) break;
    IFDEF(CONFIG_DEVICE, device_update());
  }
}

static void statistic() {
  IFNDEF(CONFIG_TARGET_AM, setlocale(LC_NUMERIC, ""));
#define NUMBERIC_FMT MUXDEF(CONFIG_TARGET_AM, "%", "%'") PRIu64
  Log("host time spent = " NUMBERIC_FMT " us", g_timer);
  Log("total guest instructions = " NUMBERIC_FMT, g_nr_guest_inst);
  if (g_timer > 0) Log("simulation frequency = " NUMBERIC_FMT " inst/s", g_nr_guest_inst * 1000000 / g_timer);
  else Log("Finish running in less than 1 us and can not calculate the simulation frequency");
}

void assert_fail_msg() {
#ifdef CONFIG_IRINGTRACE
  print_iringbuf();
#endif
  isa_reg_display();
  statistic();
}

/* Simulate how the CPU works. */
void cpu_exec(uint64_t n) {
  g_print_step = (n < MAX_INST_TO_PRINT);
  switch (nemu_state.state) {
    case NEMU_END: case NEMU_ABORT:
      printf("Program execution has ended. To restart the program, exit NEMU and run again.\n");
      return;
    default: nemu_state.state = NEMU_RUNNING;
  }

  uint64_t timer_start = get_time();

  execute(n);

  uint64_t timer_end = get_time();
  g_timer += timer_end - timer_start;

  switch (nemu_state.state) {
    case NEMU_RUNNING: nemu_state.state = NEMU_STOP; break;

    case NEMU_END: case NEMU_ABORT:
      Log("nemu: %s at pc = " FMT_WORD,
          (nemu_state.state == NEMU_ABORT ? ANSI_FMT("ABORT", ANSI_FG_RED) :
           (nemu_state.halt_ret == 0 ? ANSI_FMT("HIT GOOD TRAP", ANSI_FG_GREEN) :
            ANSI_FMT("HIT BAD TRAP", ANSI_FG_RED))),
          nemu_state.halt_pc);
      // fall through
    case NEMU_QUIT: statistic();
  }
}
