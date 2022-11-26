#include <cpu/cpu.h>
#include <cpu/decode.h>
#include <isa.h>
#include <sim.hpp>
extern "C" {
  #include <memory/paddr.h>
}

CPU_state cpu = {};
ISADecodeInfo inst = {};
#define BUFSIZE 128
#define MAX_INST_TO_PRINT 10
uint64_t g_nr_guest_inst = 0;
static bool g_print_step = false;
#ifdef CONFIG_ITRACE
char itrace_logbuf[BUFSIZE];
#endif

static void trace_and_difftest(vaddr_t dnpc) {
#ifdef CONFIG_ITRACE_COND
  if (ITRACE_COND) {
    log_write("%s\n", _this->logbuf);
  }
#endif
#ifdef CONFIG_IRINGTRACE_COND
  if (IRINGTRACE_COND) {
    int arrow_len = strlen(" --> ");
    iringbuf[iringbuf_index] = realloc(iringbuf[iringbuf_index], arrow_len + strlen(_this->logbuf) + 1);
    char *p = iringbuf[iringbuf_index];
    memset(p, ' ', arrow_len);
    p += arrow_len;
    strcpy(p, _this->logbuf);
    iringbuf_index++;
    iringbuf_index %= 16;
  }
#endif
#ifdef CONFIG_FTRACE
  if (inst_state != INST_OTHER) {
    if (FTRACE_COND) log_write(ANSI_FMT("[FTRACE] %s\n", ANSI_FG_MAGENTA), ftrace_buf);
    printf(ANSI_FMT("[FTRACE] %s\n", ANSI_FG_MAGENTA), ftrace_buf);
    inst_state = INST_OTHER;
  }
#endif
  if (g_print_step) { IFDEF(CONFIG_ITRACE, puts(itrace_logbuf)); }
  IFDEF(CONFIG_DIFFTEST, difftest_step(_this->pc, dnpc));
  IFDEF(CONFIG_WATCHPOINT, diff_watchpoint_value());
}

void exec_once() {
  top->i_inst = paddr_read(top->o_pc, 4);
  cpu.pc = top->o_pc;
  // printf("%lx\n", top->o_pc);
#ifdef CONFIG_ITRACE
  uint32_t test = 0x00009117;
  uint8_t *inst = (uint8_t *)&test;
  char *p = itrace_logbuf;
  p += snprintf(p, BUFSIZE, FMT_WORD ":", cpu.pc);
  for (int i = 3; i >= 0; i --) {
    p += snprintf(p, 4, " %02x", inst[i]);
  }
  int ilen_max = 4;
  int space_len = ilen_max - 4;
  if (space_len < 0) space_len = 0;
  space_len = space_len * 3 + 1;
  memset(p, ' ', space_len);
  p += space_len;

  void disassemble(char *str, int size, uint64_t pc, uint8_t *code, int nbyte);
  disassemble(p, itrace_logbuf + BUFSIZE - p, cpu.pc, (uint8_t *)(inst), 4);
#endif
  single_cycle();
  trace_and_difftest(top->o_pc);
}

static void execute(uint64_t n) {
  for (;n > 0; n --) {
    exec_once();
    g_nr_guest_inst ++;
    if (npc_state.state != NPC_RUNNING) break;
  }
}

/* Simulate how the CPU works. */
void cpu_exec(uint64_t n) {
  g_print_step = (n < MAX_INST_TO_PRINT);
  switch (npc_state.state) {
  case NPC_END:
  case NPC_ABORT:
    printf("Program execution has ended. To restart the program, exit NPC and "
           "run again.\n");
    return;
  default:
    npc_state.state = NPC_RUNNING;
  }

  execute(n);

  switch (npc_state.state) {
  case NPC_RUNNING:
    npc_state.state = NPC_STOP;
    break;

  case NPC_END:
  case NPC_ABORT:
    Log("npc: %s at pc = " FMT_WORD,
        (npc_state.state == NPC_ABORT
             ? ANSI_FMT("ABORT", ANSI_FG_RED)
             : (npc_state.halt_ret == 0
                    ? ANSI_FMT("HIT GOOD TRAP", ANSI_FG_GREEN)
                    : ANSI_FMT("HIT BAD TRAP", ANSI_FG_RED))),
        cpu.pc);
    // fall through
  case NPC_QUIT: break;
  }
}
