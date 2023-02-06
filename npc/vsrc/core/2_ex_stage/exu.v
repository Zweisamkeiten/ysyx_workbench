// ysyx_22050710 Execute Unit

import "DPI-C" function void set_state_end();
import "DPI-C" function void set_state_abort();

module ysyx_22050710_exu (
  input   [63:0] i_rs1, i_rs2,
  input   [63:0] i_imm, i_pc,
  input   i_ALUAsrc, input [1:0] i_ALUBsrc, input [4:0] i_ALUctr,
  input   i_word_cut,
  input   [3:0] i_EXctr,
  input   i_is_invalid_inst,
  input   i_sel_zimm,
  input   [63:0] i_csrrdata, i_zimm,
  output  [63:0] o_ALUresult,
  output  [63:0] o_CSRresult
);

  // word_cut: cut operand to 32bits and unsigned extend OR dont cut
  wire [63:0] src1 = i_word_cut ? {{32{1'b0}}, i_rs1[31:0]} : i_rs1;
  wire [63:0] src2 = i_word_cut ? {{32{1'b0}}, i_rs2[31:0]} : i_rs2;
  wire [63:0] imm  = i_word_cut ? {{32{1'b0}}, i_imm[31:0]} : i_imm;

  // ALU
  wire [63:0] src_a, src_b;
  assign src_a = i_ALUAsrc ? i_pc : src1;
  MuxKey #(.NR_KEY(3), .KEY_LEN(2), .DATA_LEN(64)) u_mux0 (
    .out(src_b),
    .key(i_ALUBsrc),
    .lut({
      2'b00, src2,
      2'b01, imm,
      2'b10, 64'd4
    })
  );

  ysyx_22050710_alu u_alu (
    .i_src_a(src_a), .i_src_b(src_b),
    .i_ALUctr(i_ALUctr),
    .i_word_cut(i_word_cut),
    .o_ALUresult(o_ALUresult)
  );

  wire [63:0] csr_oprand = i_sel_zimm ? i_zimm : i_rs1;
  MuxKeyWithDefault #(.NR_KEY(2), .KEY_LEN(4), .DATA_LEN(64)) u_mux2 (
    .out(o_CSRresult),
    .key(i_EXctr),
    .default_out(64'b0),
    .lut({
      4'b0000, csr_oprand, // csrrw, csrrwi
      4'b0001, i_csrrdata | csr_oprand // csrrs
    })
  );

  always @(*) begin
    if (i_EXctr == 4'b1110) begin
      set_state_end(); // ebreak
    end
  end

  always @(i_is_invalid_inst) begin // 敏感变量只有 i_is_invalid_inst, reset(10) 因此只处理一次
    if (i_is_invalid_inst) set_state_abort(); // invalid inst
  end

endmodule
