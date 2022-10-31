// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vlight.h for the primary calling header

#include "verilated.h"

#include "Vlight___024root.h"

VL_INLINE_OPT void Vlight___024root___sequent__TOP__0(Vlight___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vlight__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlight___024root___sequent__TOP__0\n"); );
    // Init
    SData/*15:0*/ __Vdly__led;
    IData/*31:0*/ __Vdly__light__DOT__count;
    // Body
    __Vdly__light__DOT__count = vlSelf->light__DOT__count;
    __Vdly__led = vlSelf->led;
    if (vlSelf->rst) {
        __Vdly__led = 1U;
        __Vdly__light__DOT__count = 0U;
    } else {
        if ((0U == vlSelf->light__DOT__count)) {
            __Vdly__led = ((0xfffeU & ((IData)(vlSelf->led) 
                                       << 1U)) | (1U 
                                                  & ((IData)(vlSelf->led) 
                                                     >> 0xfU)));
        }
        __Vdly__light__DOT__count = ((0x4c4b40U <= vlSelf->light__DOT__count)
                                      ? 0U : ((IData)(1U) 
                                              + vlSelf->light__DOT__count));
    }
    vlSelf->led = __Vdly__led;
    vlSelf->light__DOT__count = __Vdly__light__DOT__count;
}

void Vlight___024root___eval(Vlight___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vlight__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlight___024root___eval\n"); );
    // Body
    if (((IData)(vlSelf->clk) & (~ (IData)(vlSelf->__Vclklast__TOP__clk)))) {
        Vlight___024root___sequent__TOP__0(vlSelf);
    }
    // Final
    vlSelf->__Vclklast__TOP__clk = vlSelf->clk;
}

#ifdef VL_DEBUG
void Vlight___024root___eval_debug_assertions(Vlight___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vlight__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vlight___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelf->rst & 0xfeU))) {
        Verilated::overWidthError("rst");}
}
#endif  // VL_DEBUG
