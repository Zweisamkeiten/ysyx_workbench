// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See VMux4Way2.h for the primary calling header

#include "verilated.h"

#include "VMux4Way2___024root.h"

VL_INLINE_OPT void VMux4Way2___024root___combo__TOP__0(VMux4Way2___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VMux4Way2__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VMux4Way2___024root___combo__TOP__0\n"); );
    // Body
    vlSelf->Mux4Way2__DOT____Vcellinp__i0__lut = (0x48cU 
                                                  | (((IData)(vlSelf->x0) 
                                                      << 0xcU) 
                                                     | (((IData)(vlSelf->x1) 
                                                         << 8U) 
                                                        | (((IData)(vlSelf->x2) 
                                                            << 4U) 
                                                           | (IData)(vlSelf->x3)))));
    vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__pair_list[0U] 
        = (0xfU & (IData)(vlSelf->Mux4Way2__DOT____Vcellinp__i0__lut));
    vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__pair_list[1U] 
        = (0xfU & ((IData)(vlSelf->Mux4Way2__DOT____Vcellinp__i0__lut) 
                   >> 4U));
    vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__pair_list[2U] 
        = (0xfU & ((IData)(vlSelf->Mux4Way2__DOT____Vcellinp__i0__lut) 
                   >> 8U));
    vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__pair_list[3U] 
        = (0xfU & ((IData)(vlSelf->Mux4Way2__DOT____Vcellinp__i0__lut) 
                   >> 0xcU));
    vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__data_list[0U] 
        = (3U & vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__pair_list
           [0U]);
    vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__data_list[1U] 
        = (3U & vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__pair_list
           [1U]);
    vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__data_list[2U] 
        = (3U & vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__pair_list
           [2U]);
    vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__data_list[3U] 
        = (3U & vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__pair_list
           [3U]);
    vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__key_list[0U] 
        = (3U & (vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__pair_list
                 [0U] >> 2U));
    vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__key_list[1U] 
        = (3U & (vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__pair_list
                 [1U] >> 2U));
    vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__key_list[2U] 
        = (3U & (vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__pair_list
                 [2U] >> 2U));
    vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__key_list[3U] 
        = (3U & (vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__pair_list
                 [3U] >> 2U));
    vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__hit = 
        ((IData)(vlSelf->y) == vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__key_list
         [0U]);
    vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__hit = 
        ((IData)(vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__hit) 
         | ((IData)(vlSelf->y) == vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__key_list
            [1U]));
    vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__hit = 
        ((IData)(vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__hit) 
         | ((IData)(vlSelf->y) == vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__key_list
            [2U]));
    vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__hit = 
        ((IData)(vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__hit) 
         | ((IData)(vlSelf->y) == vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__key_list
            [3U]));
    vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__lut_out 
        = ((- (IData)(((IData)(vlSelf->y) == vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__key_list
                       [0U]))) & vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__data_list
           [0U]);
    vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__lut_out 
        = ((IData)(vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__lut_out) 
           | ((- (IData)(((IData)(vlSelf->y) == vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__key_list
                          [1U]))) & vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__data_list
              [1U]));
    vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__lut_out 
        = ((IData)(vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__lut_out) 
           | ((- (IData)(((IData)(vlSelf->y) == vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__key_list
                          [2U]))) & vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__data_list
              [2U]));
    vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__lut_out 
        = ((IData)(vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__lut_out) 
           | ((- (IData)(((IData)(vlSelf->y) == vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__key_list
                          [3U]))) & vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__data_list
              [3U]));
    vlSelf->f = vlSelf->Mux4Way2__DOT__i0__DOT__i0__DOT__lut_out;
}

void VMux4Way2___024root___eval(VMux4Way2___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VMux4Way2__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VMux4Way2___024root___eval\n"); );
    // Body
    VMux4Way2___024root___combo__TOP__0(vlSelf);
    vlSelf->__Vm_traceActivity[1U] = 1U;
}

#ifdef VL_DEBUG
void VMux4Way2___024root___eval_debug_assertions(VMux4Way2___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VMux4Way2__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VMux4Way2___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->x0 & 0xfcU))) {
        Verilated::overWidthError("x0");}
    if (VL_UNLIKELY((vlSelf->x1 & 0xfcU))) {
        Verilated::overWidthError("x1");}
    if (VL_UNLIKELY((vlSelf->x2 & 0xfcU))) {
        Verilated::overWidthError("x2");}
    if (VL_UNLIKELY((vlSelf->x3 & 0xfcU))) {
        Verilated::overWidthError("x3");}
    if (VL_UNLIKELY((vlSelf->y & 0xfcU))) {
        Verilated::overWidthError("y");}
}
#endif  // VL_DEBUG
