// ysyx_22050710
import "DPI-C" function void set_state_end();
import "DPI-C" function void set_state_abort();
module ysyx_22050710_exu (
  input [63:0] i_rs1, i_rs2,
  input [63:0] i_imm, i_pc,
  input i_ALUAsrc,
  input [1:0] i_ALUBsrc,
  input [3:0] i_ALUctr,
  input [2:0] i_Branch,
  output [63:0] o_ALUresult,
  output [63:0] o_nextpc
);

  assign o_nextpc = (PCBsrc ? i_rs1 : i_pc) + (PCAsrc ? i_imm : 64'd4);
  wire PCAsrc, PCBsrc;
  MuxKey #(.NR_KEY(7), .KEY_LEN(3), .DATA_LEN(1)) u_mux0 (
    .out(PCAsrc),
    .key(i_Branch),
    .lut({
      3'b000, 1'b0,
      3'b001, 1'b1,
      3'b010, 1'b1,
      3'b100, Zero == 1 ? 1'b1 : 1'b0,
      3'b101, Zero == 1 ? 1'b0 : 1'b1,
      3'b110, Less == 1 ? 1'b1 : 1'b0,
      3'b111, Less == 1 ? 1'b0 : 1'b1
    })
  );
  MuxKey #(.NR_KEY(7), .KEY_LEN(3), .DATA_LEN(1)) u_mux1 (
    .out(PCBsrc),
    .key(i_Branch),
    .lut({
      3'b000, 1'b0,
      3'b001, 1'b0,
      3'b010, 1'b1,
      3'b100, 1'b0,
      3'b101, 1'b0,
      3'b110, 1'b0,
      3'b111, 1'b0
    })
  );

  wire Zero = ~(|o_ALUresult);
  wire Less = o_ALUresult[63] == 1 ? 1'b1 : 1'b0;

  // adder
  wire [63:0] adder_result, sub_result, add_a, add_b;
  assign add_a = i_ALUAsrc ? i_pc : i_rs1;
  MuxKey #(.NR_KEY(3), .KEY_LEN(2), .DATA_LEN(64)) u_mux2 (
    .out(add_b),
    .key(i_ALUBsrc),
    .lut({
      2'b00, i_rs2,
      2'b01, i_imm,
      2'b10, 64'd4
    })
  );
  assign adder_result = add_a + add_b;
  assign sub_result = add_a + (({64{1'b1}}^(add_b)) + 1);

  // copy imm
  wire [63:0] copy_result;
  assign copy_result = i_imm;

  // adder result cut 32bits and_ext
  wire [63:0] adder_result_cut32_and_ext;
  assign adder_result_cut32_and_ext = {{32{adder_result[31]}}, adder_result[31:0]};

  MuxKey #(.NR_KEY(5), .KEY_LEN(4), .DATA_LEN(64)) u_mux3 (
    .out(o_ALUresult),
    .key(i_ALUctr),
    .lut({
      4'b0011, copy_result,
      4'b0000, adder_result,
      4'b1001, adder_result_cut32_and_ext,
      4'b1010, sub_result[63] == 1 ? 64'b1 : 64'b0,
      4'b1000, sub_result
    })
  );

  always @(i_ALUctr) begin
    if (i_ALUctr == 4'b1111) set_state_abort(); // invalid inst
    if (i_ALUctr == 4'b1110) set_state_end(); // ebreak
  end
endmodule
