#include <stdio.h>
#include <common.h>
#include <isa.h>
#include <memory/paddr.h>

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
