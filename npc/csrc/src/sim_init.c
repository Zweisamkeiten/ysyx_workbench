#include <sim.h>
#include <common.h>
#include <isa.h>

Vtop *top;
VerilatedContext *contextp = NULL;
VerilatedVcdC *tfp = NULL;

void single_cycle() {
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

void init_sim() {
  contextp = new VerilatedContext;
  tfp = new VerilatedVcdC;
  top = new Vtop;

  contextp->traceEverOn(true);
  top->trace(tfp, 0);
  tfp->open("dump.vcd");

  reset(10);

  npc_state.state = NPC_RUNNING;

  cpu.pc = top->o_pc;
}

void end_sim() {
  top->final();
  delete top;
  tfp->close();
}
