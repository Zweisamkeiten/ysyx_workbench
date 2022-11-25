#ifndef __SIM_H__
#define __SIM_H__

#include "Vtop.h"
#include "Vtop__Dpi.h"
#include <verilated.h>
#include <verilated_vcd_c.h>
#include <verilated_dpi.h>

extern Vtop *top;
extern VerilatedContext *contextp;
extern VerilatedVcdC *tfp;

extern void single_cycle();

#endif
