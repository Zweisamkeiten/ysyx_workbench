#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
// Include common routines
#include <verilated.h>
// Include model header, generated from Verilating "top.v"
#include "Vtop.h"
#include <nvboard.h>

int main(int argc, char *argv[], char **env) {
  // Prevent unused variable warnings
  if (false && argc && argv && env) {
  }

  // Create logs/ directory in case we have traces to put under it
  // 创建波形图放置目录
  Verilated::mkdir("build/logs");

  // Construct a VerilatedContext to hold simulation time, etc.
  // 构造 上下文
  VerilatedContext *contextp = new VerilatedContext;
  // Verilator must compute traced signals
  contextp->traceEverOn(true);

  // Construct the Verilated model, from Vtop.h generated from Verilating
  // "top.v"
  // 构造模型
  Vtop *top = new Vtop{contextp};

  nvboard_bind_pin(&top->a, false, false, 1, SW0);
  nvboard_bind_pin(&top->b, false, false, 1, SW1);
  nvboard_bind_pin(&top->f, false, true, 1, LD0);
  nvboard_init();

  // Simulate until $finish
  // 仿真
  while (!contextp->gotFinish()) {
    contextp->timeInc(1); // 1 timeprecision period passes...
    int a = rand() & 1;
    int b = rand() & 1;
    top->a = a;
    top->b = b;

    // Evaluate model
    top->eval();

    printf("a = %d, b = %d, f = %d\n", a, b, top->f);
    assert(top->f == (a ^ b));
    nvboard_update();
  }

  // Final model cleanup
  top->final();

  // Destroy model
  delete top;

  // Return good completion status
  return 0;
}
