// ysyx_22050710 CSR regs

`define NR_CSR 4
module ysyx_22050710_csr #(ADDR_WIDTH = 12, DATA_WIDTH = 64) (
  input   i_clk,
  input   [ADDR_WIDTH-1:0] i_raddr, i_waddr,
  input   [DATA_WIDTH-1:0] i_wdata,
  input   i_wen,
  output  [DATA_WIDTH-1:0] o_bus
);

  reg [DATA_WIDTH-1:0] rf [`NR_CSR-1:0];

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
  MuxKey #(.NR_KEY(4), .KEY_LEN(12), .DATA_LEN(12)) u_mux0 (
    .out(wcsr_idx),
    .key(i_waddr),
    .lut({
      12'h300, 12'd0,    // MSTATUS
      12'h305, 12'd1,    // MTVEC
      12'h341, 12'd2,    // MEPC
      12'h342, 12'd3     // MCAUSE
    })
  );

  assign o_bus = rf[rcsr_idx];

  always @(posedge i_clk) begin
    if (i_wen) rf[wcsr_idx] <= i_wdata;
  end
endmodule
