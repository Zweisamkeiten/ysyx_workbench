// ysyx_22050710
/* import "DPI-C" function void set_state_end(); */
module ysyx_22050710_exu (
  input i_clk,
  input [4:0] i_ra, i_rb, i_rd,
  input [63:0] i_imm, i_pc,
  input i_wen, i_ALUAsrc,
  input [1:0] i_ALUBsrc,
  input [3:0] i_ALUctr
);

  wire [63:0] rs1, rs2;
  wire [63:0] result;
  ysyx_22050710_gpr #(.ADDR_WIDTH(5), .DATA_WIDTH(64)) u_gprs (i_clk, i_ra, i_rb, i_rd, result, i_wen, rs1, rs2);
  // aader
  wire [63:0] adder_result, add_a, add_b;
  assign add_a = i_ALUAsrc ? i_pc : rs1;
  MuxKey #(.NR_KEY(3), .KEY_LEN(2), .DATA_LEN(64)) u_mux0 (
    .out(add_b),
    .key(i_ALUBsrc),
    .lut({
      2'b00, rs2,
      2'b01, i_imm,
      2'b10, 64'd4
    })
  );
  assign adder_result = add_a + add_b;

  MuxKey #(.NR_KEY(1), .KEY_LEN(4), .DATA_LEN(64)) u_mux1 (
    .out(result),
    .key(i_ALUctr),
    .lut({
      4'b0000, adder_result
    })
  );

  /* always @(i_ALUctr) begin */
  /*   if (i_ALUctr == 4'b1111) set_state_end(); */
  /* end */
endmodule
