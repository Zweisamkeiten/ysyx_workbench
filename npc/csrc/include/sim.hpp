#ifndef __SIM_H__
#define __SIM_H__

#include "Vtop.h"
#include "Vtop__Dpi.h"
// #include "Vtop_ysyx_22050710_npc.h"
#include <Vtop___024root.h>
#include <verilated_vcd_c.h>
#include <verilated_dpi.h>

extern "C" Vtop *top;
extern "C" VerilatedContext *contextp;
extern "C" VerilatedVcdC *tfp;
extern "C" uint32_t * npcinst;

extern "C" void single_cycle(int rst);

#endif
