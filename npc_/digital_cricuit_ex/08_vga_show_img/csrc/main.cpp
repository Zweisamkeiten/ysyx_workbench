#include "Vtop.h"
#include <nvboard.h>
#include <verilated.h>
#include <verilated_vcd_c.h>

static Vtop *top;

void nvboard_bind_all_pins(Vtop *top);

static void single_cycle() {
  top->clk = 0;
  top->eval();
  top->clk = 1;
  top->eval();
}

static void reset(int n) {
  top->rst = 1;
  while (n-- > 0)
    single_cycle();
  top->rst = 0;
}

int main(int argc, char **argv, char **env) {
  top = new Vtop;

  nvboard_bind_all_pins(top);
  nvboard_init();

  reset(10);

  while (1) {
    nvboard_update();
    single_cycle();
  }

  top->final();
  delete top;
}
