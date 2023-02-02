// ysyx_22050710 Execute Unit

import "DPI-C" function void set_state_end();
import "DPI-C" function void set_state_abort();

module ysyx_22050710_exu (
  input   [63:0] i_rs1, i_rs2,
  input   [63:0] i_imm, i_pc, i_sysctr_pc,
  input   i_ALUAsrc, input [1:0] i_ALUBsrc, input [4:0] i_ALUctr,
  input   i_word_cut,
  input   [2:0] i_Branch,
  input   [2:0] i_MemOP, input i_MemtoReg,
  input   [63:0] i_rdata,
  input   [3:0] i_EXctr,
  input   i_is_invalid_inst,
  input   i_sel_csr, i_sys_change_pc,
  input   [63:0] i_csrrdata, i_zimm,
  output  [63:0] o_ALUresult,
  output  [63:0] o_nextpc,
  output  [63:0] o_GPRbusW,
  output  [63:0] o_CSRbusW
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

  wire Zero, Less;
  ysyx_22050710_alu u_alu (
    .i_src_a(src_a), .i_src_b(src_b),
    .i_ALUctr(i_ALUctr),
    .i_word_cut(i_word_cut),
    .o_zero(Zero), .o_less(Less),
    .o_ALUresult(o_ALUresult)
  );

  wire [63:0] nextpc;
  assign o_nextpc = i_sys_change_pc ? i_sysctr_pc : nextpc;
  ysyx_22050710_pc_jumper u_pc_jumper (
    .i_rs1(i_rs1), .i_pc(i_pc), .i_imm(i_imm),
    .i_Branch(i_Branch),
    .i_zero(Zero), .i_less(Less),
    .o_nextpc(nextpc)
  );

  wire [63:0] rdata;
  assign o_GPRbusW = i_MemtoReg ? rdata : (i_sel_csr ? i_rs2 : o_ALUresult);
  MuxKey #(.NR_KEY(7), .KEY_LEN(3), .DATA_LEN(64)) u_mux1 (
    .out(rdata),
    .key(i_MemOP),
    .lut({
      3'b000, {{56{i_rdata[7]}}, i_rdata[7:0]},
      3'b001, {{56{1'b0}}, i_rdata[7:0]},
      3'b010, {{48{i_rdata[15]}}, i_rdata[15:0]},
      3'b011, {{48{1'b0}}, i_rdata[15:0]},
      3'b100, {{32{i_rdata[31]}}, i_rdata[31:0]},
      3'b101, {{32{1'b0}}, i_rdata[31:0]},
      3'b110, i_rdata
    })
  );

  MuxKeyWithDefault #(.NR_KEY(2), .KEY_LEN(4), .DATA_LEN(64)) u_mux2 (
    .out(o_CSRbusW),
    .key(i_EXctr),
    .default_out(64'b0),
    .lut({
      4'b0000, i_rs1, // csrrw
      4'b0001, i_csrrdata | i_rs1 // csrrs
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
