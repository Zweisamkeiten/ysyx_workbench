// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "VMux4Way2__Syms.h"


void VMux4Way2___024root__trace_chg_sub_0(VMux4Way2___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void VMux4Way2___024root__trace_chg_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VMux4Way2___024root__trace_chg_top_0\n"); );
    // Init
    VMux4Way2___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<VMux4Way2___024root*>(voidSelf);
    VMux4Way2__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    VMux4Way2___024root__trace_chg_sub_0((&vlSymsp->TOP), bufp);
}

void VMux4Way2___024root__trace_chg_sub_0(VMux4Way2___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    VMux4Way2__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VMux4Way2___024root__trace_chg_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    // Body
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[1U])) {
        bufp->chgSData(oldp+0,(vlSelf->Mux4Way2__DOT____Vcellinp__i0__lut),16);
        bufp->chgCData(oldp+1,(vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__pair_list[0]),4);
        bufp->chgCData(oldp+2,(vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__pair_list[1]),4);
        bufp->chgCData(oldp+3,(vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__pair_list[2]),4);
        bufp->chgCData(oldp+4,(vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__pair_list[3]),4);
        bufp->chgCData(oldp+5,(vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+6,(vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+7,(vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+8,(vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+9,(vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__data_list[0]),2);
        bufp->chgCData(oldp+10,(vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__data_list[1]),2);
        bufp->chgCData(oldp+11,(vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__data_list[2]),2);
        bufp->chgCData(oldp+12,(vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__data_list[3]),2);
        bufp->chgCData(oldp+13,(vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__lut_out),2);
        bufp->chgBit(oldp+14,(vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__hit));
    }
    bufp->chgCData(oldp+15,(vlSelf->x0),2);
    bufp->chgCData(oldp+16,(vlSelf->x1),2);
    bufp->chgCData(oldp+17,(vlSelf->x2),2);
    bufp->chgCData(oldp+18,(vlSelf->x3),2);
    bufp->chgCData(oldp+19,(vlSelf->y),2);
    bufp->chgCData(oldp+20,(vlSelf->f),2);
}

void VMux4Way2___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VMux4Way2___024root__trace_cleanup\n"); );
    // Init
    VMux4Way2___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<VMux4Way2___024root*>(voidSelf);
    VMux4Way2__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
}
