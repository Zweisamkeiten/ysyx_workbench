// ysyx_22050710 CSR regs

`define NRCSR     4
`define MSTATUS   12'h300
`define MTVEC     12'h305
`define MEPC      12'h341
`define MCAUSE    12'h342

module ysyx_22050710_csr #(ADDR_WIDTH = 12, DATA_WIDTH = 64) (
  input   i_clk,
  input   [ADDR_WIDTH-1:0] i_raddr, i_waddr,
  input   [DATA_WIDTH-1:0] i_wdata,
  input   [63:0] i_epc,
  input   i_raise_intr, i_intr_ret,
  input   i_ren, i_wen,
  output  [DATA_WIDTH-1:0] o_bus,
  output  reg [63:0] o_nextpc, output reg o_sys_change_pc
);

  always @(*) begin
    o_nextpc = 64'b0;
    o_sys_change_pc = 1'b0;

    if (i_raise_intr) begin
      o_nextpc = mtvec;
      o_sys_change_pc = 1'b1;
    end
    else if(i_intr_ret) begin // mret
      o_nextpc = mepc;
      o_sys_change_pc = 1'b1;
    end
  end

  reg [DATA_WIDTH-1:0] mstatus;
  initial mstatus = 64'ha00001800;
  always @(posedge i_clk) begin
    if (i_waddr == `MSTATUS) begin
      mstatus <= i_wdata;
    end
  end

  reg [DATA_WIDTH-1:0] mtvec;
  always @(posedge i_clk) begin
    if (i_waddr == `MTVEC) begin
      mtvec <= i_wdata;
    end
  end

  reg [DATA_WIDTH-1:0] mepc;
  always @(posedge i_clk) begin
    if (i_waddr == `MEPC) begin
      mepc <= i_wdata;
    end
  end

  reg [DATA_WIDTH-1:0] mcause;
  always @(posedge i_clk) begin
    if (i_waddr == `MCAUSE) begin
      mcause <= i_wdata;
    end
  end

  wire [DATA_WIDTH-1:0] rdata;
  assign o_bus = i_ren ? rdata : 64'b0;
  MuxKey #(.NR_KEY(`NRCSR), .KEY_LEN(12), .DATA_LEN(64)) u_mux0 (
    .out(rdata),
    .key(i_raddr),
    .lut({
      `MSTATUS, mstatus,
      `MTVEC,   mtvec,
      `MEPC,    mepc,
      `MCAUSE,  mcause
    })
  );

  always @(posedge i_clk) begin
    if (i_wen) begin
      if (i_raise_intr) begin // Environment call from M-mode Expection Code: 11
        mepc <= i_epc;
        mcause <= 64'd11;
      end
      else if (i_intr_ret) begin
        mstatus <= 64'ha00001800;
      end
      else begin
        mstatus <= 64'ha00001800;
      end
    end
  end


endmodule
