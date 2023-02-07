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
  reg [DATA_WIDTH-1:0        ] mtvec                         ;
  reg [DATA_WIDTH-1:0        ] mepc                          ;
  reg [DATA_WIDTH-1:0        ] mcause                        ;

  always @(posedge i_clk) begin
    if (i_wen) begin
      case (i_waddr)
       `ysyx_22050710_MSTATUS: mstatus <= i_wdata;
       `ysyx_22050710_MTVEC  : mtvec   <= i_wdata;
       `ysyx_22050710_MEPC   : mepc    <= i_wdata;
       `ysyx_22050710_MCAUSE : mcause  <= i_wdata;
       default               :
      endcase
    end
  end

  always @(posedge i_clk) begin
    if (i_rst) begin
      mstatus <= 64'ha00001800;
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

  always @(posedge i_clk) begin
    if (i_ecall_sel) begin // Environment call from M-mode Expection Code: 11
      mepc <= i_epc;
      mcause <= 64'd11;
    end
    else if (i_mret_sel) begin
      mstatus <= 64'ha00001800;
    end
  end

  assign o_csrrdata          = i_ren ? rdata : 64'b0         ;
  assign o_mtvec             = mtvec                         ;
  assign o_mepc              = mepc                          ;

endmodule
