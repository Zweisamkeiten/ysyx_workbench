// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "VMux4Way2__Syms.h"
#include "VMux4Way2.h"
#include "VMux4Way2___024root.h"

// FUNCTIONS
VMux4Way2__Syms::~VMux4Way2__Syms()
{
}

VMux4Way2__Syms::VMux4Way2__Syms(VerilatedContext* contextp, const char* namep, VMux4Way2* modelp)
    : VerilatedSyms{contextp}
    // Setup internal state of the Syms class
    , __Vm_modelp{modelp}
    // Setup module instances
    , TOP{this, namep}
{
    // Configure time unit / time precision
    _vm_contextp__->timeunit(-12);
    _vm_contextp__->timeprecision(-12);
    // Setup each module's pointers to their submodules
    // Setup each module's pointer back to symbol table (for public functions)
    TOP.__Vconfigure(true);
}
