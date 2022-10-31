#include "Vtop.h"
#include <nvboard.h>
#include <verilated.h>
#include <verilated_vcd_c.h>

static Vtop *top;

int main(int argc, char **argv, char **env) {
  top = new Vtop;

  nvboard_init();

  while (1) {
    top->eval();
    nvboard_update();
  }

  top->final();
  delete top;
}
