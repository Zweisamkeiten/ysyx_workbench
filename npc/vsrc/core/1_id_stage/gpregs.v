// ysyx_22050710 GPR regs

import "DPI-C" function void set_gpr_ptr(input logic [63:0] a[]);

module ysyx_22050710_gpr #(ADDR_WIDTH = 5, DATA_WIDTH = 64) (
  input   i_clk,
  input   [ADDR_WIDTH-1:0] i_raddr1, i_raddr2, i_waddr,
  input   [DATA_WIDTH-1:0] i_wdata,
  input   i_wen,
  output  [DATA_WIDTH-1:0] o_rdata1, o_rdata2
);

  initial set_gpr_ptr(rf);

  reg [DATA_WIDTH-1:0] rf [32-1:0];

  assign o_rdata1 = |i_raddr1 == 0 ? 64'b0 : rf[i_raddr1];
  assign o_rdata2 = |i_raddr2 == 0 ? 64'b0 : rf[i_raddr2];

  always @(posedge i_clk) begin

    if (i_wen) rf[i_waddr] <= i_wdata;

  end

endmodule
