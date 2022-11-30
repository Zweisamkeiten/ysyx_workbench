// ysyx_22050710 Execute Unit

import "DPI-C" function void set_state_end();
import "DPI-C" function void set_state_abort();

module ysyx_22050710_exu (
  input   [63:0] i_rs1, i_rs2,
  input   [63:0] i_imm, i_pc,
  input   i_ALUAsrc, input [1:0] i_ALUBsrc, input [3:0] i_ALUctr,
  input   i_word_cut,
  input   [2:0] i_Branch,
  input   [2:0] i_MemOP, input i_MemtoReg,
  input   [63:0] i_rdata,
  output  [63:0] o_ALUresult,
  output  [63:0] o_nextpc,
  output  [63:0] o_busW
);

  wire PCAsrc, PCBsrc;
  assign o_nextpc = (PCBsrc ? i_rs1 : i_pc) + (PCAsrc ? i_imm : 64'd4);
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

  // word_cut: cut operand to 32bits and unsigned extend OR dont cut
  wire [63:0] src1 = i_word_cut ? {{32{1'b0}}, i_rs1[31:0]} : i_rs1;
  wire [63:0] src2 = i_word_cut ? {{32{1'b0}}, i_rs2[31:0]} : i_rs2;
  wire [63:0] imm  = i_word_cut ? {{32{1'b0}}, i_imm[31:0]} : i_imm;

  // if operand has been cut, the aluresult need signed extend to 64bits from
  // [32:0]
  wire [63:0] aluresult;
  assign o_ALUresult = i_word_cut ? {{32{aluresult[31]}}, aluresult[31:0]} : aluresult;

  // ALU
  wire [63:0] src_a, src_b;
  assign src_a = i_ALUAsrc ? i_pc : src1;
  MuxKey #(.NR_KEY(3), .KEY_LEN(2), .DATA_LEN(64)) u_mux2 (
    .out(src_b),
    .key(i_ALUBsrc),
    .lut({
      2'b00, src2,
      2'b01, imm,
      2'b10, 64'd4
    })
  );
  // adder
  wire[63:0] adder_result = src_a + src_b;
  wire[63:0] sub_result   = src_a + (({64{1'b1}}^(src_b)) + 1);

  // copy imm
  wire [63:0] copy_result = i_imm;

  // signed mul
  wire signed [63:0] signed_mul_result = $signed(src_a) * $signed(src_b);

  // signed mul
  wire signed [63:0] signed_div_result = $signed(src_a) / $signed(src_b);

  // signed rem
  wire signed [63:0] signed_rem_result = $signed(src_a) % $signed(src_b);

  // or
  wire [63:0] or_result = src_a | src_b;

  // sll
  wire [63:0] sll_result = src_a << src_b;

  MuxKey #(.NR_KEY(9), .KEY_LEN(4), .DATA_LEN(64)) u_mux3 (
    .out(aluresult),
    .key(i_ALUctr),
    .lut({
      4'b0011, copy_result,
      4'b0000, adder_result,
      4'b1010, sub_result[63] == 1 ? 64'b1 : 64'b0, // sltu
      4'b1000, sub_result,
      4'b0110, or_result,
      4'b0001, sll_result,
      4'b1100, signed_mul_result,
      4'b1011, signed_div_result,
      4'b1101, signed_rem_result
    })
  );

  wire [63:0] rdata;
  assign o_busW = i_MemtoReg ? rdata : o_ALUresult;
  MuxKey #(.NR_KEY(7), .KEY_LEN(3), .DATA_LEN(64)) u_mux4 (
    .out(rdata),
    .key(i_MemOP),
    .lut({
      3'b000, {{56{i_rdata[7]}}, i_rdata[7:0]},
      3'b001, {{56{1'b0}}, i_rdata[7:0]},
      3'b010, {{48{i_rdata[15]}}, i_rdata[15:0]},
      3'b011, {{48{1'b0}}, i_rdata[15:0]},
      3'b100, {{32{i_rdata[31]}}, i_rdata[31:0]},
      3'b101, {{32{i_rdata[31]}}, i_rdata[31:0]},
      3'b110, i_rdata
    })
  );

  always @(i_ALUctr) begin
    if (i_ALUctr == 4'b1111) set_state_abort(); // invalid inst
    if (i_ALUctr == 4'b1110) set_state_end(); // ebreak
  end
endmodule
