// ysyx_22050710 NPC CORE

module ysyx_22050710_core (
  input i_clk,
  input i_rst
);

  // i_rst 低电平同步复位
  reg reset;
  always @(posedge i_clk) reset <= ~i_rst;

  always @* $display("%x", nextpc);
  wire [63:0] nextpc;
  ysyx_22050710_pc u_pc (
    .i_clk(i_clk),
    .i_rst(reset),
    .i_load(1'b1),
    .i_in(nextpc),
    .o_pc(pc)
  );

  wire [63:0] rs1, rs2;
  wire [63:0] GPRbusW;
  ysyx_22050710_gpr #(.ADDR_WIDTH(5), .DATA_WIDTH(64)) u_gprs (
    .i_clk(i_clk),
    .i_ra(ra), .i_rb(rb), .i_waddr(rd),
    .i_wdata(GPRbusW), .i_wen(RegWr),
    .o_busA(rs1), .o_busB(rs2)
  );

  wire [63:0] csrrdata;
  wire [63:0] CSRbusW;
  wire [63:0] sysctr_pc; wire sys_change_pc;
  ysyx_22050710_csr #(.ADDR_WIDTH(12), .DATA_WIDTH(64)) u_csrs (
    .i_clk(i_clk),
    .i_raddr(imm[11:0]), .i_waddr(imm[11:0]), .i_wdata(CSRbusW),
    .i_epc(pc),
    .i_ren(CsrRe), .i_wen(CsrWr),
    .i_raise_intr(raise_intr), .i_intr_ret(intr_ret),
    .o_bus(csrrdata),
    .o_nextpc(sysctr_pc), .o_sys_change_pc(sys_change_pc)
  );

  wire [31:0] inst; wire [63:0] pc;
  ysyx_22050710_ifu u_ifu (
    .i_clk(i_clk),
    .i_rst(reset),
    .i_pc(pc),
    .o_inst(inst)
  );

  wire [63:0] imm, zimm;
  wire [4:0] ra, rb, rd;
  wire [2:0] Branch;
  wire ALUAsrc; wire [1:0] ALUBsrc; wire [4:0] ALUctr;
  wire word_cut;
  wire RegWr, MemtoReg, MemWr, MemRe; wire [2:0] MemOP;
  wire [3:0] EXctr;
  wire is_invalid_inst;
  wire sel_csr, sel_zimm, CsrWr, CsrRe;
  wire raise_intr, intr_ret;
  ysyx_22050710_idu u_idu (
    .i_inst(inst),
    .o_imm(imm),
    .o_ra(ra), .o_rb(rb), .o_rd(rd),
    .o_Branch(Branch),
    .o_ALUAsrc(ALUAsrc), .o_ALUBsrc(ALUBsrc), .o_ALUctr(ALUctr),
    .o_word_cut(word_cut),
    .o_RegWr(RegWr), .o_MemtoReg(MemtoReg), .o_MemWr(MemWr), .o_MemRe(MemRe), .o_MemOP(MemOP),
    .o_EXctr(EXctr),
    .o_is_invalid_inst(is_invalid_inst),
    .o_sel_csr(sel_csr), .o_sel_zimm(sel_zimm), .o_CsrWr(CsrWr), .o_CsrRe(CsrRe),
    .o_zimm(zimm),
    .o_raise_intr(raise_intr), .o_intr_ret(intr_ret)
  );

  wire [63:0] ALUresult;
  ysyx_22050710_exu u_exu (
    .i_rs1(rs1), .i_rs2(rs2),
    .i_imm(imm), .i_pc(pc),
    .i_ALUAsrc(ALUAsrc), .i_ALUBsrc(ALUBsrc), .i_ALUctr(ALUctr),
    .i_word_cut(word_cut),
    .i_Branch(Branch),
    .i_MemOP(MemOP), .i_MemtoReg(MemtoReg), .i_rdata(rdata),
    .i_EXctr(EXctr),
    .i_is_invalid_inst(is_invalid_inst),
    .i_sel_csr(sel_csr), .i_sel_zimm(sel_zimm), .i_sys_change_pc(sys_change_pc), .i_sysctr_pc(sysctr_pc),
    .i_csrrdata(csrrdata), .i_zimm(zimm),
    .o_ALUresult(ALUresult),
    .o_nextpc(nextpc),
    .o_GPRbusW(GPRbusW),
    .o_CSRbusW(CSRbusW)
  );

  wire [63:0] rdata;
  wire [63:0] lsu_addr = ALUresult; // x[rs1] + imm
  ysyx_22050710_lsu u_lsu (
    .i_clk(i_clk),
    .i_rst(reset),
    .i_addr(lsu_addr),
    .i_data(rs2),
    .i_MemOP(MemOP),
    .i_WrEn(MemWr),
    .i_ReEn(MemRe),
    .o_data(rdata)
  );

endmodule
