// ysyx_22050710 branch unit

module ysyx_22050710_bru (
  input  [63:0] i_rs1data, i_rs2data, i_pc, i_imm,
  input  [2:0]  i_brfunc,
  output [63:0] o_dnpc
);

  wire [63:0] sub_result; wire cout;
  wire overflow = ~(i_rs1data[63] ^ i_rs2data[63]) ^ ~(i_rs1data[62] ^ i_rs2data[62]);
  assign {cout, sub_result}   = {1'b0, i_rs1data} + {1'b0, (({64{1'b1}}^(i_rs2data)) + 1)};

  wire signed_Less = overflow == 0
                   ? (sub_result[63] == 1 ? 1'b1 : 1'b0)
                   : (sub_result[63] == 0 ? 1'b1 : 1'b0);
  wire unsigned_Less = (1'b1 ^ cout) & ~(|i_rs2data == 1'b0); // CF = cin ^ cout

  wire zero = ~(|sub_result);
  wire less;
  MuxKey #(.NR_KEY(8), .KEY_LEN(3), .DATA_LEN(1)) u_mux0 (
    .out(less),
    .key(i_brfunc),
    .lut({
      3'b001, 1'b0,
      3'b010, 1'b0,
      3'b100, signed_Less,
      3'b101, signed_Less,
      3'b110, signed_Less,
      3'b111, signed_Less,
      3'b110, unsigned_Less,
      3'b111, unsigned_Less
    })
  );

  MuxKey #(.NR_KEY(7), .KEY_LEN(3), .DATA_LEN(1)) u_mux1 (
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

  MuxKey #(.NR_KEY(7), .KEY_LEN(3), .DATA_LEN(1)) u_mux2 (
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

  wire PCAsrc, PCBsrc;
  assign o_dnpc = (PCBsrc ? i_rs1data : i_pc) + (PCAsrc ? i_imm : 64'd4);

endmodule
