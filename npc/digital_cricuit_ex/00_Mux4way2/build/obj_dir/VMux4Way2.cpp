// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "VMux4Way2.h"
#include "VMux4Way2__Syms.h"
#include "verilated_vcd_c.h"

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
    vlSymsp->__Vm_activity = true;
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
    vlSymsp->__Vm_activity = true;
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
std::unique_ptr<VerilatedTraceConfig> VMux4Way2::traceConfig() const {
    return std::unique_ptr<VerilatedTraceConfig>{new VerilatedTraceConfig{false, false, false}};
};

//============================================================
// Trace configuration

void VMux4Way2___024root__trace_init_top(VMux4Way2___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD static void trace_init(void* voidSelf, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    VMux4Way2___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<VMux4Way2___024root*>(voidSelf);
    VMux4Way2__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
            "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->scopeEscape(' ');
    tracep->pushNamePrefix(std::string{vlSymsp->name()} + ' ');
    VMux4Way2___024root__trace_init_top(vlSelf, tracep);
    tracep->popNamePrefix();
    tracep->scopeEscape('.');
}

VL_ATTR_COLD void VMux4Way2___024root__trace_register(VMux4Way2___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void VMux4Way2::trace(VerilatedVcdC* tfp, int levels, int options) {
    if (tfp->isOpen()) {
        vl_fatal(__FILE__, __LINE__, __FILE__,"'VMux4Way2::trace()' shall not be called after 'VerilatedVcdC::open()'.");
    }
    if (false && levels && options) {}  // Prevent unused
    tfp->spTrace()->addModel(this);
    tfp->spTrace()->addInitCb(&trace_init, &(vlSymsp->TOP));
    VMux4Way2___024root__trace_register(&(vlSymsp->TOP), tfp->spTrace());
}
