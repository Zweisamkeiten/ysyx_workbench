// ysyx_22050710 alu

module ysyx_22050710_alu #(
  parameter WORD_WD
) (
  input  [WORD_WD-1:0        ] i_src_a                       ,
  input  [WORD_WD-1:0        ] i_src_b                       ,
  input  [4:0                ] i_alu_op                      ,
  input                        i_alu_word_cut_sel            ,
  output [WORD_WD-1:0        ] o_alu_result
);

  wire                         signed_Less                   ;
  wire                         unsigned_Less                 ;
  assign signed_Less         = overflow == 0
                             ? (sub_result[WORD_WD-1] == 1 ? 1'b1 : 1'b0)
                             : (sub_result[WORD_WD-1] == 0 ? 1'b1 : 1'b0);
  assign unsigned_Less       = (1'b1 ^ cout) & ~(|i_src_b == 1'b0); // CF = cin ^ cout

  // adder
  wire [WORD_WD-1:0          ] adder_result                  ;
  wire                         cout                          ;
  wire                         overflow                      ;
  wire [WORD_WD-1:0          ] sub_result                    ;
  assign adder_result        = i_src_a + i_src_b             ;
  assign overflow            = ~(i_src_a[WORD_WD-1] ^ i_src_b[WORD_WD-1]) ^ ~(i_src_a[WORD_WD-2] ^ i_src_b[WORD_WD-2]);
  assign {cout, sub_result}  = {1'b0, i_src_a} + {1'b0, (({WORD_WD{1'b1}}^(i_src_b)) + 1)};

  // copy imm
  wire [WORD_WD-1:0          ] copy_result                   ;
  assign copy_result         = i_src_b                       ;

  // signed mul
  wire signed [WORD_WD-1:0   ] signed_mul_result             ;
  assign signed_mul_result   = $signed(i_src_a) * $signed(i_src_b);

  wire signed [WORD_WD-1:0   ] signed_mulh_result            ;
  assign signed_mulh_result  = {$signed({{WORD_WD{1'b0}}, i_src_a}) * $signed({{WORD_WD{1'b0}}, i_src_b}) >> WORD_WD}[WORD_WD-1:0];

  wire signed [WORD_WD-1:0   ] su_mulh_result                ;
  assign su_mulh_result      = {$signed({{WORD_WD{1'b0}}, i_src_a}) * {{WORD_WD{1'b0}}, i_src_b} >> WORD_WD}[WORD_WD-1:0];

  wire signed [WORD_WD-1:0   ] unsigned_mulh_result          ;
  assign unsigned_mulh_result= {{{WORD_WD{1'b0}}, i_src_a} * {{WORD_WD{1'b0}}, i_src_b} >> WORD_WD}[WORD_WD-1:0];

  // signed div
  wire signed [WORD_WD-1:0   ] signed_div_result             ;
  assign signed_div_result   = i_alu_word_cut_sel
                             ? ($signed({{32{i_src_a[31]}}, i_src_a[31:0]}) / $signed({{32{i_src_b[31]}}, i_src_b[31:0]}))
                             : $signed(i_src_a) / $signed(i_src_b);

  // unsigned div
  wire [WORD_WD-1:0          ] unsigned_div_result           ;
  assign unsigned_div_result = i_src_a / i_src_b             ;

  // signed rem
  wire signed [WORD_WD-1:0   ] signed_rem_result             ;
  assign signed_rem_result   = i_alu_word_cut_sel
                             ? ($signed({{32{i_src_a[31]}}, i_src_a[31:0]}) % $signed({{32{i_src_b[31]}}, i_src_b[31:0]}))
                             : $signed(i_src_a) % $signed(i_src_b);

  // unsigned rem
  wire [WORD_WD-1:0         ] unsigned_rem_result            ;
  assign unsigned_rem_result = i_src_a % i_src_b             ;

  // xor
  wire [WORD_WD-1:0          ] xor_result                    ;
  assign xor_result          = i_src_a ^ i_src_b             ;

  // and
  wire [WORD_WD-1:0          ] and_result                    ;
  assign and_result          = i_src_a & i_src_b             ;

  // or
  wire [WORD_WD-1:0          ] or_result                     ;
  assign or_result           = i_src_a | i_src_b             ;

  // sll
  wire [WORD_WD-1:0          ] sll_result                    ;
  assign sll_result          = i_src_a << (i_alu_word_cut_sel ? {1'b0, i_src_b[4:0]} : i_src_b[5:0]);

  // srl
  wire [WORD_WD-1:0          ] srl_result                    ;
  assign srl_result          = i_src_a >> (i_alu_word_cut_sel ? {1'b0, i_src_b[4:0]} : i_src_b[5:0]);

  // sra
  wire signed [WORD_WD-1:0        ] sra_result               ;
  assign sra_result               = i_alu_word_cut_sel
                                  ? $signed({{32{i_src_a[31]}}, $signed(i_src_a[31:0]) >>> $signed((i_alu_word_cut_sel ? {1'b0, i_src_b[4:0]} : i_src_b[5:0]))})
                                  : $signed(i_src_a) >>> $signed((i_alu_word_cut_sel ? {1'b0, i_src_b[4:0]} : i_src_b[5:0]));

  MuxKey #(.NR_KEY(19), .KEY_LEN(5), .DATA_LEN(WORD_WD)) u_mux2 (
    .out(aluresult),
    .key(i_alu_op),
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

  // if operand has been cut, the aluresult need signed extend to 64bits from
  // [32:0]
  wire [WORD_WD-1:0] aluresult;
  assign o_alu_result = i_alu_word_cut_sel ? {{32{aluresult[31]}}, aluresult[31:0]} : aluresult;

endmodule
