// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vlight.h"
#include "Vlight__Syms.h"

//============================================================
// Constructors

Vlight::Vlight(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vlight__Syms(contextp(), _vcname__, this)}
    , clk{vlSymsp->TOP.clk}
    , rst{vlSymsp->TOP.rst}
    , led{vlSymsp->TOP.led}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vlight::Vlight(const char* _vcname__)
    : Vlight(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vlight::~Vlight() {
    delete vlSymsp;
}

//============================================================
// Evaluation loop

void Vlight___024root___eval_initial(Vlight___024root* vlSelf);
void Vlight___024root___eval_settle(Vlight___024root* vlSelf);
void Vlight___024root___eval(Vlight___024root* vlSelf);
#ifdef VL_DEBUG
void Vlight___024root___eval_debug_assertions(Vlight___024root* vlSelf);
#endif  // VL_DEBUG
void Vlight___024root___final(Vlight___024root* vlSelf);

static void _eval_initial_loop(Vlight__Syms* __restrict vlSymsp) {
    vlSymsp->__Vm_didInit = true;
    Vlight___024root___eval_initial(&(vlSymsp->TOP));
    // Evaluate till stable
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial loop\n"););
        Vlight___024root___eval_settle(&(vlSymsp->TOP));
        Vlight___024root___eval(&(vlSymsp->TOP));
    } while (0);
}

void Vlight::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vlight::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vlight___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    // Initialize
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) _eval_initial_loop(vlSymsp);
    // Evaluate till stable
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Clock loop\n"););
        Vlight___024root___eval(&(vlSymsp->TOP));
    } while (0);
    // Evaluate cleanup
}

//============================================================
// Utilities

const char* Vlight::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

VL_ATTR_COLD void Vlight::final() {
    Vlight___024root___final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vlight::hierName() const { return vlSymsp->name(); }
const char* Vlight::modelName() const { return "Vlight"; }
unsigned Vlight::threads() const { return 1; }
