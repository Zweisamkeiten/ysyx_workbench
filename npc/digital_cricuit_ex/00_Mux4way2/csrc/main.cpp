#include "VMux4Way2.h"
#include <nvboard.h>
#include <verilated.h>
#include <verilated_vcd_c.h>

static VMux4Way2 *top;

int main(int argc, char **argv, char **env) {
  top = new VMux4Way2;

  nvboard_bind_pin(&top->y, false, false, 2, SW1, SW0);
  nvboard_bind_pin(&top->x0, false, false, 2, SW3, SW2);
  nvboard_bind_pin(&top->x1, false, false, 2, SW5, SW4);
  nvboard_bind_pin(&top->x2, false, false, 2, SW7, SW6);
  nvboard_bind_pin(&top->x3, false, false, 2, SW9, SW8);
  nvboard_bind_pin(&top->f, false, true, 2, LD1, LD0);
  nvboard_init();

  while (1) {
    top->eval();
    nvboard_update();
  }

  top->final();
  delete top;
}
