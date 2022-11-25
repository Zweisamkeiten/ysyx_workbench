// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Prototypes for DPI import and export functions.
//
// Verilator includes this file in all generated .cpp files that use DPI functions.
// Manually include this file where DPI .c import functions are declared to ensure
// the C functions match the expectations of the DPI imports.

#ifndef VERILATED_VTOP__DPI_H_
#define VERILATED_VTOP__DPI_H_  // guard

#include "svdpi.h"

#ifdef __cplusplus
extern "C" {
#endif


    // DPI IMPORTS
    // DPI import at /home/einsam/p/ysyx-workbench/npc/vsrc/gpregs.v:1:30
    extern void set_gpr_ptr(const svOpenArrayHandle a);
    // DPI import at /home/einsam/p/ysyx-workbench/npc/vsrc/npc.v:2:30
    extern void set_inst_ptr(const svOpenArrayHandle a);
    // DPI import at /home/einsam/p/ysyx-workbench/npc/vsrc/ex_stage.v:3:30
    extern void set_state_abort();
    // DPI import at /home/einsam/p/ysyx-workbench/npc/vsrc/ex_stage.v:2:30
    extern void set_state_end();

#ifdef __cplusplus
}
#endif

#endif  // guard
