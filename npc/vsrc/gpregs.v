module ysyx_22050710_gpr #(ADDR_WIDTH = 32, DATA_WIDTH = 64) (
  input i_clk,
  input [ADDR_WIDTH-1:0] i_ra, i_rb, i_waddr,
  input [DATA_WIDTH-1:0] i_wdata,
  input i_wen,
  output [DATA_WIDTH-1:0] o_busA, o_busB
);
  reg [DATA_WIDTH-1:0] rf [ADDR_WIDTH-1:0];

  assign o_busA = i_ra == 64'b0 ? 64'b0 : rf[i_ra];
  assign o_busB = i_rb == 64'b0 ? 64'b0 : rf[i_rb];

  always @(posedge i_clk) begin
    if (i_wen) rf[i_waddr] <= i_wdata;
  end
endmodule
