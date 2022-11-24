#include "Vtop.h"
#include "Vtop__Dpi.h"
#include <verilated.h>
#include <verilated_vcd_c.h>
#include <stdio.h>
#include <stdarg.h>
#include <common.h>
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

static Vtop *top;
VerilatedContext *contextp = NULL;
VerilatedVcdC *tfp = NULL;

static void single_cycle() {
  top->i_clk = 0;
  top->eval();
  contextp->timeInc(1);
  tfp->dump(contextp->time());
  top->i_clk = 1;
  top->eval();
  contextp->timeInc(1);
  tfp->dump(contextp->time());
}

static void reset(int n) {
  top->i_rst = 1;
  while (n-- > 0) {
    single_cycle();
  }
  top->i_rst = 0;
}

NPCState npc_state = {.state = NPC_STOP};

void set_state_end() {
  npc_state.state = NPC_END;
}

void set_state_abort() {
  npc_state.state = NPC_ABORT;
}

int main(int argc, char **argv, char **env) {

  contextp = new VerilatedContext;
  tfp = new VerilatedVcdC;
  top = new Vtop;

  contextp->traceEverOn(true);
  top->trace(tfp, 0);
  tfp->open("dump.vcd");


  reset(10);

  if (argc == 2) {
    FILE *fp = fopen(argv[1], "rb");
    if (fp == NULL) fprintf(stderr, "Can not open '%s\n'", argv[1]);
    assert(fp != NULL);

    fseek(fp, 0, SEEK_END);
    long size = ftell(fp);

    fprintf(stdout, "The image is %s, size = %ld\n", argv[1], size);

    fseek(fp, 0, SEEK_SET);
    int ret = fread(guest_to_host(RESET_VECTOR), size, 1, fp);
    assert(ret == 1);

    fclose(fp);
  }
  else {
    memcpy(guest_to_host(RESET_VECTOR), img, sizeof(img));
  }

  npc_state.state = NPC_RUNNING;
  word_t last = top->o_pc;
  while (1) {
    top->i_inst = pmem_read(top->o_pc, 4);
    last = top->o_pc;
    // printf("%lx\n", top->o_pc);
    single_cycle();
    if (npc_state.state != NPC_RUNNING) break;
  }

  top->final();
  delete top;
  tfp->close();

  switch (npc_state.state) {
    case NPC_END: printf(ANSI_FMT( "Successful exit.\n", ANSI_FG_GREEN)); break;
    case NPC_ABORT: printf(ANSI_FMT("Unimplemented inst at PC: 0x%016lx\n", ANSI_FG_RED), last); exit(1);
  }
}
