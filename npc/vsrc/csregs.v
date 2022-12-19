// ysyx_22050710 CSR regs

import "DPI-C" function void set_csr_ptr(input logic [63:0] a[]);

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

  reg [DATA_WIDTH-1:0] rf [4096-1:0];

  initial rf[`MSTATUS] = 64'ha00001800;

  assign o_bus = i_ren ? rf[i_raddr] : 64'b0;

  always @(posedge i_clk) begin
    o_nextpc <= 64'b0;
    o_sys_change_pc <= 1'b0;
    if (i_wen) begin
      case (i_Exctr)
        4'b1101: begin // Environment call from M-mode Expection Code: 11
                  rf[`MEPC] <= i_epc;
                  rf[`MCAUSE] <= 64'd11;
                  o_nextpc <= rf[`MTVEC];
                  o_sys_change_pc <= 1'b1;
                 end
        4'b1001: rf[i_waddr] <= rf[i_waddr] | i_wdata;
        default: rf[i_waddr] <= i_wdata;
      endcase
    end
  end
endmodule
