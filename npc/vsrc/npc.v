// ysyx_22050710

module ysyx_22050710_npc (
  input i_clk,
  input i_rst,
  input [31:0] i_inst,
  output [63:0] o_pc
);
  wire [63:0] pc_adder = (PCBsrc ? rs1 : o_pc) + (PCAsrc ? imm : 64'd4);
  ysyx_22050710_pc u_pc (i_clk, i_rst, .i_load(1'b1), .i_in(pc_adder), o_pc);

  wire [63:0] rs1, rs2, ALUresult;
  ysyx_22050710_gpr #(.ADDR_WIDTH(5), .DATA_WIDTH(64)) u_gprs (i_clk, ra, rb, rd, ALUresult, wen, rs1, rs2);

  wire [63:0] imm;
  wire [4:0] ra, rb, rd;
  wire wen, ALUAsrc;
  wire [1:0] ALUBsrc;
  wire [3:0] ALUctr;
  wire PCAsrc, PCBsrc;
  ysyx_22050710_idu u_idu (i_inst, imm, ra, rb, rd, wen, ALUAsrc, ALUBsrc, ALUctr, PCAsrc, PCBsrc);

  ysyx_22050710_exu u_exu (rs1, rs2, imm, o_pc, ALUAsrc, ALUBsrc, ALUctr, ALUresult);

endmodule
