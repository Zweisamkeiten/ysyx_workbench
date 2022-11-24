// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtop.h for the primary calling header

#ifndef VERILATED_VTOP___024ROOT_H_
#define VERILATED_VTOP___024ROOT_H_  // guard

#include "verilated.h"

class Vtop__Syms;
class Vtop___024unit;


class Vtop___024root final : public VerilatedModule {
  public:
    // CELLS
    Vtop___024unit* __PVT____024unit;

    // DESIGN SPECIFIC STATE
    VL_IN8(i_clk,0,0);
    VL_IN8(i_rst,0,0);
    CData/*1:0*/ ysyx_22050710_npc__DOT__ALUBsrc;
    CData/*3:0*/ ysyx_22050710_npc__DOT__ALUctr;
    CData/*0:0*/ ysyx_22050710_npc__DOT__PCAsrc;
    CData/*0:0*/ ysyx_22050710_npc__DOT__PCBsrc;
    CData/*0:0*/ ysyx_22050710_npc__DOT__u_idu__DOT__inst_addi;
    CData/*0:0*/ ysyx_22050710_npc__DOT__u_idu__DOT__inst_ebreak;
    CData/*0:0*/ ysyx_22050710_npc__DOT__u_idu__DOT__inst_sd;
    CData/*0:0*/ ysyx_22050710_npc__DOT__u_idu__DOT__inst_type_i;
    CData/*0:0*/ ysyx_22050710_npc__DOT__u_idu__DOT__inst_type_u;
    CData/*2:0*/ ysyx_22050710_npc__DOT__u_idu__DOT__extop;
    CData/*5:0*/ ysyx_22050710_npc__DOT__u_idu__DOT__inst_type;
    CData/*2:0*/ ysyx_22050710_npc__DOT__u_idu__DOT____Vcellinp__u_mux2__key;
    CData/*2:0*/ ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__lut_out;
    CData/*0:0*/ ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__hit;
    CData/*0:0*/ ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__hit;
    CData/*3:0*/ ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__lut_out;
    CData/*0:0*/ ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__hit;
    CData/*0:0*/ ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__hit;
    CData/*0:0*/ ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__hit;
    CData/*0:0*/ __Vtrigrprev__TOP__i_clk;
    CData/*3:0*/ __Vtrigrprev__TOP__ysyx_22050710_npc__DOT__ALUctr;
    CData/*0:0*/ __VactDidInit;
    CData/*0:0*/ __VactContinue;
    VL_IN(i_inst,31,0);
    IData/*31:0*/ __VstlIterCount;
    IData/*31:0*/ __VicoIterCount;
    IData/*31:0*/ __VactIterCount;
    VL_OUT64(o_pc,63,0);
    QData/*63:0*/ ysyx_22050710_npc__DOT__pc_adder;
    QData/*63:0*/ ysyx_22050710_npc__DOT__rs1;
    QData/*63:0*/ ysyx_22050710_npc__DOT__rs2;
    QData/*63:0*/ ysyx_22050710_npc__DOT__ALUresult;
    QData/*63:0*/ ysyx_22050710_npc__DOT__imm;
    QData/*63:0*/ ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__lut_out;
    QData/*63:0*/ ysyx_22050710_npc__DOT__u_exu__DOT__add_a;
    QData/*63:0*/ ysyx_22050710_npc__DOT__u_exu__DOT__add_b;
    QData/*63:0*/ ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__lut_out;
    QData/*63:0*/ ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__lut_out;
    VlUnpacked<QData/*63:0*/, 32> ysyx_22050710_npc__DOT__u_gprs__DOT__rf;
    VlUnpacked<SData/*8:0*/, 6> ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__pair_list;
    VlUnpacked<CData/*5:0*/, 6> ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list;
    VlUnpacked<CData/*2:0*/, 6> ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__data_list;
    VlUnpacked<VlWide<3>/*66:0*/, 5> ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__pair_list;
    VlUnpacked<CData/*2:0*/, 5> ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__key_list;
    VlUnpacked<QData/*63:0*/, 5> ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__data_list;
    VlUnpacked<CData/*6:0*/, 3> ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__pair_list;
    VlUnpacked<CData/*2:0*/, 3> ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__key_list;
    VlUnpacked<CData/*3:0*/, 3> ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__data_list;
    VlUnpacked<VlWide<3>/*65:0*/, 3> ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__pair_list;
    VlUnpacked<CData/*1:0*/, 3> ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__key_list;
    VlUnpacked<QData/*63:0*/, 3> ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__data_list;
    VlUnpacked<VlWide<3>/*67:0*/, 2> ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__pair_list;
    VlUnpacked<CData/*3:0*/, 2> ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__key_list;
    VlUnpacked<QData/*63:0*/, 2> ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__data_list;
    VlUnpacked<CData/*0:0*/, 3> __Vm_traceActivity;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VicoTriggered;
    VlTriggerVec<2> __VactTriggered;
    VlTriggerVec<2> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vtop__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vtop___024root(Vtop__Syms* symsp, const char* name);
    ~Vtop___024root();
    VL_UNCOPYABLE(Vtop___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);


#endif  // guard
