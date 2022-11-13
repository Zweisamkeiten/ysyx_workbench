// ysyx_22050710
module ysyx_22050710_npc (
  input i_clk,
  input i_rst,
  input [31:0] i_inst,
  output [63:0] o_pc
);
  ysyx_22050710_pc u_pc (i_clk, i_rst, .i_load(1'b1), .i_inc(1'b1), .i_in(64'b0), o_pc);
  ysyx_22050710_gpr #(.ADDR_WIDTH(5), .DATA_WIDTH(64)) u_gprs (i_clk, rs1, rs2, rd, wdata, wen, busA, busB);

  wire [63:0] busA, busB;
  wire [11:0] imm;
  wire [4:0] rs1, rs2, rd;
  wire [2:0] funct3;
  wire [6:0] opcode;

  assign imm = i_inst[31:20];
  assign rs1 = i_inst[19:15];
  assign rs2 = i_inst[24:20];
  assign funct3 = i_inst[14:12];
  assign rd = i_inst[11:7];
  assign opcode = i_inst[6:0];

  // decode && to exec addi
  wire [63:0] sextimm;
  wire wen;
  assign sextimm[63:12] = {52{imm[11]}};
  assign sextimm[11:0] = imm[11:0];
  assign wen = |rd != 0 ? 1'b1 : 1'b0;
  ysyx_22050710_adder #(64) u_add64 (busA, sextimm, wdata);
endmodule
