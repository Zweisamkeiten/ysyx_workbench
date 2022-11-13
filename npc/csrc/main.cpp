#include "Vtop.h"
#include <verilated.h>
#include <verilated_vcd_c.h>
#include <stdio.h>

static Vtop *top;

static void single_cycle() {
  top->i_clk = 0;
  top->eval();
  top->i_clk = 1;
  top->eval();
}

static void reset(int n) {
  top->i_rst = 1;
  while (n-- > 0)
    single_cycle();
  top->i_rst = 0;
}

int main(int argc, char **argv, char **env) {
  top = new Vtop;

  reset(10);

  while (1) {
    printf("out: %lx\n", top->out);
    single_cycle();
  }

  top->final();
  delete top;
}
