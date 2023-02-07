// ysyx_22050710 CSR regs
`include "defines.v"

module ysyx_22050710_csr #(
  parameter ADDR_WIDTH                                       ,
  parameter DATA_WIDTH
) (
  input                        i_clk                         ,
  input                        i_rst                         ,
  // read port
  input                        i_ren                         ,
  input  [ADDR_WIDTH-1:0     ] i_raddr                       ,
  output [DATA_WIDTH-1:0     ] o_csrrdata                    ,
  // write port
  input                        i_wen                         ,
  input  [ADDR_WIDTH-1:0     ] i_waddr                       ,
  input  [DATA_WIDTH-1:0     ] i_wdata                       ,
  // epu bus
  input                        i_ecall_sel                   ,
  input                        i_mret_sel                    ,
  input  [DATA_WIDTH-1:0     ] i_epc                         ,
  output [DATA_WIDTH-1:0     ] o_mtvec                       ,
  output [DATA_WIDTH-1:0     ] o_mepc
);

  reg [DATA_WIDTH-1:0        ] mstatus                       ;
  always @(posedge i_clk) begin
    if (i_rst) begin
      mstatus <= 64'ha00001800;
    end
    else if (i_wen && i_waddr == `ysyx_22050710_MSTATUS) begin
      mstatus <= i_wdata;
    end

    if (i_mret_sel) begin
      mstatus <= 64'ha00001800;
    end
  end

  reg [DATA_WIDTH-1:0        ] mtvec                         ;
  always @(posedge i_clk) begin
    if (i_rst) begin
      mtvec <= 64'h0;
    end
    else if (i_wen && i_waddr == `ysyx_22050710_MTVEC) begin
      mtvec <= i_wdata;
    end
  end

  reg [DATA_WIDTH-1:0        ] mepc                          ;
  always @(posedge i_clk) begin
    if (i_rst) begin
      mepc <= 64'h0;
    end
    else if (i_wen && i_waddr == `ysyx_22050710_MEPC) begin
      mepc <= i_wdata;
    end

    if (i_ecall_sel) begin // Environment call from M-mode Expection Code: 11
      mepc <= i_epc;
    end
  end

  reg [DATA_WIDTH-1:0        ] mcause                        ;
  always @(posedge i_clk) begin
    if (i_rst) begin
      mcause <= 64'h0;
    end
    else if (i_wen && i_waddr == `ysyx_22050710_MCAUSE) begin
      mcause <= i_wdata;
    end

    if (i_ecall_sel) begin // Environment call from M-mode Expection Code: 11
      mcause <= 64'd11;
    end
  end

  wire [DATA_WIDTH-1:0       ] rdata                         ;
  MuxKey #(.NR_KEY(`ysyx_22050710_NRCSR), .KEY_LEN(12), .DATA_LEN(64)) u_mux0 (
    .out(rdata),
    .key(i_raddr),
    .lut({
      `ysyx_22050710_MSTATUS, mstatus,
      `ysyx_22050710_MTVEC,   mtvec,
      `ysyx_22050710_MEPC,    mepc,
      `ysyx_22050710_MCAUSE,  mcause
    })
  );

  assign o_csrrdata          = i_ren ? rdata : 64'b0         ;
  assign o_mtvec             = mtvec                         ;
  assign o_mepc              = mepc                          ;

endmodule
