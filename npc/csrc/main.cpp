#include <stdio.h>
#include <stdarg.h>
#include <common.h>
#include <isa.h>
#include <memory/paddr.h>

static const uint32_t img [] = {
  0x00100093,
  0x00200113,
  0x00300193,
  0x00400213,
  0x00500293,
  0x00600313,
  0x00100073,
};

NPCState npc_state = {.state = NPC_STOP};

void init_monitor(int, char *[]);
void engine_start();
int is_exit_status_bad();
void end_sim();

int main(int argc, char **argv, char **env) {

  init_monitor(argc, argv);

  /* Start engine. */
  engine_start();

  end_sim();

  switch (npc_state.state) {
    case NPC_END: printf(ANSI_FMT( "Successful exit.\n", ANSI_FG_GREEN)); break;
    case NPC_ABORT: printf(ANSI_FMT("Unimplemented inst at PC: 0x%016lx\n", ANSI_FG_RED), cpu.pc); exit(1);
  }
}
