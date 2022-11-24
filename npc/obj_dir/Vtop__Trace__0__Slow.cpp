// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vtop__Syms.h"


VL_ATTR_COLD void Vtop___024root__trace_init_sub__TOP__0(Vtop___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root__trace_init_sub__TOP__0\n"); );
    // Init
    const int c = vlSymsp->__Vm_baseCode;
    // Body
    tracep->declBit(c+203,"i_clk", false,-1);
    tracep->declBit(c+204,"i_rst", false,-1);
    tracep->declBus(c+205,"i_inst", false,-1, 31,0);
    tracep->declQuad(c+206,"o_pc", false,-1, 63,0);
    tracep->pushNamePrefix("ysyx_22050710_npc ");
    tracep->declBit(c+203,"i_clk", false,-1);
    tracep->declBit(c+204,"i_rst", false,-1);
    tracep->declBus(c+205,"i_inst", false,-1, 31,0);
    tracep->declQuad(c+206,"o_pc", false,-1, 63,0);
    tracep->declQuad(c+208,"pc_adder", false,-1, 63,0);
    tracep->declQuad(c+86,"rs1", false,-1, 63,0);
    tracep->declQuad(c+88,"rs2", false,-1, 63,0);
    tracep->declQuad(c+90,"ALUresult", false,-1, 63,0);
    tracep->declQuad(c+38,"imm", false,-1, 63,0);
    tracep->declBus(c+210,"ra", false,-1, 4,0);
    tracep->declBus(c+211,"rb", false,-1, 4,0);
    tracep->declBus(c+212,"rd", false,-1, 4,0);
    tracep->declBit(c+213,"wen", false,-1);
    tracep->declBit(c+214,"ALUAsrc", false,-1);
    tracep->declBus(c+40,"ALUBsrc", false,-1, 1,0);
    tracep->declBus(c+41,"ALUctr", false,-1, 3,0);
    tracep->declBit(c+42,"PCAsrc", false,-1);
    tracep->declBit(c+43,"PCBsrc", false,-1);
    tracep->pushNamePrefix("u_exu ");
    tracep->declQuad(c+86,"i_rs1", false,-1, 63,0);
    tracep->declQuad(c+88,"i_rs2", false,-1, 63,0);
    tracep->declQuad(c+38,"i_imm", false,-1, 63,0);
    tracep->declQuad(c+206,"i_pc", false,-1, 63,0);
    tracep->declBit(c+214,"i_ALUAsrc", false,-1);
    tracep->declBus(c+40,"i_ALUBsrc", false,-1, 1,0);
    tracep->declBus(c+41,"i_ALUctr", false,-1, 3,0);
    tracep->declQuad(c+90,"o_ALUresult", false,-1, 63,0);
    tracep->declQuad(c+92,"adder_result", false,-1, 63,0);
    tracep->declQuad(c+94,"add_a", false,-1, 63,0);
    tracep->declQuad(c+96,"add_b", false,-1, 63,0);
    tracep->declQuad(c+38,"copy_result", false,-1, 63,0);
    tracep->pushNamePrefix("u_mux0 ");
    tracep->declBus(c+243,"NR_KEY", false,-1, 31,0);
    tracep->declBus(c+244,"KEY_LEN", false,-1, 31,0);
    tracep->declBus(c+245,"DATA_LEN", false,-1, 31,0);
    tracep->declQuad(c+96,"out", false,-1, 63,0);
    tracep->declBus(c+40,"key", false,-1, 1,0);
    tracep->declArray(c+98,"lut", false,-1, 197,0);
    tracep->pushNamePrefix("i0 ");
    tracep->declBus(c+243,"NR_KEY", false,-1, 31,0);
    tracep->declBus(c+244,"KEY_LEN", false,-1, 31,0);
    tracep->declBus(c+245,"DATA_LEN", false,-1, 31,0);
    tracep->declBus(c+246,"HAS_DEFAULT", false,-1, 31,0);
    tracep->declQuad(c+96,"out", false,-1, 63,0);
    tracep->declBus(c+40,"key", false,-1, 1,0);
    tracep->declQuad(c+247,"default_out", false,-1, 63,0);
    tracep->declArray(c+98,"lut", false,-1, 197,0);
    tracep->declBus(c+249,"PAIR_LEN", false,-1, 31,0);
    for (int i = 0; i < 3; ++i) {
        tracep->declArray(c+105+i*3,"pair_list", true,(i+0), 65,0);
    }
    for (int i = 0; i < 3; ++i) {
        tracep->declBus(c+1+i*1,"key_list", true,(i+0), 1,0);
    }
    for (int i = 0; i < 3; ++i) {
        tracep->declQuad(c+114+i*2,"data_list", true,(i+0), 63,0);
    }
    tracep->declQuad(c+120,"lut_out", false,-1, 63,0);
    tracep->declBit(c+44,"hit", false,-1);
    tracep->declBus(c+250,"i", false,-1, 31,0);
    tracep->pushNamePrefix("genblk1 ");
    tracep->popNamePrefix(3);
    tracep->pushNamePrefix("u_mux1 ");
    tracep->declBus(c+244,"NR_KEY", false,-1, 31,0);
    tracep->declBus(c+251,"KEY_LEN", false,-1, 31,0);
    tracep->declBus(c+245,"DATA_LEN", false,-1, 31,0);
    tracep->declQuad(c+90,"out", false,-1, 63,0);
    tracep->declBus(c+41,"key", false,-1, 3,0);
    tracep->declArray(c+122,"lut", false,-1, 135,0);
    tracep->pushNamePrefix("i0 ");
    tracep->declBus(c+244,"NR_KEY", false,-1, 31,0);
    tracep->declBus(c+251,"KEY_LEN", false,-1, 31,0);
    tracep->declBus(c+245,"DATA_LEN", false,-1, 31,0);
    tracep->declBus(c+246,"HAS_DEFAULT", false,-1, 31,0);
    tracep->declQuad(c+90,"out", false,-1, 63,0);
    tracep->declBus(c+41,"key", false,-1, 3,0);
    tracep->declQuad(c+247,"default_out", false,-1, 63,0);
    tracep->declArray(c+122,"lut", false,-1, 135,0);
    tracep->declBus(c+252,"PAIR_LEN", false,-1, 31,0);
    for (int i = 0; i < 2; ++i) {
        tracep->declArray(c+127+i*3,"pair_list", true,(i+0), 67,0);
    }
    for (int i = 0; i < 2; ++i) {
        tracep->declBus(c+4+i*1,"key_list", true,(i+0), 3,0);
    }
    for (int i = 0; i < 2; ++i) {
        tracep->declQuad(c+133+i*2,"data_list", true,(i+0), 63,0);
    }
    tracep->declQuad(c+137,"lut_out", false,-1, 63,0);
    tracep->declBit(c+45,"hit", false,-1);
    tracep->declBus(c+253,"i", false,-1, 31,0);
    tracep->pushNamePrefix("genblk1 ");
    tracep->popNamePrefix(4);
    tracep->pushNamePrefix("u_gprs ");
    tracep->declBus(c+254,"ADDR_WIDTH", false,-1, 31,0);
    tracep->declBus(c+245,"DATA_WIDTH", false,-1, 31,0);
    tracep->declBit(c+203,"i_clk", false,-1);
    tracep->declBus(c+210,"i_ra", false,-1, 4,0);
    tracep->declBus(c+211,"i_rb", false,-1, 4,0);
    tracep->declBus(c+212,"i_waddr", false,-1, 4,0);
    tracep->declQuad(c+90,"i_wdata", false,-1, 63,0);
    tracep->declBit(c+213,"i_wen", false,-1);
    tracep->declQuad(c+86,"o_busA", false,-1, 63,0);
    tracep->declQuad(c+88,"o_busB", false,-1, 63,0);
    for (int i = 0; i < 32; ++i) {
        tracep->declQuad(c+139+i*2,"rf", true,(i+0), 63,0);
    }
    tracep->popNamePrefix(1);
    tracep->pushNamePrefix("u_idu ");
    tracep->declBus(c+205,"i_inst", false,-1, 31,0);
    tracep->declQuad(c+38,"o_imm", false,-1, 63,0);
    tracep->declBus(c+210,"o_ra", false,-1, 4,0);
    tracep->declBus(c+211,"o_rb", false,-1, 4,0);
    tracep->declBus(c+212,"o_rd", false,-1, 4,0);
    tracep->declBit(c+213,"o_wen", false,-1);
    tracep->declBit(c+214,"o_ALUAsrc", false,-1);
    tracep->declBus(c+40,"o_ALUBsrc", false,-1, 1,0);
    tracep->declBus(c+41,"o_ALUctr", false,-1, 3,0);
    tracep->declBit(c+42,"o_PCAsrc", false,-1);
    tracep->declBit(c+43,"o_PCBsrc", false,-1);
    tracep->declBus(c+215,"opcode", false,-1, 6,0);
    tracep->declBus(c+216,"funct3", false,-1, 2,0);
    tracep->declBus(c+217,"funct7", false,-1, 6,0);
    tracep->declQuad(c+218,"immI", false,-1, 63,0);
    tracep->declQuad(c+220,"immU", false,-1, 63,0);
    tracep->declQuad(c+222,"immS", false,-1, 63,0);
    tracep->declQuad(c+224,"immB", false,-1, 63,0);
    tracep->declQuad(c+226,"immJ", false,-1, 63,0);
    tracep->declBit(c+228,"inst_lui", false,-1);
    tracep->declBit(c+229,"inst_auipc", false,-1);
    tracep->declBit(c+230,"inst_jal", false,-1);
    tracep->declBit(c+43,"inst_jalr", false,-1);
    tracep->declBit(c+46,"inst_addi", false,-1);
    tracep->declBit(c+47,"inst_ebreak", false,-1);
    tracep->declBit(c+48,"inst_sd", false,-1);
    tracep->declBit(c+255,"inst_type_r", false,-1);
    tracep->declBit(c+49,"inst_type_i", false,-1);
    tracep->declBit(c+50,"inst_type_u", false,-1);
    tracep->declBit(c+48,"inst_type_s", false,-1);
    tracep->declBit(c+255,"inst_type_b", false,-1);
    tracep->declBit(c+230,"inst_type_j", false,-1);
    tracep->declBus(c+51,"extop", false,-1, 2,0);
    tracep->declBus(c+52,"inst_type", false,-1, 5,0);
    tracep->declBit(c+228,"alu_copyimm", false,-1);
    tracep->declBit(c+231,"alu_plus", false,-1);
    tracep->declBit(c+47,"alu_ebreak", false,-1);
    tracep->pushNamePrefix("u_mux0 ");
    tracep->declBus(c+256,"NR_KEY", false,-1, 31,0);
    tracep->declBus(c+256,"KEY_LEN", false,-1, 31,0);
    tracep->declBus(c+243,"DATA_LEN", false,-1, 31,0);
    tracep->declBus(c+51,"out", false,-1, 2,0);
    tracep->declBus(c+52,"key", false,-1, 5,0);
    tracep->declQuad(c+257,"lut", false,-1, 53,0);
    tracep->pushNamePrefix("i0 ");
    tracep->declBus(c+256,"NR_KEY", false,-1, 31,0);
    tracep->declBus(c+256,"KEY_LEN", false,-1, 31,0);
    tracep->declBus(c+243,"DATA_LEN", false,-1, 31,0);
    tracep->declBus(c+246,"HAS_DEFAULT", false,-1, 31,0);
    tracep->declBus(c+51,"out", false,-1, 2,0);
    tracep->declBus(c+52,"key", false,-1, 5,0);
    tracep->declBus(c+259,"default_out", false,-1, 2,0);
    tracep->declQuad(c+257,"lut", false,-1, 53,0);
    tracep->declBus(c+260,"PAIR_LEN", false,-1, 31,0);
    for (int i = 0; i < 6; ++i) {
        tracep->declBus(c+6+i*1,"pair_list", true,(i+0), 8,0);
    }
    for (int i = 0; i < 6; ++i) {
        tracep->declBus(c+12+i*1,"key_list", true,(i+0), 5,0);
    }
    for (int i = 0; i < 6; ++i) {
        tracep->declBus(c+18+i*1,"data_list", true,(i+0), 2,0);
    }
    tracep->declBus(c+53,"lut_out", false,-1, 2,0);
    tracep->declBit(c+54,"hit", false,-1);
    tracep->declBus(c+261,"i", false,-1, 31,0);
    tracep->pushNamePrefix("genblk1 ");
    tracep->popNamePrefix(3);
    tracep->pushNamePrefix("u_mux1 ");
    tracep->declBus(c+254,"NR_KEY", false,-1, 31,0);
    tracep->declBus(c+243,"KEY_LEN", false,-1, 31,0);
    tracep->declBus(c+245,"DATA_LEN", false,-1, 31,0);
    tracep->declQuad(c+38,"out", false,-1, 63,0);
    tracep->declBus(c+51,"key", false,-1, 2,0);
    tracep->declArray(c+232,"lut", false,-1, 334,0);
    tracep->pushNamePrefix("i0 ");
    tracep->declBus(c+254,"NR_KEY", false,-1, 31,0);
    tracep->declBus(c+243,"KEY_LEN", false,-1, 31,0);
    tracep->declBus(c+245,"DATA_LEN", false,-1, 31,0);
    tracep->declBus(c+246,"HAS_DEFAULT", false,-1, 31,0);
    tracep->declQuad(c+38,"out", false,-1, 63,0);
    tracep->declBus(c+51,"key", false,-1, 2,0);
    tracep->declQuad(c+247,"default_out", false,-1, 63,0);
    tracep->declArray(c+232,"lut", false,-1, 334,0);
    tracep->declBus(c+262,"PAIR_LEN", false,-1, 31,0);
    for (int i = 0; i < 5; ++i) {
        tracep->declArray(c+55+i*3,"pair_list", true,(i+0), 66,0);
    }
    for (int i = 0; i < 5; ++i) {
        tracep->declBus(c+24+i*1,"key_list", true,(i+0), 2,0);
    }
    for (int i = 0; i < 5; ++i) {
        tracep->declQuad(c+70+i*2,"data_list", true,(i+0), 63,0);
    }
    tracep->declQuad(c+80,"lut_out", false,-1, 63,0);
    tracep->declBit(c+82,"hit", false,-1);
    tracep->declBus(c+263,"i", false,-1, 31,0);
    tracep->pushNamePrefix("genblk1 ");
    tracep->popNamePrefix(3);
    tracep->pushNamePrefix("u_mux2 ");
    tracep->declBus(c+243,"NR_KEY", false,-1, 31,0);
    tracep->declBus(c+243,"KEY_LEN", false,-1, 31,0);
    tracep->declBus(c+251,"DATA_LEN", false,-1, 31,0);
    tracep->declBus(c+41,"out", false,-1, 3,0);
    tracep->declBus(c+83,"key", false,-1, 2,0);
    tracep->declBus(c+264,"default_out", false,-1, 3,0);
    tracep->declBus(c+265,"lut", false,-1, 20,0);
    tracep->pushNamePrefix("i0 ");
    tracep->declBus(c+243,"NR_KEY", false,-1, 31,0);
    tracep->declBus(c+243,"KEY_LEN", false,-1, 31,0);
    tracep->declBus(c+251,"DATA_LEN", false,-1, 31,0);
    tracep->declBus(c+266,"HAS_DEFAULT", false,-1, 31,0);
    tracep->declBus(c+41,"out", false,-1, 3,0);
    tracep->declBus(c+83,"key", false,-1, 2,0);
    tracep->declBus(c+264,"default_out", false,-1, 3,0);
    tracep->declBus(c+265,"lut", false,-1, 20,0);
    tracep->declBus(c+267,"PAIR_LEN", false,-1, 31,0);
    for (int i = 0; i < 3; ++i) {
        tracep->declBus(c+29+i*1,"pair_list", true,(i+0), 6,0);
    }
    for (int i = 0; i < 3; ++i) {
        tracep->declBus(c+32+i*1,"key_list", true,(i+0), 2,0);
    }
    for (int i = 0; i < 3; ++i) {
        tracep->declBus(c+35+i*1,"data_list", true,(i+0), 3,0);
    }
    tracep->declBus(c+84,"lut_out", false,-1, 3,0);
    tracep->declBit(c+85,"hit", false,-1);
    tracep->declBus(c+250,"i", false,-1, 31,0);
    tracep->pushNamePrefix("genblk1 ");
    tracep->popNamePrefix(4);
    tracep->pushNamePrefix("u_pc ");
    tracep->declBit(c+203,"i_clk", false,-1);
    tracep->declBit(c+204,"i_rst", false,-1);
    tracep->declBit(c+268,"i_load", false,-1);
    tracep->declQuad(c+208,"i_in", false,-1, 63,0);
    tracep->declQuad(c+206,"o_pc", false,-1, 63,0);
    tracep->pushNamePrefix("u_0 ");
    tracep->declBus(c+245,"WIDTH", false,-1, 31,0);
    tracep->declQuad(c+269,"RESET_VAL", false,-1, 63,0);
    tracep->declBit(c+203,"clk", false,-1);
    tracep->declBit(c+204,"rst", false,-1);
    tracep->declQuad(c+208,"din", false,-1, 63,0);
    tracep->declQuad(c+206,"dout", false,-1, 63,0);
    tracep->declBit(c+268,"wen", false,-1);
    tracep->popNamePrefix(3);
}

VL_ATTR_COLD void Vtop___024root__trace_init_top(Vtop___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root__trace_init_top\n"); );
    // Body
    Vtop___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vtop___024root__trace_full_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vtop___024root__trace_chg_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vtop___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vtop___024root__trace_register(Vtop___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root__trace_register\n"); );
    // Body
    tracep->addFullCb(&Vtop___024root__trace_full_top_0, vlSelf);
    tracep->addChgCb(&Vtop___024root__trace_chg_top_0, vlSelf);
    tracep->addCleanupCb(&Vtop___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vtop___024root__trace_full_sub_0(Vtop___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vtop___024root__trace_full_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root__trace_full_top_0\n"); );
    // Init
    Vtop___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtop___024root*>(voidSelf);
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vtop___024root__trace_full_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vtop___024root__trace_full_sub_0(Vtop___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root__trace_full_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    VlWide<7>/*223:0*/ __Vtemp_h8ca9881f__0;
    VlWide<7>/*223:0*/ __Vtemp_hdca9a15a__0;
    VlWide<3>/*95:0*/ __Vtemp_h2ffc666a__0;
    VlWide<5>/*159:0*/ __Vtemp_h31f01f78__0;
    VlWide<5>/*159:0*/ __Vtemp_h268169af__0;
    VlWide<11>/*351:0*/ __Vtemp_h63fcc034__0;
    VlWide<11>/*351:0*/ __Vtemp_h57776156__0;
    // Body
    bufp->fullCData(oldp+1,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__key_list[0]),2);
    bufp->fullCData(oldp+2,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__key_list[1]),2);
    bufp->fullCData(oldp+3,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__key_list[2]),2);
    bufp->fullCData(oldp+4,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__key_list[0]),4);
    bufp->fullCData(oldp+5,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__key_list[1]),4);
    bufp->fullSData(oldp+6,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__pair_list[0]),9);
    bufp->fullSData(oldp+7,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__pair_list[1]),9);
    bufp->fullSData(oldp+8,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__pair_list[2]),9);
    bufp->fullSData(oldp+9,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__pair_list[3]),9);
    bufp->fullSData(oldp+10,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__pair_list[4]),9);
    bufp->fullSData(oldp+11,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__pair_list[5]),9);
    bufp->fullCData(oldp+12,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list[0]),6);
    bufp->fullCData(oldp+13,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list[1]),6);
    bufp->fullCData(oldp+14,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list[2]),6);
    bufp->fullCData(oldp+15,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list[3]),6);
    bufp->fullCData(oldp+16,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list[4]),6);
    bufp->fullCData(oldp+17,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list[5]),6);
    bufp->fullCData(oldp+18,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__data_list[0]),3);
    bufp->fullCData(oldp+19,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__data_list[1]),3);
    bufp->fullCData(oldp+20,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__data_list[2]),3);
    bufp->fullCData(oldp+21,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__data_list[3]),3);
    bufp->fullCData(oldp+22,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__data_list[4]),3);
    bufp->fullCData(oldp+23,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__data_list[5]),3);
    bufp->fullCData(oldp+24,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__key_list[0]),3);
    bufp->fullCData(oldp+25,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__key_list[1]),3);
    bufp->fullCData(oldp+26,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__key_list[2]),3);
    bufp->fullCData(oldp+27,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__key_list[3]),3);
    bufp->fullCData(oldp+28,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__key_list[4]),3);
    bufp->fullCData(oldp+29,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__pair_list[0]),7);
    bufp->fullCData(oldp+30,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__pair_list[1]),7);
    bufp->fullCData(oldp+31,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__pair_list[2]),7);
    bufp->fullCData(oldp+32,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__key_list[0]),3);
    bufp->fullCData(oldp+33,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__key_list[1]),3);
    bufp->fullCData(oldp+34,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__key_list[2]),3);
    bufp->fullCData(oldp+35,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__data_list[0]),4);
    bufp->fullCData(oldp+36,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__data_list[1]),4);
    bufp->fullCData(oldp+37,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__data_list[2]),4);
    bufp->fullQData(oldp+38,(vlSelf->ysyx_22050710_npc__DOT__imm),64);
    bufp->fullCData(oldp+40,(vlSelf->ysyx_22050710_npc__DOT__ALUBsrc),2);
    bufp->fullCData(oldp+41,(vlSelf->ysyx_22050710_npc__DOT__ALUctr),4);
    bufp->fullBit(oldp+42,(vlSelf->ysyx_22050710_npc__DOT__PCAsrc));
    bufp->fullBit(oldp+43,(vlSelf->ysyx_22050710_npc__DOT__PCBsrc));
    bufp->fullBit(oldp+44,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__hit));
    bufp->fullBit(oldp+45,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__hit));
    bufp->fullBit(oldp+46,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_addi));
    bufp->fullBit(oldp+47,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_ebreak));
    bufp->fullBit(oldp+48,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_sd));
    bufp->fullBit(oldp+49,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type_i));
    bufp->fullBit(oldp+50,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type_u));
    bufp->fullCData(oldp+51,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__extop),3);
    bufp->fullCData(oldp+52,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type),6);
    bufp->fullCData(oldp+53,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__lut_out),3);
    bufp->fullBit(oldp+54,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__hit));
    bufp->fullWData(oldp+55,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__pair_list[0]),67);
    bufp->fullWData(oldp+58,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__pair_list[1]),67);
    bufp->fullWData(oldp+61,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__pair_list[2]),67);
    bufp->fullWData(oldp+64,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__pair_list[3]),67);
    bufp->fullWData(oldp+67,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__pair_list[4]),67);
    bufp->fullQData(oldp+70,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__data_list[0]),64);
    bufp->fullQData(oldp+72,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__data_list[1]),64);
    bufp->fullQData(oldp+74,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__data_list[2]),64);
    bufp->fullQData(oldp+76,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__data_list[3]),64);
    bufp->fullQData(oldp+78,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__data_list[4]),64);
    bufp->fullQData(oldp+80,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__lut_out),64);
    bufp->fullBit(oldp+82,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__hit));
    bufp->fullCData(oldp+83,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT____Vcellinp__u_mux2__key),3);
    bufp->fullCData(oldp+84,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__lut_out),4);
    bufp->fullBit(oldp+85,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__hit));
    bufp->fullQData(oldp+86,(vlSelf->ysyx_22050710_npc__DOT__rs1),64);
    bufp->fullQData(oldp+88,(vlSelf->ysyx_22050710_npc__DOT__rs2),64);
    bufp->fullQData(oldp+90,(vlSelf->ysyx_22050710_npc__DOT__ALUresult),64);
    bufp->fullQData(oldp+92,((vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__add_a 
                              + vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__add_b)),64);
    bufp->fullQData(oldp+94,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__add_a),64);
    bufp->fullQData(oldp+96,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__add_b),64);
    __Vtemp_h8ca9881f__0[0U] = 4U;
    __Vtemp_h8ca9881f__0[1U] = 0U;
    __Vtemp_h8ca9881f__0[2U] = (2U | ((IData)(vlSelf->ysyx_22050710_npc__DOT__imm) 
                                      << 2U));
    __Vtemp_h8ca9881f__0[3U] = (((IData)(vlSelf->ysyx_22050710_npc__DOT__imm) 
                                 >> 0x1eU) | ((IData)(
                                                      (vlSelf->ysyx_22050710_npc__DOT__imm 
                                                       >> 0x20U)) 
                                              << 2U));
    __Vtemp_h8ca9881f__0[4U] = (4U | (((IData)(vlSelf->ysyx_22050710_npc__DOT__rs2) 
                                       << 4U) | ((IData)(
                                                         (vlSelf->ysyx_22050710_npc__DOT__imm 
                                                          >> 0x20U)) 
                                                 >> 0x1eU)));
    __Vtemp_h8ca9881f__0[5U] = (((IData)(vlSelf->ysyx_22050710_npc__DOT__rs2) 
                                 >> 0x1cU) | ((IData)(
                                                      (vlSelf->ysyx_22050710_npc__DOT__rs2 
                                                       >> 0x20U)) 
                                              << 4U));
    __Vtemp_h8ca9881f__0[6U] = ((IData)((vlSelf->ysyx_22050710_npc__DOT__rs2 
                                         >> 0x20U)) 
                                >> 0x1cU);
    VL_EXTEND_WW(198,196, __Vtemp_hdca9a15a__0, __Vtemp_h8ca9881f__0);
    bufp->fullWData(oldp+98,(__Vtemp_hdca9a15a__0),198);
    bufp->fullWData(oldp+105,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__pair_list[0]),66);
    bufp->fullWData(oldp+108,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__pair_list[1]),66);
    bufp->fullWData(oldp+111,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__pair_list[2]),66);
    bufp->fullQData(oldp+114,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__data_list[0]),64);
    bufp->fullQData(oldp+116,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__data_list[1]),64);
    bufp->fullQData(oldp+118,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__data_list[2]),64);
    bufp->fullQData(oldp+120,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__lut_out),64);
    VL_EXTEND_WQ(68,64, __Vtemp_h2ffc666a__0, (vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__add_a 
                                               + vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__add_b));
    __Vtemp_h31f01f78__0[0U] = __Vtemp_h2ffc666a__0[0U];
    __Vtemp_h31f01f78__0[1U] = __Vtemp_h2ffc666a__0[1U];
    __Vtemp_h31f01f78__0[2U] = (((IData)(vlSelf->ysyx_22050710_npc__DOT__imm) 
                                 << 4U) | __Vtemp_h2ffc666a__0[2U]);
    __Vtemp_h31f01f78__0[3U] = (((IData)(vlSelf->ysyx_22050710_npc__DOT__imm) 
                                 >> 0x1cU) | ((IData)(
                                                      (vlSelf->ysyx_22050710_npc__DOT__imm 
                                                       >> 0x20U)) 
                                              << 4U));
    __Vtemp_h31f01f78__0[4U] = (0x30U | ((IData)((vlSelf->ysyx_22050710_npc__DOT__imm 
                                                  >> 0x20U)) 
                                         >> 0x1cU));
    bufp->fullWData(oldp+122,(__Vtemp_h31f01f78__0),136);
    bufp->fullWData(oldp+127,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__pair_list[0]),68);
    bufp->fullWData(oldp+130,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__pair_list[1]),68);
    bufp->fullQData(oldp+133,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__data_list[0]),64);
    bufp->fullQData(oldp+135,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__data_list[1]),64);
    bufp->fullQData(oldp+137,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__lut_out),64);
    bufp->fullQData(oldp+139,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[0]),64);
    bufp->fullQData(oldp+141,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[1]),64);
    bufp->fullQData(oldp+143,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[2]),64);
    bufp->fullQData(oldp+145,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[3]),64);
    bufp->fullQData(oldp+147,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[4]),64);
    bufp->fullQData(oldp+149,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[5]),64);
    bufp->fullQData(oldp+151,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[6]),64);
    bufp->fullQData(oldp+153,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[7]),64);
    bufp->fullQData(oldp+155,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[8]),64);
    bufp->fullQData(oldp+157,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[9]),64);
    bufp->fullQData(oldp+159,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[10]),64);
    bufp->fullQData(oldp+161,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[11]),64);
    bufp->fullQData(oldp+163,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[12]),64);
    bufp->fullQData(oldp+165,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[13]),64);
    bufp->fullQData(oldp+167,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[14]),64);
    bufp->fullQData(oldp+169,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[15]),64);
    bufp->fullQData(oldp+171,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[16]),64);
    bufp->fullQData(oldp+173,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[17]),64);
    bufp->fullQData(oldp+175,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[18]),64);
    bufp->fullQData(oldp+177,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[19]),64);
    bufp->fullQData(oldp+179,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[20]),64);
    bufp->fullQData(oldp+181,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[21]),64);
    bufp->fullQData(oldp+183,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[22]),64);
    bufp->fullQData(oldp+185,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[23]),64);
    bufp->fullQData(oldp+187,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[24]),64);
    bufp->fullQData(oldp+189,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[25]),64);
    bufp->fullQData(oldp+191,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[26]),64);
    bufp->fullQData(oldp+193,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[27]),64);
    bufp->fullQData(oldp+195,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[28]),64);
    bufp->fullQData(oldp+197,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[29]),64);
    bufp->fullQData(oldp+199,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[30]),64);
    bufp->fullQData(oldp+201,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[31]),64);
    bufp->fullBit(oldp+203,(vlSelf->i_clk));
    bufp->fullBit(oldp+204,(vlSelf->i_rst));
    bufp->fullIData(oldp+205,(vlSelf->i_inst),32);
    bufp->fullQData(oldp+206,(vlSelf->o_pc),64);
    bufp->fullQData(oldp+208,((((IData)(vlSelf->ysyx_22050710_npc__DOT__PCBsrc)
                                 ? vlSelf->ysyx_22050710_npc__DOT__rs1
                                 : vlSelf->o_pc) + 
                               ((IData)(vlSelf->ysyx_22050710_npc__DOT__PCAsrc)
                                 ? vlSelf->ysyx_22050710_npc__DOT__imm
                                 : 4ULL))),64);
    bufp->fullCData(oldp+210,((0x1fU & (vlSelf->i_inst 
                                        >> 0xfU))),5);
    bufp->fullCData(oldp+211,((0x1fU & (vlSelf->i_inst 
                                        >> 0x14U))),5);
    bufp->fullCData(oldp+212,((0x1fU & (vlSelf->i_inst 
                                        >> 7U))),5);
    bufp->fullBit(oldp+213,(((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type_i) 
                             | ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type_u) 
                                | (0x6fU == (0x7fU 
                                             & vlSelf->i_inst))))));
    bufp->fullBit(oldp+214,(((0x6fU == (0x7fU & vlSelf->i_inst)) 
                             | ((0x17U == (0x7fU & vlSelf->i_inst)) 
                                | (IData)(vlSelf->ysyx_22050710_npc__DOT__PCBsrc)))));
    bufp->fullCData(oldp+215,((0x7fU & vlSelf->i_inst)),7);
    bufp->fullCData(oldp+216,((7U & (vlSelf->i_inst 
                                     >> 0xcU))),3);
    bufp->fullCData(oldp+217,((vlSelf->i_inst >> 0x19U)),7);
    bufp->fullQData(oldp+218,((((- (QData)((IData)(
                                                   (vlSelf->i_inst 
                                                    >> 0x1fU)))) 
                                << 0xcU) | (QData)((IData)(
                                                           (vlSelf->i_inst 
                                                            >> 0x14U))))),64);
    bufp->fullQData(oldp+220,((((QData)((IData)((- (IData)(
                                                           (vlSelf->i_inst 
                                                            >> 0x1fU))))) 
                                << 0x20U) | (QData)((IData)(
                                                            (0xfffff000U 
                                                             & vlSelf->i_inst))))),64);
    bufp->fullQData(oldp+222,((((- (QData)((IData)(
                                                   (vlSelf->i_inst 
                                                    >> 0x1fU)))) 
                                << 0xcU) | (QData)((IData)(
                                                           ((0xfe0U 
                                                             & (vlSelf->i_inst 
                                                                >> 0x14U)) 
                                                            | (0x1fU 
                                                               & (vlSelf->i_inst 
                                                                  >> 7U))))))),64);
    bufp->fullQData(oldp+224,((((- (QData)((IData)(
                                                   (vlSelf->i_inst 
                                                    >> 0x1fU)))) 
                                << 0xcU) | (QData)((IData)(
                                                           ((0x800U 
                                                             & (vlSelf->i_inst 
                                                                << 4U)) 
                                                            | ((0x7e0U 
                                                                & (vlSelf->i_inst 
                                                                   >> 0x14U)) 
                                                               | (0x1eU 
                                                                  & (vlSelf->i_inst 
                                                                     >> 7U)))))))),64);
    bufp->fullQData(oldp+226,((((- (QData)((IData)(
                                                   (vlSelf->i_inst 
                                                    >> 0x1fU)))) 
                                << 0x14U) | (QData)((IData)(
                                                            ((0xff000U 
                                                              & vlSelf->i_inst) 
                                                             | ((0x800U 
                                                                 & (vlSelf->i_inst 
                                                                    >> 9U)) 
                                                                | (0x7feU 
                                                                   & (vlSelf->i_inst 
                                                                      >> 0x14U)))))))),64);
    bufp->fullBit(oldp+228,((0x37U == (0x7fU & vlSelf->i_inst))));
    bufp->fullBit(oldp+229,((0x17U == (0x7fU & vlSelf->i_inst))));
    bufp->fullBit(oldp+230,((0x6fU == (0x7fU & vlSelf->i_inst))));
    bufp->fullBit(oldp+231,(((0x17U == (0x7fU & vlSelf->i_inst)) 
                             | ((0x6fU == (0x7fU & vlSelf->i_inst)) 
                                | ((IData)(vlSelf->ysyx_22050710_npc__DOT__PCBsrc) 
                                   | ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_addi) 
                                      | (IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_sd)))))));
    __Vtemp_h268169af__0[3U] = (((IData)((((- (QData)((IData)(
                                                              (vlSelf->i_inst 
                                                               >> 0x1fU)))) 
                                           << 0xcU) 
                                          | (QData)((IData)(
                                                            ((0x800U 
                                                              & (vlSelf->i_inst 
                                                                 << 4U)) 
                                                             | ((0x7e0U 
                                                                 & (vlSelf->i_inst 
                                                                    >> 0x14U)) 
                                                                | (0x1eU 
                                                                   & (vlSelf->i_inst 
                                                                      >> 7U)))))))) 
                                 >> 0x1dU) | ((IData)(
                                                      ((((- (QData)((IData)(
                                                                            (vlSelf->i_inst 
                                                                             >> 0x1fU)))) 
                                                         << 0xcU) 
                                                        | (QData)((IData)(
                                                                          ((0x800U 
                                                                            & (vlSelf->i_inst 
                                                                               << 4U)) 
                                                                           | ((0x7e0U 
                                                                               & (vlSelf->i_inst 
                                                                                >> 0x14U)) 
                                                                              | (0x1eU 
                                                                                & (vlSelf->i_inst 
                                                                                >> 7U))))))) 
                                                       >> 0x20U)) 
                                              << 3U));
    __Vtemp_h63fcc034__0[0U] = (IData)((((- (QData)((IData)(
                                                            (vlSelf->i_inst 
                                                             >> 0x1fU)))) 
                                         << 0x14U) 
                                        | (QData)((IData)(
                                                          ((0xff000U 
                                                            & vlSelf->i_inst) 
                                                           | ((0x800U 
                                                               & (vlSelf->i_inst 
                                                                  >> 9U)) 
                                                              | (0x7feU 
                                                                 & (vlSelf->i_inst 
                                                                    >> 0x14U))))))));
    __Vtemp_h63fcc034__0[1U] = (IData)(((((- (QData)((IData)(
                                                             (vlSelf->i_inst 
                                                              >> 0x1fU)))) 
                                          << 0x14U) 
                                         | (QData)((IData)(
                                                           ((0xff000U 
                                                             & vlSelf->i_inst) 
                                                            | ((0x800U 
                                                                & (vlSelf->i_inst 
                                                                   >> 9U)) 
                                                               | (0x7feU 
                                                                  & (vlSelf->i_inst 
                                                                     >> 0x14U))))))) 
                                        >> 0x20U));
    __Vtemp_h63fcc034__0[2U] = (4U | ((IData)((((- (QData)((IData)(
                                                                   (vlSelf->i_inst 
                                                                    >> 0x1fU)))) 
                                                << 0xcU) 
                                               | (QData)((IData)(
                                                                 ((0x800U 
                                                                   & (vlSelf->i_inst 
                                                                      << 4U)) 
                                                                  | ((0x7e0U 
                                                                      & (vlSelf->i_inst 
                                                                         >> 0x14U)) 
                                                                     | (0x1eU 
                                                                        & (vlSelf->i_inst 
                                                                           >> 7U)))))))) 
                                      << 3U));
    __Vtemp_h63fcc034__0[3U] = __Vtemp_h268169af__0[3U];
    __Vtemp_h63fcc034__0[4U] = (0x18U | (((IData)((
                                                   ((- (QData)((IData)(
                                                                       (vlSelf->i_inst 
                                                                        >> 0x1fU)))) 
                                                    << 0xcU) 
                                                   | (QData)((IData)(
                                                                     ((0xfe0U 
                                                                       & (vlSelf->i_inst 
                                                                          >> 0x14U)) 
                                                                      | (0x1fU 
                                                                         & (vlSelf->i_inst 
                                                                            >> 7U))))))) 
                                          << 6U) | 
                                         ((IData)((
                                                   (((- (QData)((IData)(
                                                                        (vlSelf->i_inst 
                                                                         >> 0x1fU)))) 
                                                     << 0xcU) 
                                                    | (QData)((IData)(
                                                                      ((0x800U 
                                                                        & (vlSelf->i_inst 
                                                                           << 4U)) 
                                                                       | ((0x7e0U 
                                                                           & (vlSelf->i_inst 
                                                                              >> 0x14U)) 
                                                                          | (0x1eU 
                                                                             & (vlSelf->i_inst 
                                                                                >> 7U))))))) 
                                                   >> 0x20U)) 
                                          >> 0x1dU)));
    __Vtemp_h63fcc034__0[5U] = (((IData)((((- (QData)((IData)(
                                                              (vlSelf->i_inst 
                                                               >> 0x1fU)))) 
                                           << 0xcU) 
                                          | (QData)((IData)(
                                                            ((0xfe0U 
                                                              & (vlSelf->i_inst 
                                                                 >> 0x14U)) 
                                                             | (0x1fU 
                                                                & (vlSelf->i_inst 
                                                                   >> 7U))))))) 
                                 >> 0x1aU) | ((IData)(
                                                      ((((- (QData)((IData)(
                                                                            (vlSelf->i_inst 
                                                                             >> 0x1fU)))) 
                                                         << 0xcU) 
                                                        | (QData)((IData)(
                                                                          ((0xfe0U 
                                                                            & (vlSelf->i_inst 
                                                                               >> 0x14U)) 
                                                                           | (0x1fU 
                                                                              & (vlSelf->i_inst 
                                                                                >> 7U)))))) 
                                                       >> 0x20U)) 
                                              << 6U));
    __Vtemp_h63fcc034__0[6U] = (0x80U | (((IData)((
                                                   ((QData)((IData)(
                                                                    (- (IData)(
                                                                               (vlSelf->i_inst 
                                                                                >> 0x1fU))))) 
                                                    << 0x20U) 
                                                   | (QData)((IData)(
                                                                     (0xfffff000U 
                                                                      & vlSelf->i_inst))))) 
                                          << 9U) | 
                                         ((IData)((
                                                   (((- (QData)((IData)(
                                                                        (vlSelf->i_inst 
                                                                         >> 0x1fU)))) 
                                                     << 0xcU) 
                                                    | (QData)((IData)(
                                                                      ((0xfe0U 
                                                                        & (vlSelf->i_inst 
                                                                           >> 0x14U)) 
                                                                       | (0x1fU 
                                                                          & (vlSelf->i_inst 
                                                                             >> 7U)))))) 
                                                   >> 0x20U)) 
                                          >> 0x1aU)));
    __Vtemp_h63fcc034__0[7U] = (((IData)((((QData)((IData)(
                                                           (- (IData)(
                                                                      (vlSelf->i_inst 
                                                                       >> 0x1fU))))) 
                                           << 0x20U) 
                                          | (QData)((IData)(
                                                            (0xfffff000U 
                                                             & vlSelf->i_inst))))) 
                                 >> 0x17U) | ((IData)(
                                                      ((((QData)((IData)(
                                                                         (- (IData)(
                                                                                (vlSelf->i_inst 
                                                                                >> 0x1fU))))) 
                                                         << 0x20U) 
                                                        | (QData)((IData)(
                                                                          (0xfffff000U 
                                                                           & vlSelf->i_inst)))) 
                                                       >> 0x20U)) 
                                              << 9U));
    __Vtemp_h63fcc034__0[8U] = (0x200U | (((IData)(
                                                   (((- (QData)((IData)(
                                                                        (vlSelf->i_inst 
                                                                         >> 0x1fU)))) 
                                                     << 0xcU) 
                                                    | (QData)((IData)(
                                                                      (vlSelf->i_inst 
                                                                       >> 0x14U))))) 
                                           << 0xcU) 
                                          | ((IData)(
                                                     ((((QData)((IData)(
                                                                        (- (IData)(
                                                                                (vlSelf->i_inst 
                                                                                >> 0x1fU))))) 
                                                        << 0x20U) 
                                                       | (QData)((IData)(
                                                                         (0xfffff000U 
                                                                          & vlSelf->i_inst)))) 
                                                      >> 0x20U)) 
                                             >> 0x17U)));
    __Vtemp_h63fcc034__0[9U] = (((IData)((((- (QData)((IData)(
                                                              (vlSelf->i_inst 
                                                               >> 0x1fU)))) 
                                           << 0xcU) 
                                          | (QData)((IData)(
                                                            (vlSelf->i_inst 
                                                             >> 0x14U))))) 
                                 >> 0x14U) | ((IData)(
                                                      ((((- (QData)((IData)(
                                                                            (vlSelf->i_inst 
                                                                             >> 0x1fU)))) 
                                                         << 0xcU) 
                                                        | (QData)((IData)(
                                                                          (vlSelf->i_inst 
                                                                           >> 0x14U)))) 
                                                       >> 0x20U)) 
                                              << 0xcU));
    __Vtemp_h63fcc034__0[0xaU] = ((IData)(((((- (QData)((IData)(
                                                                (vlSelf->i_inst 
                                                                 >> 0x1fU)))) 
                                             << 0xcU) 
                                            | (QData)((IData)(
                                                              (vlSelf->i_inst 
                                                               >> 0x14U)))) 
                                           >> 0x20U)) 
                                  >> 0x14U);
    VL_EXTEND_WW(335,332, __Vtemp_h57776156__0, __Vtemp_h63fcc034__0);
    bufp->fullWData(oldp+232,(__Vtemp_h57776156__0),335);
    bufp->fullIData(oldp+243,(3U),32);
    bufp->fullIData(oldp+244,(2U),32);
    bufp->fullIData(oldp+245,(0x40U),32);
    bufp->fullIData(oldp+246,(0U),32);
    bufp->fullQData(oldp+247,(0ULL),64);
    bufp->fullIData(oldp+249,(0x42U),32);
    bufp->fullIData(oldp+250,(3U),32);
    bufp->fullIData(oldp+251,(4U),32);
    bufp->fullIData(oldp+252,(0x44U),32);
    bufp->fullIData(oldp+253,(2U),32);
    bufp->fullIData(oldp+254,(5U),32);
    bufp->fullBit(oldp+255,(0U));
    bufp->fullIData(oldp+256,(6U),32);
    bufp->fullQData(oldp+257,(0x20e8020888260cULL),54);
    bufp->fullCData(oldp+259,(0U),3);
    bufp->fullIData(oldp+260,(9U),32);
    bufp->fullIData(oldp+261,(6U),32);
    bufp->fullIData(oldp+262,(0x43U),32);
    bufp->fullIData(oldp+263,(5U),32);
    bufp->fullCData(oldp+264,(0xfU),4);
    bufp->fullIData(oldp+265,(0x10d01eU),21);
    bufp->fullIData(oldp+266,(1U),32);
    bufp->fullIData(oldp+267,(7U),32);
    bufp->fullBit(oldp+268,(1U));
    bufp->fullQData(oldp+269,(0x80000000ULL),64);
}
