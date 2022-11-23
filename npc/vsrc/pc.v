module ysyx_22050710_pc (
  input i_clk,
  input i_rst,
  input [63:0] i_in,
  output [63:0] o_pc
);
  
  // 位宽为64bits, 复位值为64'h80000000, 写使能为i_load;
  Reg #(64, 64'h80000000) u_0 (i_clk, i_rst, i_in, o_pc, i_load);

endmodule
