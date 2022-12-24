// ysyx_22050710 NPC CORE TOP

module ysyx_22050710_npc (
  input i_clk,
  input i_rst
);

  wire [63:0] nextpc;
  ysyx_22050710_pc u_pc (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_load(1'b1),
    .i_in(nextpc),
    .o_pc(pc)
  );

  wire [63:0] rs1, rs2, ALUresult;
  wire [63:0] busW;
  ysyx_22050710_gpr #(.ADDR_WIDTH(5), .DATA_WIDTH(64)) u_gprs (
    .i_clk(i_clk),
    .i_ra(ra), .i_rb(rb), .i_waddr(rd),
    .i_wdata(busW), .i_wen(RegWr),
    .o_busA(rs1), .o_busB(rs2)
  );

  wire [63:0] rdata;
  ysyx_22050710_datamem u_datamem (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_addr(ALUresult),
    .i_data(rs2),
    .i_MemOP(MemOP),
    .i_WrEn(MemWr),
    .o_data(rdata)
  );

  wire [31:0] inst; wire [63:0] pc; wire [31:0] unused;
  ysyx_22050710_ifu u_ifu (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_pc(pc),
    .o_inst(inst),
    .o_unused(unused)
  );

  wire [63:0] imm;
  wire [4:0] ra, rb, rd;
  wire [2:0] Branch;
  wire ALUAsrc; wire [1:0] ALUBsrc; wire [4:0] ALUctr;
  wire word_cut;
  wire RegWr, MemtoReg, MemWr; wire [2:0] MemOP;
  ysyx_22050710_idu u_idu (
    .i_inst(inst),
    .o_imm(imm),
    .o_ra(ra), .o_rb(rb), .o_rd(rd),
    .o_Branch(Branch),
    .o_ALUAsrc(ALUAsrc), .o_ALUBsrc(ALUBsrc), .o_ALUctr(ALUctr),
    .o_word_cut(word_cut),
    .o_RegWr(RegWr), .o_MemtoReg(MemtoReg), .o_MemWr(MemWr), .o_MemOP(MemOP)
  );

  ysyx_22050710_exu u_exu (
    .i_rs1(rs1), .i_rs2(rs2),
    .i_imm(imm), .i_pc(pc),
    .i_ALUAsrc(ALUAsrc), .i_ALUBsrc(ALUBsrc), .i_ALUctr(ALUctr),
    .i_word_cut(word_cut),
    .i_Branch(Branch),
    .i_MemOP(MemOP), .i_MemtoReg(MemtoReg), .i_rdata(rdata),
    .o_ALUresult(ALUresult),
    .o_nextpc(nextpc),
    .o_busW(busW)
  );

endmodule
