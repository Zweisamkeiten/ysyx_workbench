#include <cpu/cpu.h>
#include <cpu/decode.h>
#include <isa.h>
#include <sim.h>
#include <memory/paddr.h>

CPU_state cpu = {};
#define BUFSIZE 128
#ifdef CONFIG_ITRACE
static char itrace_logbuf[BUFSIZE];
#endif

void exec_once() {
  top->i_inst = paddr_read(top->o_pc, 4);
  cpu.pc = top->o_pc;
  // printf("%lx\n", top->o_pc);
  #ifdef CONFIG_ITRACE
  uint8_t *inst = (uint8_t *)(cpu.inst);
  char *p = itrace_logbuf;
  p += snprintf(p, BUFSIZE, FMT_WORD ":", cpu.pc);
  for (int i = 3; i >= 0; i --) {
    p += snprintf(p, 4, " %02x", inst[i]);
  }
  void disassemble(char *str, int size, uint64_t pc, uint8_t *code, int nbyte);
  disassemble(p, itrace_logbuf + BUFSIZE - p, cpu.pc, (uint8_t *)cpu.inst, 4);
#endif
  single_cycle();
}

static void execute(uint64_t n) {
  for (;n > 0; n --) {
    exec_once();
    if (npc_state.state != NPC_RUNNING) break;
  }
}

/* Simulate how the CPU works. */
void cpu_exec(uint64_t n) {
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
