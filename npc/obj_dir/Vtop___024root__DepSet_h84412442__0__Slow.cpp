// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "verilated.h"
#include "verilated_dpi.h"

#include "Vtop__Syms.h"
#include "Vtop___024root.h"

void Vtop___024unit____Vdpiimwrap_set_inst_ptr__Vdpioc2_TOP____024unit(const IData/*31:0*/ &a);
void Vtop___024unit____Vdpiimwrap_set_gpr_ptr__Vdpioc2_TOP____024unit(const VlUnpacked<QData/*63:0*/, 32> &a);

VL_ATTR_COLD void Vtop___024root___eval_initial__TOP(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_initial__TOP\n"); );
    // Body
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__key_list[0U] = 4U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__key_list[1U] = 3U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__key_list[2U] = 2U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__key_list[3U] = 1U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux1__DOT__i0__DOT__key_list[4U] = 0U;
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__key_list[0U] = 2U;
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__key_list[1U] = 1U;
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__key_list[2U] = 0U;
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__data_list[0U] = 4ULL;
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__pair_list[0U][0U] = 4U;
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__pair_list[0U][1U] = 0U;
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux0__DOT__i0__DOT__pair_list[0U][2U] = 2U;
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__key_list[0U] = 0U;
    vlSelf->ysyx_22050710_npc__DOT__u_exu__DOT__u_mux1__DOT__i0__DOT__key_list[1U] = 3U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list[0U] = 1U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list[1U] = 2U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list[2U] = 4U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list[3U] = 8U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list[4U] = 0x10U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__key_list[5U] = 0x20U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__data_list[0U] = 4U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__data_list[1U] = 3U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__data_list[2U] = 2U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__data_list[3U] = 1U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__data_list[4U] = 0U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__data_list[5U] = 7U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__pair_list[0U] = 0xcU;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__pair_list[1U] = 0x13U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__pair_list[2U] = 0x22U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__pair_list[3U] = 0x41U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__pair_list[4U] = 0x80U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux0__DOT__i0__DOT__pair_list[5U] = 0x107U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__key_list[0U] = 1U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__key_list[1U] = 2U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__key_list[2U] = 4U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__data_list[0U] = 0xeU;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__data_list[1U] = 0U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__data_list[2U] = 3U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__pair_list[0U] = 0x1eU;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__pair_list[1U] = 0x20U;
    vlSelf->ysyx_22050710_npc__DOT__u_idu__DOT__u_mux2__DOT__i0__DOT__pair_list[2U] = 0x43U;
    Vtop___024unit____Vdpiimwrap_set_inst_ptr__Vdpioc2_TOP____024unit(vlSelf->i_inst);
    Vtop___024unit____Vdpiimwrap_set_gpr_ptr__Vdpioc2_TOP____024unit(vlSelf->ysyx_22050710_npc__DOT__u_gprs__DOT__rf);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__stl(Vtop___024root* vlSelf);
#endif  // VL_DEBUG

VL_ATTR_COLD void Vtop___024root___eval_triggers__stl(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_triggers__stl\n"); );
    // Body
    vlSelf->__VstlTriggered.at(0U) = (0U == vlSelf->__VstlIterCount);
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vtop___024root___dump_triggers__stl(vlSelf);
    }
#endif
}
