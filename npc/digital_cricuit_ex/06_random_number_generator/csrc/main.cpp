#include "Vtop.h"
#include <nvboard.h>
#include <stdio.h>
#include <verilated.h>
#include <verilated_vcd_c.h>

static Vtop *top;

void nvboard_bind_all_pins(Vtop *top);

int main(int argc, char **argv, char **env) {
  top = new Vtop;

  nvboard_bind_all_pins(top);
  nvboard_init();
  top->init = 0b00000001;

  while (1) {
    top->eval();
    printf("%#04x\n", top->init);
    printf("%#04x\n", top->out);
    nvboard_update();
  }

  top->final();
  delete top;
}
