// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "verilated.h"

#include "Vtop__Syms.h"
#include "Vtop___024root.h"

VL_ATTR_COLD void Vtop___024root___initial__TOP__0(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___initial__TOP__0\n"); );
    // Init
    VlWide<5>/*159:0*/ __Vtemp_hfa1e3f21__0;
    // Body
    __Vtemp_hfa1e3f21__0[0U] = 0x2e766364U;
    __Vtemp_hfa1e3f21__0[1U] = 0x64756d70U;
    __Vtemp_hfa1e3f21__0[2U] = 0x766c745fU;
    __Vtemp_hfa1e3f21__0[3U] = 0x6f67732fU;
    __Vtemp_hfa1e3f21__0[4U] = 0x6cU;
    vlSymsp->_vm_contextp__->dumpfile(VL_CVT_PACK_STR_NW(5, __Vtemp_hfa1e3f21__0));
    vlSymsp->_traceDumpOpen();
}
