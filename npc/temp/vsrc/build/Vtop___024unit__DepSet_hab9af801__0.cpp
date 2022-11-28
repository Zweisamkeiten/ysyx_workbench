// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "verilated.h"
#include "verilated_dpi.h"

#include "Vtop__Syms.h"
#include "Vtop___024unit.h"

extern "C" void set_inst_ptr(const svOpenArrayHandle a);

VL_INLINE_OPT void Vtop___024unit____Vdpiimwrap_set_inst_ptr__Vdpioc2_TOP____024unit(const IData/*31:0*/ &a) {
    VL_DEBUG_IF(VL_DBG_MSGF("+        Vtop___024unit____Vdpiimwrap_set_inst_ptr__Vdpioc2_TOP____024unit\n"); );
    // Body
    static const VerilatedVarProps a__Vopenprops(VLVT_UINT32, VLVD_IN, VerilatedVarProps::Packed(), 31, 0);
    VerilatedDpiOpenVar a__Vopenarray (&a__Vopenprops, &a);
    set_inst_ptr(&a__Vopenarray);
}

extern "C" void set_pc_ptr(const svOpenArrayHandle a);

VL_INLINE_OPT void Vtop___024unit____Vdpiimwrap_set_pc_ptr__Vdpioc2_TOP____024unit(const IData/*31:0*/ &a) {
    VL_DEBUG_IF(VL_DBG_MSGF("+        Vtop___024unit____Vdpiimwrap_set_pc_ptr__Vdpioc2_TOP____024unit\n"); );
    // Body
    static const VerilatedVarProps a__Vopenprops(VLVT_UINT32, VLVD_IN, VerilatedVarProps::Packed(), 31, 0);
    VerilatedDpiOpenVar a__Vopenarray (&a__Vopenprops, &a);
    set_pc_ptr(&a__Vopenarray);
}
