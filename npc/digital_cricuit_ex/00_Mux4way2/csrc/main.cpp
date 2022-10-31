#include "VMux4Way2.h"
#include <verilated.h>
#include <verilated_vcd_c.h>

VerilatedContext *contextp = NULL;
VerilatedVcdC *tfp = NULL;

static VMux4Way2 *top;

void step_and_dump_wave() {
  top->eval();
  contextp->timeInc(1);
  tfp->dump(contextp->time());
}

void sim_init() {
  contextp = new VerilatedContext;
  tfp = new VerilatedVcdC;
  top = new VMux4Way2;
  contextp->traceEverOn(true);
  top->trace(tfp, 0);
  tfp->open("build/logs/dump.vcd");
}

void sim_exit() {
  step_and_dump_wave();
  tfp->close();
}

int main(int argc, char **argv, char **env) {
  sim_init();

  sim_exit();
}
