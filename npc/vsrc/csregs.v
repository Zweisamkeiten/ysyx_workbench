// ysyx_22050710 CSR regs

module ysyx_22050710_csr #(ADDR_WIDTH = 12, DATA_WIDTH = 64) (
  input   i_clk,
  input   [ADDR_WIDTH-1:0] i_raddr, i_waddr,
  input   [DATA_WIDTH-1:0] i_wdata,
  input   i_wen,
  output  [DATA_WIDTH-1:0] o_bus
);

  reg [DATA_WIDTH-1:0] rf [4-1:0];
  [MSTATUS] = 0x300,
  [MTVEC]   = 0x305,
  [MEPC]    = 0x341,
  [MCAUSE]  = 0x342,

  wire [11:0] csr_idx;
  MuxKey #(.NR_KEY(4), .KEY_LEN(12), .DATA_LEN(12)) u_mux0 (
    .out(csr_idx),
    .key(i_addr),
    .lut({
      12'h300, 12'd0,    // MSTATUS
      12'h305, 12'd1,    // MTVEC
      12'h341, 12'd2,    // MEPC
      12'h342, 12'd3     // MCAUSE
    })
  );

  assign o_bus = rf[i_raddr];

  always @(posedge i_clk) begin
    if (i_wen) rf[i_waddr] <= i_wdata;
  end
endmodule
