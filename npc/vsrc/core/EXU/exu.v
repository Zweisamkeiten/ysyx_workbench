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

wire Zero, Less;
  ysyx_22050710_lsu u_alu (
    .i_rs1(i_rs1), .i_rs2(i_rs2), .i_imm(i_imm),
    .o_zero(Zero), .o_less(Less)
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

  wire [63:0] rdata;
  assign o_GPRbusW = i_MemtoReg ? rdata : (i_sel_csr ? i_rs2 : o_ALUresult);
  MuxKey #(.NR_KEY(7), .KEY_LEN(3), .DATA_LEN(64)) u_mux2 (
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

  reg [63:0] CSRbusW;
  assign o_CSRbusW = CSRbusW;

  always @(*) begin
    CSRbusW = 64'b0;
    case (i_EXctr)
      4'b1110: set_state_end(); // ebreak
      4'b0000: CSRbusW = src_a;
      default:;
    endcase
  end

  always @(i_is_invalid_inst) begin // 敏感变量只有 i_is_invalid_inst, reset(10) 因此只处理一次
    if (i_is_invalid_inst) set_state_abort(); // invalid inst
  end

endmodule
