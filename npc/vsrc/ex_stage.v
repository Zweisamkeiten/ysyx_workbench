// ysyx_22050710
import "DPI-C" function void set_state_end();
import "DPI-C" function void set_state_abort();
module ysyx_22050710_exu (
  input [63:0] i_rs1, i_rs2,
  input [63:0] i_imm, i_pc,
  input i_ALUAsrc,
  input [1:0] i_ALUBsrc,
  input [3:0] i_ALUctr,
  output [63:0] o_ALUresult
);

  // aader
  wire [63:0] adder_result, add_a, add_b;
  assign add_a = i_ALUAsrc ? i_pc : i_rs1;
  MuxKey #(.NR_KEY(3), .KEY_LEN(2), .DATA_LEN(64)) u_mux0 (
    .out(add_b),
    .key(i_ALUBsrc),
    .lut({
      2'b00, i_rs2,
      2'b01, i_imm,
      2'b10, 64'd4
    })
  );
  assign adder_result = add_a + add_b;

  // copy imm
  wire [63:0] copy_result;
  assign copy_result = i_imm;

  MuxKey #(.NR_KEY(2), .KEY_LEN(4), .DATA_LEN(64)) u_mux1 (
    .out(o_ALUresult),
    .key(i_ALUctr),
    .lut({
      4'b0011, copy_result,
      4'b0000, adder_result
    })
  );

  always @(i_ALUctr) begin
    if (i_ALUctr == 4'b1111) set_state_abort(); // invalid inst
    if (i_ALUctr == 4'b1110) set_state_end(); // ebreak
  end
endmodule
