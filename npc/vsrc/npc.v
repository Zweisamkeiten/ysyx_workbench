// ysyx_22050710
import "DPI-C" function void set_inst_ptr(input logic [31:0] a[]);

module ysyx_22050710_npc (
  input i_clk,
  input i_rst
);
  wire [31:0] inst;
  wire [63:0] pc;
  ysyx_22050710_ifu u_ifu (
    .i_pc(pc),
    .o_inst(inst)
  );

  initial set_inst_ptr(inst);
  wire [63:0] pc_adder = (PCBsrc ? rs1 : pc) + (PCAsrc ? imm : 64'd4);
  ysyx_22050710_pc u_pc (i_clk, i_rst, .i_load(1'b1), .i_in(pc_adder), pc);

  wire [63:0] rs1, rs2, ALUresult;
  ysyx_22050710_gpr #(.ADDR_WIDTH(5), .DATA_WIDTH(64)) u_gprs (
    .i_clk(i_clk),
    .i_ra(ra), .i_rb(rb), .i_waddr(rd),
    .i_wdata(ALUresult), .i_wen(RegWr),
    .o_busA(rs1), .o_busB(rs2)
  );

  wire [63:0] imm;
  wire [4:0] ra, rb, rd;
  wire RegWr, ALUAsrc;
  wire [1:0] ALUBsrc;
  wire [3:0] ALUctr;
  wire PCAsrc, PCBsrc;
  wire MemtoReg, MemWr;
  wire [2:0] MemOP;
  ysyx_22050710_idu u_idu (
    .i_inst(inst),
    .o_imm(imm),
    .o_ra(ra), .o_rb(rb), .o_rd(rd),
    .o_RegWr(RegWr),
    .o_ALUAsrc(ALUAsrc), .o_ALUBsrc(ALUBsrc), .o_ALUctr(ALUctr),
    .o_PCAsrc(PCAsrc), .o_PCBsrc(PCBsrc),
    .o_MemToReg(MemtoReg), .o_MemWr(MemWr), .o_MemOP(MemOP)
  );

  ysyx_22050710_exu u_exu (
    .i_rs1(rs1), .i_rs2(rs2),
    .i_imm(imm), .i_pc(pc),
    .i_ALUAsrc(ALUAsrc), .i_ALUBsrc(ALUBsrc), .i_ALUctr(ALUctr), .o_ALUresult(ALUresult)
  );

endmodule
