// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See VMux4Way2.h for the primary calling header

#include "verilated.h"

#include "VMux4Way2__Syms.h"
#include "VMux4Way2___024root.h"

void VMux4Way2___024root___ctor_var_reset(VMux4Way2___024root* vlSelf);

VMux4Way2___024root::VMux4Way2___024root(VMux4Way2__Syms* symsp, const char* name)
    : VerilatedModule{name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    VMux4Way2___024root___ctor_var_reset(this);
}

void VMux4Way2___024root::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

VMux4Way2___024root::~VMux4Way2___024root() {
}
