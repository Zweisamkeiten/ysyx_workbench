// ysyx_22050710 NPC CORE

module ysyx_22050710_core (
  input i_clk,
  input i_rst,
  // inst sram interface
  output        o_inst_sram_en,
  output [31:0] o_inst_sram_addr,
  input  [63:0] i_inst_sram_rdata
);

  wire [31:0] inst; wire [63:0] pc;
  wire [63:0] nextpc = sys_change_pc ? sysctr_pc : brtarget;
  wire ifu_ready;
  ysyx_22050710_ifu u_ifu (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_nextpc(nextpc),
    .o_ifu_ready(ifu_ready),
    .o_pc(pc),
    .o_inst(inst),
    // inst sram interface
    .o_inst_sram_en   (o_inst_sram_en   ),
    .o_inst_sram_addr (o_inst_sram_addr ),
    .i_inst_sram_rdata(i_inst_sram_rdata)
  );

  wire [63:0] rs1data, rs2data;
  wire [63:0] GPRbusW;
  wire [63:0] imm, zimm;
  wire bren;
  wire [2:0] brfunc;
  wire ALUAsrc; wire [1:0] ALUBsrc; wire [4:0] ALUctr;
  wire word_cut;
  wire ws_rf_wen, ws_csrrf_wen, RegWr, MemtoReg, MemWr, MemRe; wire [2:0] MemOP;
  wire [3:0] EXctr;
  wire is_invalid_inst;
  wire sel_csr, sel_zimm, CsrWr;
  wire [63:0] csrrdata;
  wire [63:0] CSRbusW;
  wire [63:0] sysctr_pc; wire sys_change_pc;
  wire [4:0] rd;
  ysyx_22050710_idu u_idu (
    .i_clk(i_clk),
    .i_pc(pc),
    .i_inst(inst),
    .i_ifu_ready(ifu_ready),
    .i_GPRbusW(GPRbusW),
    .i_CSRbusW(CSRbusW),
    .i_ws_rf_wen(ws_rf_wen),
    .i_ws_rf_waddr(ws_rf_waddr),
    .i_ws_csrrf_wen(ws_csrrf_wen),
    .i_ws_csrrf_waddr(ws_csrrf_waddr),
    .o_rd(rd),
    .o_rs1data(rs1data), .o_rs2data(rs2data),
    .o_imm(imm),
    .o_bren(bren),
    .o_brfunc(brfunc),
    .o_ALUAsrc(ALUAsrc), .o_ALUBsrc(ALUBsrc), .o_ALUctr(ALUctr),
    .o_word_cut(word_cut),
    .o_RegWr(RegWr), .o_MemtoReg(MemtoReg), .o_MemWr(MemWr), .o_MemRe(MemRe), .o_MemOP(MemOP),
    .o_EXctr(EXctr),
    .o_is_invalid_inst(is_invalid_inst),
    .o_sel_csr(sel_csr), .o_sel_zimm(sel_zimm), .o_CsrWr(CsrWr),
    .o_zimm(zimm),
    .o_csrrdata(csrrdata),
    .o_sys_change_pc(sys_change_pc), .o_sysctr_pc(sysctr_pc)
  );

  wire [63:0] brtarget;
  ysyx_22050710_bru u_bru (
    .i_rs1data(rs1data), .i_rs2data(rs2data), .i_pc(pc), .i_imm(imm),
    .i_bren(bren),
    .i_brfunc(brfunc),
    .o_dnpc(brtarget)
  );

  wire [63:0] ALUresult, CSRresult;
  ysyx_22050710_exu u_exu (
    .i_rs1(rs1data), .i_rs2(rs2data),
    .i_imm(imm), .i_pc(pc),
    .i_ALUAsrc(ALUAsrc), .i_ALUBsrc(ALUBsrc), .i_ALUctr(ALUctr),
    .i_word_cut(word_cut),
    .i_EXctr(EXctr),
    .i_is_invalid_inst(is_invalid_inst),
    .i_sel_zimm(sel_zimm),
    .i_csrrdata(csrrdata), .i_zimm(zimm),
    .o_ALUresult(ALUresult),
    .o_CSRresult(CSRresult)
  );

  wire [63:0] lsu_addr = ALUresult; // x[rs1] + imm
  wire [63:0] ms_rf_wdata, ms_csrrf_wdata;
  ysyx_22050710_lsu u_lsu (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_addr(lsu_addr),
    .i_data(rs2data),
    .i_ALUresult(ALUresult),
    .i_CSRresult(CSRresult),
    .i_csrrdata(csrrdata),
    .i_MemOP(MemOP),
    .i_MemtoReg(MemtoReg),
    .i_WrEn(MemWr),
    .i_ReEn(MemRe),
    .i_sel_csr(sel_csr), 
    .o_w_rf_data(ms_rf_wdata),
    .o_w_csrrf_data(ms_csrrf_wdata)
  );

  wire [4:0] ws_rf_waddr;
  wire [11:0] ws_csrrf_waddr;
  ysyx_22050710_wbu u_wbu (
    .i_rf_wen(RegWr),
    .i_rf_waddr(rd),
    .i_rf_wdata(ms_rf_wdata),
    .o_rf_wen(ws_rf_wen),
    .o_rf_waddr(ws_rf_waddr),
    .o_rf_wdata(GPRbusW),

    .i_csrrf_wen(CsrWr),
    .i_csrrf_waddr(rd),
    .i_csrrf_wdata(ms_rf_wdata),
    .o_csrrf_wen(ws_rf_wen),
    .o_csrrf_waddr(ws_rf_waddr),
    .o_csrrf_wdata(GPRbusW)
  );

endmodule
