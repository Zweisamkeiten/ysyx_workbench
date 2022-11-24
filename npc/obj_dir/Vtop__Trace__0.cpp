// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vtop__Syms.h"


void Vtop___024root__trace_chg_sub_0(Vtop___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vtop___024root__trace_chg_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root__trace_chg_top_0\n"); );
    // Init
    Vtop___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtop___024root*>(voidSelf);
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    Vtop___024root__trace_chg_sub_0((&vlSymsp->TOP), bufp);
}

void Vtop___024root__trace_chg_sub_0(Vtop___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root__trace_chg_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    VlWide<7>/*223:0*/ __Vtemp_h8ca9881f__0;
    VlWide<7>/*223:0*/ __Vtemp_hdca9a15a__0;
    VlWide<3>/*95:0*/ __Vtemp_h2ffc666a__0;
    VlWide<5>/*159:0*/ __Vtemp_h31f01f78__0;
    VlWide<5>/*159:0*/ __Vtemp_h268169af__0;
    VlWide<11>/*351:0*/ __Vtemp_h63fcc034__0;
    VlWide<11>/*351:0*/ __Vtemp_h57776156__0;
    // Body
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[0U])) {
        bufp->chgCData(oldp+0,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+1,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+2,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+3,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__key_list[0]),4);
        bufp->chgCData(oldp+4,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__key_list[1]),4);
        bufp->chgSData(oldp+5,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__pair_list[0]),9);
        bufp->chgSData(oldp+6,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__pair_list[1]),9);
        bufp->chgSData(oldp+7,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__pair_list[2]),9);
        bufp->chgSData(oldp+8,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__pair_list[3]),9);
        bufp->chgSData(oldp+9,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__pair_list[4]),9);
        bufp->chgSData(oldp+10,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__pair_list[5]),9);
        bufp->chgCData(oldp+11,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list[0]),6);
        bufp->chgCData(oldp+12,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list[1]),6);
        bufp->chgCData(oldp+13,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list[2]),6);
        bufp->chgCData(oldp+14,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list[3]),6);
        bufp->chgCData(oldp+15,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list[4]),6);
        bufp->chgCData(oldp+16,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list[5]),6);
        bufp->chgCData(oldp+17,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__data_list[0]),3);
        bufp->chgCData(oldp+18,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__data_list[1]),3);
        bufp->chgCData(oldp+19,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__data_list[2]),3);
        bufp->chgCData(oldp+20,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__data_list[3]),3);
        bufp->chgCData(oldp+21,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__data_list[4]),3);
        bufp->chgCData(oldp+22,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__data_list[5]),3);
        bufp->chgCData(oldp+23,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__key_list[0]),3);
        bufp->chgCData(oldp+24,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__key_list[1]),3);
        bufp->chgCData(oldp+25,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__key_list[2]),3);
        bufp->chgCData(oldp+26,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__key_list[3]),3);
        bufp->chgCData(oldp+27,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__key_list[4]),3);
        bufp->chgCData(oldp+28,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__pair_list[0]),7);
        bufp->chgCData(oldp+29,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__pair_list[1]),7);
        bufp->chgCData(oldp+30,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__pair_list[2]),7);
        bufp->chgCData(oldp+31,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__key_list[0]),3);
        bufp->chgCData(oldp+32,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__key_list[1]),3);
        bufp->chgCData(oldp+33,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__key_list[2]),3);
        bufp->chgCData(oldp+34,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__data_list[0]),4);
        bufp->chgCData(oldp+35,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__data_list[1]),4);
        bufp->chgCData(oldp+36,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__data_list[2]),4);
    }
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[1U])) {
        bufp->chgQData(oldp+37,(vlSelf->ysyx_22050710_npc__DOT__imm),64);
        bufp->chgCData(oldp+39,(vlSelf->ysyx_22050710_npc__DOT__ALUBsrc),2);
        bufp->chgCData(oldp+40,(vlSelf->ysyx_22050710_npc__DOT__ALUctr),4);
        bufp->chgBit(oldp+41,(vlSelf->ysyx_22050710_npc__DOT__PCAsrc));
        bufp->chgBit(oldp+42,(vlSelf->ysyx_22050710_npc__DOT__PCBsrc));
        bufp->chgBit(oldp+43,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+44,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+45,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_addi));
        bufp->chgBit(oldp+46,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_ebreak));
        bufp->chgBit(oldp+47,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_sd));
        bufp->chgBit(oldp+48,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type_i));
        bufp->chgBit(oldp+49,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type_u));
        bufp->chgCData(oldp+50,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__extop),3);
        bufp->chgCData(oldp+51,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type),6);
        bufp->chgCData(oldp+52,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__lut_out),3);
        bufp->chgBit(oldp+53,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__hit));
        bufp->chgWData(oldp+54,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__pair_list[0]),67);
        bufp->chgWData(oldp+57,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__pair_list[1]),67);
        bufp->chgWData(oldp+60,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__pair_list[2]),67);
        bufp->chgWData(oldp+63,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__pair_list[3]),67);
        bufp->chgWData(oldp+66,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__pair_list[4]),67);
        bufp->chgQData(oldp+69,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__data_list[0]),64);
        bufp->chgQData(oldp+71,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__data_list[1]),64);
        bufp->chgQData(oldp+73,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__data_list[2]),64);
        bufp->chgQData(oldp+75,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__data_list[3]),64);
        bufp->chgQData(oldp+77,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__data_list[4]),64);
        bufp->chgQData(oldp+79,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__lut_out),64);
        bufp->chgBit(oldp+81,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__hit));
        bufp->chgCData(oldp+82,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT____Vcellinp__u_mux2__key),3);
        bufp->chgCData(oldp+83,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__lut_out),4);
        bufp->chgBit(oldp+84,(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__hit));
    }
    if (VL_UNLIKELY((vlSelf->__Vm_traceActivity[1U] 
                     | vlSelf->__Vm_traceActivity[2U]))) {
        bufp->chgQData(oldp+85,(vlSelf->ysyx_22050710_npc__DOT__rs1),64);
        bufp->chgQData(oldp+87,(vlSelf->ysyx_22050710_npc__DOT__rs2),64);
        bufp->chgQData(oldp+89,(vlSelf->ysyx_22050710_npc__DOT__ALUresult),64);
        bufp->chgQData(oldp+91,((vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__add_a 
                                 + vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__add_b)),64);
        bufp->chgQData(oldp+93,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__add_a),64);
        bufp->chgQData(oldp+95,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__add_b),64);
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
                                           << 4U) | 
                                          ((IData)(
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
        bufp->chgWData(oldp+97,(__Vtemp_hdca9a15a__0),198);
        bufp->chgWData(oldp+104,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__pair_list[0]),66);
        bufp->chgWData(oldp+107,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__pair_list[1]),66);
        bufp->chgWData(oldp+110,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__pair_list[2]),66);
        bufp->chgQData(oldp+113,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__data_list[0]),64);
        bufp->chgQData(oldp+115,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__data_list[1]),64);
        bufp->chgQData(oldp+117,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__data_list[2]),64);
        bufp->chgQData(oldp+119,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__lut_out),64);
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
        __Vtemp_h31f01f78__0[4U] = (0x30U | ((IData)(
                                                     (vlSelf->ysyx_22050710_npc__DOT__imm 
                                                      >> 0x20U)) 
                                             >> 0x1cU));
        bufp->chgWData(oldp+121,(__Vtemp_h31f01f78__0),136);
        bufp->chgWData(oldp+126,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__pair_list[0]),68);
        bufp->chgWData(oldp+129,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__pair_list[1]),68);
        bufp->chgQData(oldp+132,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__data_list[0]),64);
        bufp->chgQData(oldp+134,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__data_list[1]),64);
        bufp->chgQData(oldp+136,(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__lut_out),64);
    }
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[2U])) {
        bufp->chgQData(oldp+138,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[0]),64);
        bufp->chgQData(oldp+140,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[1]),64);
        bufp->chgQData(oldp+142,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[2]),64);
        bufp->chgQData(oldp+144,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[3]),64);
        bufp->chgQData(oldp+146,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[4]),64);
        bufp->chgQData(oldp+148,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[5]),64);
        bufp->chgQData(oldp+150,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[6]),64);
        bufp->chgQData(oldp+152,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[7]),64);
        bufp->chgQData(oldp+154,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[8]),64);
        bufp->chgQData(oldp+156,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[9]),64);
        bufp->chgQData(oldp+158,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[10]),64);
        bufp->chgQData(oldp+160,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[11]),64);
        bufp->chgQData(oldp+162,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[12]),64);
        bufp->chgQData(oldp+164,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[13]),64);
        bufp->chgQData(oldp+166,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[14]),64);
        bufp->chgQData(oldp+168,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[15]),64);
        bufp->chgQData(oldp+170,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[16]),64);
        bufp->chgQData(oldp+172,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[17]),64);
        bufp->chgQData(oldp+174,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[18]),64);
        bufp->chgQData(oldp+176,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[19]),64);
        bufp->chgQData(oldp+178,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[20]),64);
        bufp->chgQData(oldp+180,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[21]),64);
        bufp->chgQData(oldp+182,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[22]),64);
        bufp->chgQData(oldp+184,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[23]),64);
        bufp->chgQData(oldp+186,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[24]),64);
        bufp->chgQData(oldp+188,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[25]),64);
        bufp->chgQData(oldp+190,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[26]),64);
        bufp->chgQData(oldp+192,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[27]),64);
        bufp->chgQData(oldp+194,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[28]),64);
        bufp->chgQData(oldp+196,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[29]),64);
        bufp->chgQData(oldp+198,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[30]),64);
        bufp->chgQData(oldp+200,(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[31]),64);
    }
    bufp->chgBit(oldp+202,(vlSelf->i_clk));
    bufp->chgBit(oldp+203,(vlSelf->i_rst));
    bufp->chgIData(oldp+204,(vlSelf->i_inst),32);
    bufp->chgQData(oldp+205,(vlSelf->o_pc),64);
    bufp->chgQData(oldp+207,((((IData)(vlSelf->ysyx_22050710_npc__DOT__PCBsrc)
                                ? vlSelf->ysyx_22050710_npc__DOT__rs1
                                : vlSelf->o_pc) + ((IData)(vlSelf->ysyx_22050710_npc__DOT__PCAsrc)
                                                    ? vlSelf->ysyx_22050710_npc__DOT__imm
                                                    : 4ULL))),64);
    bufp->chgCData(oldp+209,((0x1fU & (vlSelf->i_inst 
                                       >> 0xfU))),5);
    bufp->chgCData(oldp+210,((0x1fU & (vlSelf->i_inst 
                                       >> 0x14U))),5);
    bufp->chgCData(oldp+211,((0x1fU & (vlSelf->i_inst 
                                       >> 7U))),5);
    bufp->chgBit(oldp+212,(((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type_i) 
                            | ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type_u) 
                               | (0x6fU == (0x7fU & vlSelf->i_inst))))));
    bufp->chgBit(oldp+213,(((0x6fU == (0x7fU & vlSelf->i_inst)) 
                            | ((0x17U == (0x7fU & vlSelf->i_inst)) 
                               | (IData)(vlSelf->ysyx_22050710_npc__DOT__PCBsrc)))));
    bufp->chgCData(oldp+214,((0x7fU & vlSelf->i_inst)),7);
    bufp->chgCData(oldp+215,((7U & (vlSelf->i_inst 
                                    >> 0xcU))),3);
    bufp->chgCData(oldp+216,((vlSelf->i_inst >> 0x19U)),7);
    bufp->chgQData(oldp+217,((((- (QData)((IData)((vlSelf->i_inst 
                                                   >> 0x1fU)))) 
                               << 0xcU) | (QData)((IData)(
                                                          (vlSelf->i_inst 
                                                           >> 0x14U))))),64);
    bufp->chgQData(oldp+219,((((QData)((IData)((- (IData)(
                                                          (vlSelf->i_inst 
                                                           >> 0x1fU))))) 
                               << 0x20U) | (QData)((IData)(
                                                           (0xfffff000U 
                                                            & vlSelf->i_inst))))),64);
    bufp->chgQData(oldp+221,((((- (QData)((IData)((vlSelf->i_inst 
                                                   >> 0x1fU)))) 
                               << 0xcU) | (QData)((IData)(
                                                          ((0xfe0U 
                                                            & (vlSelf->i_inst 
                                                               >> 0x14U)) 
                                                           | (0x1fU 
                                                              & (vlSelf->i_inst 
                                                                 >> 7U))))))),64);
    bufp->chgQData(oldp+223,((((- (QData)((IData)((vlSelf->i_inst 
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
    bufp->chgQData(oldp+225,((((- (QData)((IData)((vlSelf->i_inst 
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
    bufp->chgBit(oldp+227,((0x37U == (0x7fU & vlSelf->i_inst))));
    bufp->chgBit(oldp+228,((0x17U == (0x7fU & vlSelf->i_inst))));
    bufp->chgBit(oldp+229,((0x6fU == (0x7fU & vlSelf->i_inst))));
    bufp->chgBit(oldp+230,(((0x17U == (0x7fU & vlSelf->i_inst)) 
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
    bufp->chgWData(oldp+231,(__Vtemp_h57776156__0),335);
}

void Vtop___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root__trace_cleanup\n"); );
    // Init
    Vtop___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtop___024root*>(voidSelf);
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[2U] = 0U;
}
