// ysyx_22050710 branch unit

module ysyx_22050710_bru (
  input  [63:0] i_rs1data, i_pc, i_imm,
  input  [2:0]  i_brfunc,
  input  i_zero,
  input  i_less,
  output [63:0] o_dnpc
);

  wire PCAsrc, PCBsrc;
  assign o_dnpc = (PCBsrc ? i_rs1data : i_pc) + (PCAsrc ? i_imm : 64'd4);

  MuxKey #(.NR_KEY(7), .KEY_LEN(3), .DATA_LEN(1)) u_mux0 (
    .out(PCAsrc),
    .key(i_brfunc),
    .lut({
      3'b000, 1'b0,
      3'b001, 1'b1,
      3'b010, 1'b1,
      3'b100, i_zero == 1 ? 1'b1 : 1'b0,
      3'b101, i_zero == 1 ? 1'b0 : 1'b1,
      3'b110, i_less == 1 ? 1'b1 : 1'b0,
      3'b111, i_less == 1 ? 1'b0 : 1'b1
    })
  );

  MuxKey #(.NR_KEY(7), .KEY_LEN(3), .DATA_LEN(1)) u_mux1 (
    .out(PCBsrc),
    .key(i_brfunc),
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

endmodule
