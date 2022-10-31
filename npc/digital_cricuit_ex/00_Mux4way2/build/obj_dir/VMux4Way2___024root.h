// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See VMux4Way2.h for the primary calling header

#ifndef VERILATED_VMUX4WAY2___024ROOT_H_
#define VERILATED_VMUX4WAY2___024ROOT_H_  // guard

#include "verilated.h"

class VMux4Way2__Syms;

class VMux4Way2___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(x0,1,0);
    VL_IN8(x1,1,0);
    VL_IN8(x2,1,0);
    VL_IN8(x3,1,0);
    VL_IN8(y,1,0);
    VL_OUT8(f,1,0);
    VlUnpacked<CData/*3:0*/, 4> Mux4Way2__DOT__i0__DOT__i0__DOT__pair_list;
    VlUnpacked<CData/*1:0*/, 4> Mux4Way2__DOT__i0__DOT__i0__DOT__key_list;
    VlUnpacked<CData/*1:0*/, 4> Mux4Way2__DOT__i0__DOT__i0__DOT__data_list;

    // INTERNAL VARIABLES
    VMux4Way2__Syms* const vlSymsp;

    // CONSTRUCTORS
    VMux4Way2___024root(VMux4Way2__Syms* symsp, const char* name);
    ~VMux4Way2___024root();
    VL_UNCOPYABLE(VMux4Way2___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);


#endif  // guard
