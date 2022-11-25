// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "verilated.h"
#include "verilated_dpi.h"

#include "Vtop___024root.h"

VL_INLINE_OPT void Vtop___024root___ico_sequent__TOP__0(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___ico_sequent__TOP__0\n"); );
    // Init
    VlWide<3>/*95:0*/ __Vtemp_h2ee9131a__0;
    VlWide<3>/*95:0*/ __Vtemp_h0e3ad0fb__0;
    VlWide<3>/*95:0*/ __Vtemp_h2ffc666a__0;
    // Body
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__pair_list[0U][0U] 
        = (IData)((((- (QData)((IData)((vlSelf->i_inst 
                                        >> 0x1fU)))) 
                    << 0x14U) | (QData)((IData)(((0xff000U 
                                                  & vlSelf->i_inst) 
                                                 | ((0x800U 
                                                     & (vlSelf->i_inst 
                                                        >> 9U)) 
                                                    | (0x7feU 
                                                       & (vlSelf->i_inst 
                                                          >> 0x14U))))))));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__pair_list[0U][1U] 
        = (IData)(((((- (QData)((IData)((vlSelf->i_inst 
                                         >> 0x1fU)))) 
                     << 0x14U) | (QData)((IData)(((0xff000U 
                                                   & vlSelf->i_inst) 
                                                  | ((0x800U 
                                                      & (vlSelf->i_inst 
                                                         >> 9U)) 
                                                     | (0x7feU 
                                                        & (vlSelf->i_inst 
                                                           >> 0x14U))))))) 
                   >> 0x20U));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__pair_list[0U][2U] = 4U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__pair_list[1U][0U] 
        = (IData)((((- (QData)((IData)((vlSelf->i_inst 
                                        >> 0x1fU)))) 
                    << 0xcU) | (QData)((IData)(((0x800U 
                                                 & (vlSelf->i_inst 
                                                    << 4U)) 
                                                | ((0x7e0U 
                                                    & (vlSelf->i_inst 
                                                       >> 0x14U)) 
                                                   | (0x1eU 
                                                      & (vlSelf->i_inst 
                                                         >> 7U))))))));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__pair_list[1U][1U] 
        = (IData)(((((- (QData)((IData)((vlSelf->i_inst 
                                         >> 0x1fU)))) 
                     << 0xcU) | (QData)((IData)(((0x800U 
                                                  & (vlSelf->i_inst 
                                                     << 4U)) 
                                                 | ((0x7e0U 
                                                     & (vlSelf->i_inst 
                                                        >> 0x14U)) 
                                                    | (0x1eU 
                                                       & (vlSelf->i_inst 
                                                          >> 7U))))))) 
                   >> 0x20U));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__pair_list[1U][2U] = 3U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__pair_list[2U][0U] 
        = (IData)((((- (QData)((IData)((vlSelf->i_inst 
                                        >> 0x1fU)))) 
                    << 0xcU) | (QData)((IData)(((0xfe0U 
                                                 & (vlSelf->i_inst 
                                                    >> 0x14U)) 
                                                | (0x1fU 
                                                   & (vlSelf->i_inst 
                                                      >> 7U)))))));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__pair_list[2U][1U] 
        = (IData)(((((- (QData)((IData)((vlSelf->i_inst 
                                         >> 0x1fU)))) 
                     << 0xcU) | (QData)((IData)(((0xfe0U 
                                                  & (vlSelf->i_inst 
                                                     >> 0x14U)) 
                                                 | (0x1fU 
                                                    & (vlSelf->i_inst 
                                                       >> 7U)))))) 
                   >> 0x20U));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__pair_list[2U][2U] = 2U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__pair_list[3U][0U] 
        = (IData)((((QData)((IData)((- (IData)((vlSelf->i_inst 
                                                >> 0x1fU))))) 
                    << 0x20U) | (QData)((IData)((0xfffff000U 
                                                 & vlSelf->i_inst)))));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__pair_list[3U][1U] 
        = (IData)(((((QData)((IData)((- (IData)((vlSelf->i_inst 
                                                 >> 0x1fU))))) 
                     << 0x20U) | (QData)((IData)((0xfffff000U 
                                                  & vlSelf->i_inst)))) 
                   >> 0x20U));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__pair_list[3U][2U] = 1U;
    VL_EXTEND_WQ(67,64, __Vtemp_h2ee9131a__0, (((- (QData)((IData)(
                                                                   (vlSelf->i_inst 
                                                                    >> 0x1fU)))) 
                                                << 0xcU) 
                                               | (QData)((IData)(
                                                                 (vlSelf->i_inst 
                                                                  >> 0x14U)))));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__pair_list[4U][0U] 
        = __Vtemp_h2ee9131a__0[0U];
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__pair_list[4U][1U] 
        = __Vtemp_h2ee9131a__0[1U];
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__pair_list[4U][2U] 
        = __Vtemp_h2ee9131a__0[2U];
    if ((0U != (0x1fU & (vlSelf->i_inst >> 0x14U)))) {
        vlSelf->ysyx_22050710_npc__DOT__rs2 = vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf
            [(0x1fU & (vlSelf->i_inst >> 0x14U))];
        vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__data_list[2U] 
            = vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf
            [(0x1fU & (vlSelf->i_inst >> 0x14U))];
    } else {
        vlSelf->ysyx_22050710_npc__DOT__rs2 = 0ULL;
        vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__data_list[2U] = 0ULL;
    }
    vlSelf->ysyx_22050710_npc__DOT__rs1 = ((0U != (0x1fU 
                                                   & (vlSelf->i_inst 
                                                      >> 0xfU)))
                                            ? vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf
                                           [(0x1fU 
                                             & (vlSelf->i_inst 
                                                >> 0xfU))]
                                            : 0ULL);
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__data_list[0U] 
        = (((- (QData)((IData)((vlSelf->i_inst >> 0x1fU)))) 
            << 0x14U) | (QData)((IData)(((0xff000U 
                                          & vlSelf->i_inst) 
                                         | ((0x800U 
                                             & (vlSelf->i_inst 
                                                >> 9U)) 
                                            | (0x7feU 
                                               & (vlSelf->i_inst 
                                                  >> 0x14U)))))));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__data_list[1U] 
        = (((- (QData)((IData)((vlSelf->i_inst >> 0x1fU)))) 
            << 0xcU) | (QData)((IData)(((0x800U & (vlSelf->i_inst 
                                                   << 4U)) 
                                        | ((0x7e0U 
                                            & (vlSelf->i_inst 
                                               >> 0x14U)) 
                                           | (0x1eU 
                                              & (vlSelf->i_inst 
                                                 >> 7U)))))));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__data_list[2U] 
        = (((- (QData)((IData)((vlSelf->i_inst >> 0x1fU)))) 
            << 0xcU) | (QData)((IData)(((0xfe0U & (vlSelf->i_inst 
                                                   >> 0x14U)) 
                                        | (0x1fU & 
                                           (vlSelf->i_inst 
                                            >> 7U))))));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__data_list[3U] 
        = (((QData)((IData)((- (IData)((vlSelf->i_inst 
                                        >> 0x1fU))))) 
            << 0x20U) | (QData)((IData)((0xfffff000U 
                                         & vlSelf->i_inst))));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__data_list[4U] 
        = (((- (QData)((IData)((vlSelf->i_inst >> 0x1fU)))) 
            << 0xcU) | (QData)((IData)((vlSelf->i_inst 
                                        >> 0x14U))));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type_u 
        = ((0x37U == (0x7fU & vlSelf->i_inst)) | (0x17U 
                                                  == 
                                                  (0x7fU 
                                                   & vlSelf->i_inst)));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_sd 
        = (IData)((0x3023U == (0x707fU & vlSelf->i_inst)));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_addi 
        = (IData)((0x13U == (0x707fU & vlSelf->i_inst)));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_ebreak 
        = (IData)((0x73U == (0x707fU & vlSelf->i_inst)));
    vlSelf->ysyx_22050710_npc__DOT__PCBsrc = (IData)(
                                                     (0x67U 
                                                      == 
                                                      (0x707fU 
                                                       & vlSelf->i_inst)));
    VL_EXTEND_WQ(66,64, __Vtemp_h0e3ad0fb__0, vlSelf->ysyx_22050710_npc__DOT__rs2);
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__pair_list[2U][0U] 
        = __Vtemp_h0e3ad0fb__0[0U];
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__pair_list[2U][1U] 
        = __Vtemp_h0e3ad0fb__0[1U];
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__pair_list[2U][2U] 
        = __Vtemp_h0e3ad0fb__0[2U];
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__add_a 
        = (((0x6fU == (0x7fU & vlSelf->i_inst)) | (
                                                   (0x17U 
                                                    == 
                                                    (0x7fU 
                                                     & vlSelf->i_inst)) 
                                                   | (IData)(vlSelf->ysyx_22050710_npc__DOT__PCBsrc)))
            ? vlSelf->o_pc : vlSelf->ysyx_22050710_npc__DOT__rs1);
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT____Vcellinp__u_mux2__key 
        = (((0x37U == (0x7fU & vlSelf->i_inst)) << 2U) 
           | ((((0x17U == (0x7fU & vlSelf->i_inst)) 
                | ((0x6fU == (0x7fU & vlSelf->i_inst)) 
                   | ((IData)(vlSelf->ysyx_22050710_npc__DOT__PCBsrc) 
                      | ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_addi) 
                         | (IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_sd))))) 
               << 1U) | (IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_ebreak)));
    vlSelf->ysyx_22050710_npc__DOT__PCAsrc = ((0x6fU 
                                               == (0x7fU 
                                                   & vlSelf->i_inst)) 
                                              | (IData)(vlSelf->ysyx_22050710_npc__DOT__PCBsrc));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type_i 
        = ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_addi) 
           | ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_ebreak) 
              | (IData)(vlSelf->ysyx_22050710_npc__DOT__PCBsrc)));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__lut_out 
        = ((- (IData)(((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT____Vcellinp__u_mux2__key) 
                       == vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__key_list
                       [0U]))) & vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__data_list
           [0U]);
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__hit 
        = ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT____Vcellinp__u_mux2__key) 
           == vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__key_list
           [0U]);
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__lut_out 
        = ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__lut_out) 
           | ((- (IData)(((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT____Vcellinp__u_mux2__key) 
                          == vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__key_list
                          [1U]))) & vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__data_list
              [1U]));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__hit 
        = ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__hit) 
           | ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT____Vcellinp__u_mux2__key) 
              == vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__key_list
              [1U]));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__lut_out 
        = ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__lut_out) 
           | ((- (IData)(((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT____Vcellinp__u_mux2__key) 
                          == vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__key_list
                          [2U]))) & vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__data_list
              [2U]));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__hit 
        = ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__hit) 
           | ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT____Vcellinp__u_mux2__key) 
              == vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__key_list
              [2U]));
    vlSelf->ysyx_22050710_npc__DOT__ALUctr = ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__hit)
                                               ? (IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__lut_out)
                                               : 0xfU);
    vlSelf->ysyx_22050710_npc__DOT__ALUBsrc = (((IData)(vlSelf->ysyx_22050710_npc__DOT__PCAsrc) 
                                                << 1U) 
                                               | ((~ (IData)(vlSelf->ysyx_22050710_npc__DOT__PCBsrc)) 
                                                  & ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type_i) 
                                                     | ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type_u) 
                                                        | (IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_sd)))));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type 
        = (((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type_i) 
            << 4U) | (((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type_u) 
                       << 3U) | (((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_sd) 
                                  << 2U) | (0x6fU == 
                                            (0x7fU 
                                             & vlSelf->i_inst)))));
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__hit 
        = ((IData)(vlSelf->ysyx_22050710_npc__DOT__ALUctr) 
           == vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__key_list
           [0U]);
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__hit 
        = ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__hit) 
           | ((IData)(vlSelf->ysyx_22050710_npc__DOT__ALUctr) 
              == vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__key_list
              [1U]));
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__hit 
        = ((IData)(vlSelf->ysyx_22050710_npc__DOT__ALUBsrc) 
           == vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__key_list
           [0U]);
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__hit 
        = ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__hit) 
           | ((IData)(vlSelf->ysyx_22050710_npc__DOT__ALUBsrc) 
              == vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__key_list
              [1U]));
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__hit 
        = ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__hit) 
           | ((IData)(vlSelf->ysyx_22050710_npc__DOT__ALUBsrc) 
              == vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__key_list
              [2U]));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__hit 
        = ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type) 
           == vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list
           [0U]);
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__hit 
        = ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__hit) 
           | ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type) 
              == vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list
              [1U]));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__hit 
        = ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__hit) 
           | ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type) 
              == vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list
              [2U]));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__hit 
        = ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__hit) 
           | ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type) 
              == vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list
              [3U]));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__hit 
        = ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__hit) 
           | ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type) 
              == vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list
              [4U]));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__hit 
        = ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__hit) 
           | ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type) 
              == vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list
              [5U]));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__lut_out 
        = ((- (IData)(((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type) 
                       == vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list
                       [0U]))) & vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__data_list
           [0U]);
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__lut_out 
        = ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__lut_out) 
           | ((- (IData)(((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type) 
                          == vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list
                          [1U]))) & vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__data_list
              [1U]));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__lut_out 
        = ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__lut_out) 
           | ((- (IData)(((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type) 
                          == vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list
                          [2U]))) & vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__data_list
              [2U]));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__lut_out 
        = ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__lut_out) 
           | ((- (IData)(((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type) 
                          == vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list
                          [3U]))) & vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__data_list
              [3U]));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__lut_out 
        = ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__lut_out) 
           | ((- (IData)(((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type) 
                          == vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list
                          [4U]))) & vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__data_list
              [4U]));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__lut_out 
        = ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__lut_out) 
           | ((- (IData)(((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type) 
                          == vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list
                          [5U]))) & vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__data_list
              [5U]));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__extop 
        = vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__lut_out;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__hit 
        = ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__extop) 
           == vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__key_list
           [0U]);
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__hit 
        = ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__hit) 
           | ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__extop) 
              == vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__key_list
              [1U]));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__hit 
        = ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__hit) 
           | ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__extop) 
              == vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__key_list
              [2U]));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__hit 
        = ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__hit) 
           | ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__extop) 
              == vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__key_list
              [3U]));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__hit 
        = ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__hit) 
           | ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__extop) 
              == vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__key_list
              [4U]));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__lut_out 
        = ((- (QData)((IData)(((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__extop) 
                               == vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__key_list
                               [0U])))) & vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__data_list
           [0U]);
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__lut_out 
        = (vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__lut_out 
           | ((- (QData)((IData)(((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__extop) 
                                  == vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__key_list
                                  [1U])))) & vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__data_list
              [1U]));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__lut_out 
        = (vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__lut_out 
           | ((- (QData)((IData)(((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__extop) 
                                  == vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__key_list
                                  [2U])))) & vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__data_list
              [2U]));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__lut_out 
        = (vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__lut_out 
           | ((- (QData)((IData)(((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__extop) 
                                  == vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__key_list
                                  [3U])))) & vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__data_list
              [3U]));
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__lut_out 
        = (vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__lut_out 
           | ((- (QData)((IData)(((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__extop) 
                                  == vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__key_list
                                  [4U])))) & vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__data_list
              [4U]));
    vlSelf->ysyx_22050710_npc__DOT__imm = vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__lut_out;
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__pair_list[1U][0U] 
        = (IData)(vlSelf->ysyx_22050710_npc__DOT__imm);
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__pair_list[1U][1U] 
        = (IData)((vlSelf->ysyx_22050710_npc__DOT__imm 
                   >> 0x20U));
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__pair_list[1U][2U] = 1U;
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__pair_list[1U][0U] 
        = (IData)(vlSelf->ysyx_22050710_npc__DOT__imm);
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__pair_list[1U][1U] 
        = (IData)((vlSelf->ysyx_22050710_npc__DOT__imm 
                   >> 0x20U));
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__pair_list[1U][2U] = 3U;
    vlSelf->ysyx_22050710_npc__DOT__pc_adder = (((IData)(vlSelf->ysyx_22050710_npc__DOT__PCBsrc)
                                                  ? vlSelf->ysyx_22050710_npc__DOT__rs1
                                                  : vlSelf->o_pc) 
                                                + ((IData)(vlSelf->ysyx_22050710_npc__DOT__PCAsrc)
                                                    ? vlSelf->ysyx_22050710_npc__DOT__imm
                                                    : 4ULL));
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__data_list[1U] 
        = vlSelf->ysyx_22050710_npc__DOT__imm;
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__data_list[1U] 
        = vlSelf->ysyx_22050710_npc__DOT__imm;
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__lut_out 
        = ((- (QData)((IData)(((IData)(vlSelf->ysyx_22050710_npc__DOT__ALUBsrc) 
                               == vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__key_list
                               [0U])))) & vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__data_list
           [0U]);
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__lut_out 
        = (vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__lut_out 
           | ((- (QData)((IData)(((IData)(vlSelf->ysyx_22050710_npc__DOT__ALUBsrc) 
                                  == vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__key_list
                                  [1U])))) & vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__data_list
              [1U]));
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__lut_out 
        = (vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__lut_out 
           | ((- (QData)((IData)(((IData)(vlSelf->ysyx_22050710_npc__DOT__ALUBsrc) 
                                  == vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__key_list
                                  [2U])))) & vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__data_list
              [2U]));
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__add_b 
        = vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__lut_out;
    VL_EXTEND_WQ(68,64, __Vtemp_h2ffc666a__0, (vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__add_a 
                                               + vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__add_b));
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__pair_list[0U][0U] 
        = __Vtemp_h2ffc666a__0[0U];
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__pair_list[0U][1U] 
        = __Vtemp_h2ffc666a__0[1U];
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__pair_list[0U][2U] 
        = __Vtemp_h2ffc666a__0[2U];
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__data_list[0U] 
        = (vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__add_a 
           + vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__add_b);
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__lut_out 
        = ((- (QData)((IData)(((IData)(vlSelf->ysyx_22050710_npc__DOT__ALUctr) 
                               == vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__key_list
                               [0U])))) & vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__data_list
           [0U]);
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__lut_out 
        = (vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__lut_out 
           | ((- (QData)((IData)(((IData)(vlSelf->ysyx_22050710_npc__DOT__ALUctr) 
                                  == vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__key_list
                                  [1U])))) & vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__data_list
              [1U]));
    vlSelf->ysyx_22050710_npc__DOT__ALUresult = vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__lut_out;
}

void Vtop___024root___eval_ico(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_ico\n"); );
    // Body
    if (vlSelf->__VicoTriggered.at(0U)) {
        Vtop___024root___ico_sequent__TOP__0(vlSelf);
        vlSelf->__Vm_traceActivity[1U] = 1U;
    }
}

void Vtop___024root___eval_act(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_act\n"); );
}

VL_INLINE_OPT void Vtop___024root___nba_sequent__TOP__1(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___nba_sequent__TOP__1\n"); );
    // Init
    CData/*4:0*/ __Vdlyvdim0__ysyx_22050710_npc__DOT__u_gprs__DOT__rf__v0;
    QData/*63:0*/ __Vdlyvval__ysyx_22050710_npc__DOT__u_gprs__DOT__rf__v0;
    CData/*0:0*/ __Vdlyvset__ysyx_22050710_npc__DOT__u_gprs__DOT__rf__v0;
    VlWide<3>/*95:0*/ __Vtemp_h0e3ad0fb__0;
    // Body
    __Vdlyvset__ysyx_22050710_npc__DOT__u_gprs__DOT__rf__v0 = 0U;
    if (((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type_i) 
         | ((IData)(vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__inst_type_u) 
            | (0x6fU == (0x7fU & vlSelf->i_inst))))) {
        __Vdlyvval__ysyx_22050710_npc__DOT__u_gprs__DOT__rf__v0 
            = vlSelf->ysyx_22050710_npc__DOT__ALUresult;
        __Vdlyvset__ysyx_22050710_npc__DOT__u_gprs__DOT__rf__v0 = 1U;
        __Vdlyvdim0__ysyx_22050710_npc__DOT__u_gprs__DOT__rf__v0 
            = (0x1fU & (vlSelf->i_inst >> 7U));
    }
    vlSelf->o_pc = ((IData)(vlSelf->i_rst) ? 0x80000000ULL
                     : vlSelf->ysyx_22050710_npc__DOT__pc_adder);
    if (__Vdlyvset__ysyx_22050710_npc__DOT__u_gprs__DOT__rf__v0) {
        vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf[__Vdlyvdim0__ysyx_22050710_npc__DOT__u_gprs__DOT__rf__v0] 
            = __Vdlyvval__ysyx_22050710_npc__DOT__u_gprs__DOT__rf__v0;
    }
    if ((0U != (0x1fU & (vlSelf->i_inst >> 0x14U)))) {
        vlSelf->ysyx_22050710_npc__DOT__rs2 = vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf
            [(0x1fU & (vlSelf->i_inst >> 0x14U))];
        vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__data_list[2U] 
            = vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf
            [(0x1fU & (vlSelf->i_inst >> 0x14U))];
    } else {
        vlSelf->ysyx_22050710_npc__DOT__rs2 = 0ULL;
        vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__data_list[2U] = 0ULL;
    }
    vlSelf->ysyx_22050710_npc__DOT__rs1 = ((0U != (0x1fU 
                                                   & (vlSelf->i_inst 
                                                      >> 0xfU)))
                                            ? vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf
                                           [(0x1fU 
                                             & (vlSelf->i_inst 
                                                >> 0xfU))]
                                            : 0ULL);
    VL_EXTEND_WQ(66,64, __Vtemp_h0e3ad0fb__0, vlSelf->ysyx_22050710_npc__DOT__rs2);
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__pair_list[2U][0U] 
        = __Vtemp_h0e3ad0fb__0[0U];
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__pair_list[2U][1U] 
        = __Vtemp_h0e3ad0fb__0[1U];
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__pair_list[2U][2U] 
        = __Vtemp_h0e3ad0fb__0[2U];
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__add_a 
        = (((0x6fU == (0x7fU & vlSelf->i_inst)) | (
                                                   (0x17U 
                                                    == 
                                                    (0x7fU 
                                                     & vlSelf->i_inst)) 
                                                   | (IData)(vlSelf->ysyx_22050710_npc__DOT__PCBsrc)))
            ? vlSelf->o_pc : vlSelf->ysyx_22050710_npc__DOT__rs1);
}

VL_INLINE_OPT void Vtop___024root___nba_sequent__TOP__2(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___nba_sequent__TOP__2\n"); );
    // Init
    VlWide<3>/*95:0*/ __Vtemp_h2ffc666a__0;
    // Body
    vlSelf->ysyx_22050710_npc__DOT__pc_adder = (((IData)(vlSelf->ysyx_22050710_npc__DOT__PCBsrc)
                                                  ? vlSelf->ysyx_22050710_npc__DOT__rs1
                                                  : vlSelf->o_pc) 
                                                + ((IData)(vlSelf->ysyx_22050710_npc__DOT__PCAsrc)
                                                    ? vlSelf->ysyx_22050710_npc__DOT__imm
                                                    : 4ULL));
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__lut_out 
        = ((- (QData)((IData)(((IData)(vlSelf->ysyx_22050710_npc__DOT__ALUBsrc) 
                               == vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__key_list
                               [0U])))) & vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__data_list
           [0U]);
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__lut_out 
        = (vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__lut_out 
           | ((- (QData)((IData)(((IData)(vlSelf->ysyx_22050710_npc__DOT__ALUBsrc) 
                                  == vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__key_list
                                  [1U])))) & vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__data_list
              [1U]));
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__lut_out 
        = (vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__lut_out 
           | ((- (QData)((IData)(((IData)(vlSelf->ysyx_22050710_npc__DOT__ALUBsrc) 
                                  == vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__key_list
                                  [2U])))) & vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__data_list
              [2U]));
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__add_b 
        = vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__lut_out;
    VL_EXTEND_WQ(68,64, __Vtemp_h2ffc666a__0, (vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__add_a 
                                               + vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__add_b));
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__pair_list[0U][0U] 
        = __Vtemp_h2ffc666a__0[0U];
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__pair_list[0U][1U] 
        = __Vtemp_h2ffc666a__0[1U];
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__pair_list[0U][2U] 
        = __Vtemp_h2ffc666a__0[2U];
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__data_list[0U] 
        = (vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__add_a 
           + vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__add_b);
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__lut_out 
        = ((- (QData)((IData)(((IData)(vlSelf->ysyx_22050710_npc__DOT__ALUctr) 
                               == vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__key_list
                               [0U])))) & vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__data_list
           [0U]);
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__lut_out 
        = (vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__lut_out 
           | ((- (QData)((IData)(((IData)(vlSelf->ysyx_22050710_npc__DOT__ALUctr) 
                                  == vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__key_list
                                  [1U])))) & vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__data_list
              [1U]));
    vlSelf->ysyx_22050710_npc__DOT__ALUresult = vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__lut_out;
}

void Vtop___024root___nba_sequent__TOP__0(Vtop___024root* vlSelf);

void Vtop___024root___eval_nba(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_nba\n"); );
    // Body
    if (vlSelf->__VnbaTriggered.at(1U)) {
        Vtop___024root___nba_sequent__TOP__0(vlSelf);
    }
    if (vlSelf->__VnbaTriggered.at(0U)) {
        Vtop___024root___nba_sequent__TOP__1(vlSelf);
        vlSelf->__Vm_traceActivity[2U] = 1U;
        Vtop___024root___nba_sequent__TOP__2(vlSelf);
    }
}

void Vtop___024root___eval_triggers__ico(Vtop___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__ico(Vtop___024root* vlSelf);
#endif  // VL_DEBUG
void Vtop___024root___eval_triggers__act(Vtop___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__act(Vtop___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__nba(Vtop___024root* vlSelf);
#endif  // VL_DEBUG

void Vtop___024root___eval(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval\n"); );
    // Init
    CData/*0:0*/ __VicoContinue;
    VlTriggerVec<2> __VpreTriggered;
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    vlSelf->__VicoIterCount = 0U;
    __VicoContinue = 1U;
    while (__VicoContinue) {
        __VicoContinue = 0U;
        Vtop___024root___eval_triggers__ico(vlSelf);
        if (vlSelf->__VicoTriggered.any()) {
            __VicoContinue = 1U;
            if ((0x64U < vlSelf->__VicoIterCount)) {
#ifdef VL_DEBUG
                Vtop___024root___dump_triggers__ico(vlSelf);
#endif
                VL_FATAL_MT("/home/einsam/p/ysyx-workbench/npc/vsrc/npc.v", 4, "", "Input combinational region did not converge.");
            }
            vlSelf->__VicoIterCount = ((IData)(1U) 
                                       + vlSelf->__VicoIterCount);
            Vtop___024root___eval_ico(vlSelf);
        }
    }
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        __VnbaContinue = 0U;
        vlSelf->__VnbaTriggered.clear();
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            vlSelf->__VactContinue = 0U;
            Vtop___024root___eval_triggers__act(vlSelf);
            if (vlSelf->__VactTriggered.any()) {
                vlSelf->__VactContinue = 1U;
                if ((0x64U < vlSelf->__VactIterCount)) {
#ifdef VL_DEBUG
                    Vtop___024root___dump_triggers__act(vlSelf);
#endif
                    VL_FATAL_MT("/home/einsam/p/ysyx-workbench/npc/vsrc/npc.v", 4, "", "Active region did not converge.");
                }
                vlSelf->__VactIterCount = ((IData)(1U) 
                                           + vlSelf->__VactIterCount);
                __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
                vlSelf->__VnbaTriggered.set(vlSelf->__VactTriggered);
                Vtop___024root___eval_act(vlSelf);
            }
        }
        if (vlSelf->__VnbaTriggered.any()) {
            __VnbaContinue = 1U;
            if ((0x64U < __VnbaIterCount)) {
#ifdef VL_DEBUG
                Vtop___024root___dump_triggers__nba(vlSelf);
#endif
                VL_FATAL_MT("/home/einsam/p/ysyx-workbench/npc/vsrc/npc.v", 4, "", "NBA region did not converge.");
            }
            __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
            Vtop___024root___eval_nba(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
void Vtop___024root___eval_debug_assertions(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->i_clk & 0xfeU))) {
        Verilated::overWidthError("i_clk");}
    if (VL_UNLIKELY((vlSelf->i_rst & 0xfeU))) {
        Verilated::overWidthError("i_rst");}
}
#endif  // VL_DEBUG
