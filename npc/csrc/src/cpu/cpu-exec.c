#include <cpu/cpu.h>
#include <cpu/decode.h>
#include <isa.h>
#include <sim.h>
#include <memory/paddr.h>

CPU_state cpu = {};

void exec_once() {
  top->i_inst = paddr_read(top->o_pc, 4);
  cpu.pc = top->o_pc;
  // printf("%lx\n", top->o_pc);
  single_cycle();
}

static void execute(uint64_t n) {
  Decode s;
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
        npc_state.halt_pc);
    // fall through
  case NPC_QUIT: break;
  }
}
