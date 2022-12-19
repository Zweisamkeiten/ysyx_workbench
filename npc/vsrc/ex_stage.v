// ysyx_22050710 Execute Unit

import "DPI-C" function void set_state_end();
import "DPI-C" function void set_state_abort();

module ysyx_22050710_exu (
  input   [63:0] i_rs1, i_rs2,
  input   [63:0] i_imm, i_pc,
  input   i_ALUAsrc, input [1:0] i_ALUBsrc, input [4:0] i_ALUctr,
  input   i_word_cut,
  input   [2:0] i_Branch,
  input   [2:0] i_MemOP, input i_MemtoReg,
  input   [63:0] i_rdata,
  input   [3:0] i_EXctr,
  input   i_is_invalid_inst,
  input   i_sel_csr,
  output  [63:0] o_ALUresult,
  output  [63:0] o_nextpc,
  output  [63:0] o_GPRbusW,
  output  [63:0] o_CSRbusW
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

  wire Zero = ~(|sub_result);
  wire Less;
  MuxKey #(.NR_KEY(2), .KEY_LEN(5), .DATA_LEN(1)) u_mux2 (
    .out(Less),
    .key(i_ALUctr),
    .lut({
      5'b00010, signed_Less,
      5'b00011, unsigned_Less
    })
  );
  wire signed_Less = overflow == 0
                   ? (sub_result[63] == 1 ? 1'b1 : 1'b0)
                   : (sub_result[63] == 0 ? 1'b1 : 1'b0);
  wire unsigned_Less = (1'b1 ^ cout) & ~(|src_b == 1'b0); // CF = cin ^ cout

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
  MuxKey #(.NR_KEY(3), .KEY_LEN(2), .DATA_LEN(64)) u_mux3 (
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
  wire [63:0] sub_result; wire cout;
  wire overflow = ~(src_a[63] ^ src_b[63]) ^ ~(src_a[62] ^ src_b[62]);
  assign {cout, sub_result}   = {1'b0, src_a} + {1'b0, (({64{1'b1}}^(src_b)) + 1)};

  // copy imm
  wire [63:0] copy_result = i_imm;

  // signed mul
  wire signed [63:0] signed_mul_result = $signed(src_a) * $signed(src_b);

  // signed div
  wire signed [63:0] signed_div_result = $signed(src_a) / $signed(src_b);

  // unsigned div
  wire [63:0] unsigned_div_result = src_a / src_b;

  // signed rem
  wire signed [63:0] signed_rem_result = $signed(src_a) % $signed(src_b);

  // unsigned rem
  wire [63:0] unsigned_rem_result = src_a % src_b;

  // xor
  wire [63:0] xor_result = src_a ^ src_b;

  // and
  wire [63:0] and_result = src_a & src_b;

  // or
  wire [63:0] or_result = src_a | src_b;

  // sll
  wire [63:0] sll_result = src_a << (i_word_cut ? {1'b0, src_b[4:0]} : src_b[5:0]);

  // srl
  wire [63:0] srl_result = src_a >> (i_word_cut ? {1'b0, src_b[4:0]} : src_b[5:0]);

  // sra
  wire signed [63:0] sra_result = i_word_cut
                                  ? $signed({{32{src_a[31]}}, $signed(src_a[31:0]) >>> $signed((i_word_cut ? {1'b0, src_b[4:0]} : src_b[5:0]))})
                                  : $signed(src_a) >>> $signed((i_word_cut ? {1'b0, src_b[4:0]} : src_b[5:0]));

  MuxKey #(.NR_KEY(16), .KEY_LEN(5), .DATA_LEN(64)) u_mux4 (
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
      5'b01011, signed_div_result,
      5'b01100, unsigned_div_result,
      5'b01101, signed_rem_result,
      5'b01110, unsigned_rem_result
    })
  );

  wire [63:0] rdata;
  assign o_GPRbusW = i_MemtoReg ? rdata : (i_sel_csr ? i_rs2 : o_ALUresult);
  MuxKey #(.NR_KEY(7), .KEY_LEN(3), .DATA_LEN(64)) u_mux5 (
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

  reg [63:0] CSRbusW;
  assign o_CSRbusW = CSRbusW;
  always @(i_EXctr) begin
    case (i_EXctr)
      4'b1110: set_state_end(); // ebreak
      4'b0000: CSRbusW = src_a;
      default:;
    endcase
  end

  always @(i_is_invalid_inst) begin
      if (i_is_invalid_inst) set_state_abort(); // invalid inst
  end
endmodule
