// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "verilated.h"
#include "verilated_dpi.h"

#include "Vtop__Syms.h"
#include "Vtop___024unit.h"

void Vtop___024unit___ctor_var_reset(Vtop___024unit* vlSelf);

Vtop___024unit::Vtop___024unit(Vtop__Syms* symsp, const char* name)
    : VerilatedModule{name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vtop___024unit___ctor_var_reset(this);
}

void Vtop___024unit::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

Vtop___024unit::~Vtop___024unit() {
}
