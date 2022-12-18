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

  wire [11:0] rcsr_idx;
  MuxKey #(.NR_KEY(4), .KEY_LEN(12), .DATA_LEN(12)) u_mux0 (
    .out(rcsr_idx),
    .key(i_raddr),
    .lut({
      12'h300, 12'd0,    // MSTATUS
      12'h305, 12'd1,    // MTVEC
      12'h341, 12'd2,    // MEPC
      12'h342, 12'd3     // MCAUSE
    })
  );

  wire [11:0] wcsr_idx;
  MuxKey #(.NR_KEY(4), .KEY_LEN(12), .DATA_LEN(12)) u_mux1 (
    .out(wcsr_idx),
    .key(i_waddr),
    .lut({
      12'h300, 12'd0,    // MSTATUS
      12'h305, 12'd1,    // MTVEC
      12'h341, 12'd2,    // MEPC
      12'h342, 12'd3     // MCAUSE
    })
  );

  assign o_bus = i_ren ? rf[rcsr_idx] : 64'b0;

  always @(posedge i_clk) begin
    if (i_wen) rf[wcsr_idx] <= i_wdata;
  end
endmodule
