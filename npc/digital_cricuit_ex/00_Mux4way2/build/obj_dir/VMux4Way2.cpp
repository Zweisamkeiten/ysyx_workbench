// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "VMux4Way2.h"
#include "VMux4Way2__Syms.h"

//============================================================
// Constructors

VMux4Way2::VMux4Way2(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new VMux4Way2__Syms(contextp(), _vcname__, this)}
    , x0{vlSymsp->TOP.x0}
    , x1{vlSymsp->TOP.x1}
    , x2{vlSymsp->TOP.x2}
    , x3{vlSymsp->TOP.x3}
    , y{vlSymsp->TOP.y}
    , f{vlSymsp->TOP.f}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

VMux4Way2::VMux4Way2(const char* _vcname__)
    : VMux4Way2(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

VMux4Way2::~VMux4Way2() {
    delete vlSymsp;
}

//============================================================
// Evaluation loop

void VMux4Way2___024root___eval_initial(VMux4Way2___024root* vlSelf);
void VMux4Way2___024root___eval_settle(VMux4Way2___024root* vlSelf);
void VMux4Way2___024root___eval(VMux4Way2___024root* vlSelf);
#ifdef VL_DEBUG
void VMux4Way2___024root___eval_debug_assertions(VMux4Way2___024root* vlSelf);
#endif  // VL_DEBUG
void VMux4Way2___024root___final(VMux4Way2___024root* vlSelf);

static void _eval_initial_loop(VMux4Way2__Syms* __restrict vlSymsp) {
    vlSymsp->__Vm_didInit = true;
    VMux4Way2___024root___eval_initial(&(vlSymsp->TOP));
    // Evaluate till stable
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial loop\n"););
        VMux4Way2___024root___eval_settle(&(vlSymsp->TOP));
        VMux4Way2___024root___eval(&(vlSymsp->TOP));
    } while (0);
}

void VMux4Way2::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate VMux4Way2::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    VMux4Way2___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    // Initialize
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) _eval_initial_loop(vlSymsp);
    // Evaluate till stable
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Clock loop\n"););
        VMux4Way2___024root___eval(&(vlSymsp->TOP));
    } while (0);
    // Evaluate cleanup
}

//============================================================
// Utilities

const char* VMux4Way2::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

VL_ATTR_COLD void VMux4Way2::final() {
    VMux4Way2___024root___final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* VMux4Way2::hierName() const { return vlSymsp->name(); }
const char* VMux4Way2::modelName() const { return "VMux4Way2"; }
unsigned VMux4Way2::threads() const { return 1; }
