// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "verilated.h"
#include "verilated_dpi.h"

#include "Vtop__Syms.h"
#include "Vtop___024root.h"

void Vtop___024unit____Vdpiimwrap_set_inst_ptr__Vdpioc2_TOP____024unit(const IData/*31:0*/ &a);
void Vtop___024unit____Vdpiimwrap_set_pc_ptr__Vdpioc2_TOP____024unit(const IData/*31:0*/ &a);

VL_ATTR_COLD void Vtop___024root___eval_initial__TOP(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_initial__TOP\n"); );
    // Body
    Vtop___024unit____Vdpiimwrap_set_inst_ptr__Vdpioc2_TOP____024unit((IData)(vlSelf->ysyx_22050710_npc__DOT__u_ifu__DOT__rdata));
    Vtop___024unit____Vdpiimwrap_set_pc_ptr__Vdpioc2_TOP____024unit((IData)(vlSelf->ysyx_22050710_npc__DOT__u_ifu__DOT__rdata));
}
