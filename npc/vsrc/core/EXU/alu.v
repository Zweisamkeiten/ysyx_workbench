// ysyx_22050710 alu

module ysyx_22050710_alu (
  input  [63:0] i_src_a, i_src_b,
  input  [4:0] i_ALUctr,
  input  i_word_cut,
  output [63:0] o_ALUresult
);

  wire signed_Less = overflow == 0
                   ? (sub_result[63] == 1 ? 1'b1 : 1'b0)
                   : (sub_result[63] == 0 ? 1'b1 : 1'b0);
  wire unsigned_Less = (1'b1 ^ cout) & ~(|i_src_b == 1'b0); // CF = cin ^ cout

  // if operand has been cut, the aluresult need signed extend to 64bits from
  // [32:0]
  wire [63:0] aluresult;
  assign o_ALUresult = i_word_cut ? {{32{aluresult[31]}}, aluresult[31:0]} : aluresult;

  // adder
  wire[63:0] adder_result = i_src_a + i_src_b;
  wire [63:0] sub_result; wire cout;
  wire overflow = ~(i_src_a[63] ^ i_src_b[63]) ^ ~(i_src_a[62] ^ i_src_b[62]);
  assign {cout, sub_result}   = {1'b0, i_src_a} + {1'b0, (({64{1'b1}}^(i_src_b)) + 1)};

  // copy imm
  wire [63:0] copy_result = i_src_b;

  // signed mul
  wire signed [63:0] signed_mul_result = $signed(i_src_a) * $signed(i_src_b);

  wire signed [63:0] signed_mulh_result = {$signed({{64{1'b0}}, i_src_a}) * $signed({{64{1'b0}}, i_src_b}) >> 64}[63:0];

  wire signed [63:0] su_mulh_result = {$signed({{64{1'b0}}, i_src_a}) * {{64{1'b0}}, i_src_b} >> 64}[63:0];

  wire signed [63:0] unsigned_mulh_result = {{{64{1'b0}}, i_src_a} * {{64{1'b0}}, i_src_b} >> 64}[63:0];

  // signed div
  wire signed [63:0] signed_div_result = i_word_cut
                                         ? ($signed({{32{i_src_a[31]}}, i_src_a[31:0]}) / $signed({{32{i_src_b[31]}}, i_src_b[31:0]}))
                                         : $signed(i_src_a) / $signed(i_src_b);

  // unsigned div
  wire [63:0] unsigned_div_result = i_src_a / i_src_b;

  // signed rem
  wire signed [63:0] signed_rem_result = i_word_cut
                                         ? ($signed({{32{i_src_a[31]}}, i_src_a[31:0]}) % $signed({{32{i_src_b[31]}}, i_src_b[31:0]}))
                                         : $signed(i_src_a) % $signed(i_src_b);

  // unsigned rem
  wire [63:0] unsigned_rem_result = i_src_a % i_src_b;

  // xor
  wire [63:0] xor_result = i_src_a ^ i_src_b;

  // and
  wire [63:0] and_result = i_src_a & i_src_b;

  // or
  wire [63:0] or_result = i_src_a | i_src_b;

  // sll
  wire [63:0] sll_result = i_src_a << (i_word_cut ? {1'b0, i_src_b[4:0]} : i_src_b[5:0]);

  // srl
  wire [63:0] srl_result = i_src_a >> (i_word_cut ? {1'b0, i_src_b[4:0]} : i_src_b[5:0]);

  // sra
  wire signed [63:0] sra_result = i_word_cut
                                  ? $signed({{32{i_src_a[31]}}, $signed(i_src_a[31:0]) >>> $signed((i_word_cut ? {1'b0, i_src_b[4:0]} : i_src_b[5:0]))})
                                  : $signed(i_src_a) >>> $signed((i_word_cut ? {1'b0, i_src_b[4:0]} : i_src_b[5:0]));

  MuxKey #(.NR_KEY(19), .KEY_LEN(5), .DATA_LEN(64)) u_mux2 (
    .out(aluresult),
    .key(i_ALUctr),
    .lut({
      5'b01111, copy_result,
      5'b00000, adder_result,
      5'b00001, sub_result,
      5'b00010, signed_Less == 1 ? 64'b1 : 64'b0, // slt
      5'b00011, unsigned_Less == 1 ? 64'b1 : 64'b0, // sltu
      5'b00100, xor_result,
      5'b00101, and_result,
      5'b00110, or_result,
      5'b00111, sll_result,
      5'b01000, srl_result,
      5'b01001, sra_result,
      5'b01010, signed_mul_result,
      5'b11001, signed_mulh_result,
      5'b11010, su_mulh_result,
      5'b11011, unsigned_mulh_result,
      5'b01011, signed_div_result,
      5'b01100, unsigned_div_result,
      5'b01101, signed_rem_result,
      5'b01110, unsigned_rem_result
    })
  );

endmodule
