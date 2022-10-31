// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VMUX4WAY2__SYMS_H_
#define VERILATED_VMUX4WAY2__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "VMux4Way2.h"

// INCLUDE MODULE CLASSES
#include "VMux4Way2___024root.h"

// SYMS CLASS (contains all model state)
class VMux4Way2__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    VMux4Way2* const __Vm_modelp;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    VMux4Way2___024root            TOP;

    // CONSTRUCTORS
    VMux4Way2__Syms(VerilatedContext* contextp, const char* namep, VMux4Way2* modelp);
    ~VMux4Way2__Syms();

    // METHODS
    const char* name() { return TOP.name(); }
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

#endif  // guard
