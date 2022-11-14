// ysyx_22050710
module ysyx_22050710_npc (
  input i_clk,
  input i_rst,
  input [31:0] i_inst,
  output [63:0] o_pc
);
  ysyx_22050710_pc u_pc (i_clk, i_rst, .i_load(1'b1), .i_inc(1'b1), .i_in(64'b0), o_pc);

  wire [63:0] imm;
  wire [4:0] ra, rb, rd;
  wire wen, ALUAsrc;
  wire [1:0] ALUBsrc;
  wire [3:0] ALUctr;
  ysyx_22050710_idu u_idu (i_inst, imm, ra, rb, rd, wen, ALUAsrc, ALUBsrc, ALUctr);

  ysyx_22050710_exu u_exu (i_clk, ra, rb, rd, imm, wen, ALUAsrc, ALUBsrc, ALUctr);

endmodule
