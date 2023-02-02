// ysyx_22050710 CSR regs

import "DPI-C" function void set_csr_ptr(input logic [63:0] a[]);

`define NRCSR     12'd4
`define MSTATUS   12'h300
`define MTVEC     12'h305
`define MEPC      12'h341
`define MCAUSE    12'h342

module ysyx_22050710_csr #(ADDR_WIDTH = 12, DATA_WIDTH = 64) (
  input   i_clk,
  input   [ADDR_WIDTH-1:0] i_raddr, i_waddr,
  input   [DATA_WIDTH-1:0] i_wdata,
  input   [3:0] i_Exctr, input [63:0] i_epc,
  input   i_ren, i_wen,
  output  [DATA_WIDTH-1:0] o_bus,
  output  reg [63:0] o_nextpc, output reg o_sys_change_pc
);

  initial set_csr_ptr(rf);

  always @(*) begin
    o_nextpc = 64'b0;
    o_sys_change_pc = 1'b0;

    if (i_ren) begin
      case (i_Exctr)
        4'b1101: begin // Environment call from M-mode Expection Code: 11
                  o_nextpc = rf[`MTVEC];
                  o_sys_change_pc = 1'b1;
                 end
        4'b1100: begin // mret
                  o_nextpc = rf[`MEPC];
                  o_sys_change_pc = 1'b1;
                 end
        default: ;
      endcase
    end
  end

  always @(posedge i_clk) begin
    if (i_wen) begin
      case (i_Exctr)
        4'b1101: begin // Environment call from M-mode Expection Code: 11
                  rf[`MEPC] <= i_epc;
                  rf[`MCAUSE] <= 64'd11;
                 end
        4'b1001: rf[i_waddr] <= rf[i_waddr] | i_wdata; // csrrs
        default: rf[i_waddr] <= i_wdata; // csrrw
      endcase
    end
  end

  reg [DATA_WIDTH-1:0] mstatus;
  initial mstatus = 64'ha00001800;
  reg [DATA_WIDTH-1:0] mtvec;
  reg [DATA_WIDTH-1:0] mepc;
  reg [DATA_WIDTH-1:0] mcause;

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

endmodule
