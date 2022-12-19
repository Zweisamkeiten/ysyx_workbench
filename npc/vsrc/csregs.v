// ysyx_22050710 CSR regs

import "DPI-C" function void set_csr_ptr(input logic [63:0] a[]);

module ysyx_22050710_csr #(ADDR_WIDTH = 12, DATA_WIDTH = 64) (
  input   i_clk,
  input   [ADDR_WIDTH-1:0] i_raddr, i_waddr,
  input   [DATA_WIDTH-1:0] i_wdata,
  input   i_ren, i_wen,
  output  [DATA_WIDTH-1:0] o_bus
);
  initial set_csr_ptr(rf);

  reg [DATA_WIDTH-1:0] rf [4096-1:0];

  assign o_bus = i_ren ? rf[i_raddr] : 64'b0;

  always @(posedge i_clk) begin
    $display(i_waddr);
    if (i_wen) rf[i_waddr] <= i_wdata;
  end
endmodule
