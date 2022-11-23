// ysyx_22050710
import "DPI-C" function void set_state_end();
import "DPI-C" function void set_state_abort();
module ysyx_22050710_exu (
  input i_clk,
  input [4:0] i_ra, i_rb, i_rd,
  input [63:0] i_imm,
  input i_wen, i_ALUAsrc,
  input [1:0] i_ALUBsrc,
  input [3:0] i_ALUctr
);

  wire [63:0] rs1, rs2;
  wire [63:0] result;
  ysyx_22050710_gpr #(.ADDR_WIDTH(5), .DATA_WIDTH(64)) u_gprs (i_clk, i_ra, i_rb, i_rd, result, i_wen, rs1, rs2);

  wire [63:0] pc_adder = o_pc + i_imm;
  ysyx_22050710_pc u_pc (i_clk, i_rst, .i_load(1'b1), .i_inc(!i_ALUAsrc), .i_in(pc_adder), o_pc);

  // aader
  wire [63:0] adder_result, add_a, add_b;
  assign add_a = i_ALUAsrc ? o_pc : rs1;
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

  always @(i_ALUctr) begin
    if (i_ALUctr == 4'b1111) set_state_abort(); // invalid inst
    if (i_ALUctr == 4'b1110) set_state_end(); // ebreak
  end
endmodule
