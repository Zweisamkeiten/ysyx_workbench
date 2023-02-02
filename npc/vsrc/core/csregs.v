// ysyx_22050710 CSR regs

import "DPI-C" function void set_csr_ptr(input logic [63:0] a[]);

`define NRCSR     4
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

  reg [DATA_WIDTH-1:0] rf [`NRCSR:0];
  initial set_csr_ptr(rf);

  always @(*) begin
    o_nextpc = 64'b0;
    o_sys_change_pc = 1'b0;

    if (i_ren) begin
      case (i_Exctr)
        4'b1101: begin // Environment call from M-mode Expection Code: 11
                  o_nextpc = mtvec;
                  o_sys_change_pc = 1'b1;
                 end
        4'b1100: begin // mret
                  o_nextpc = mepc;
                  o_sys_change_pc = 1'b1;
                 end
        default: ;
      endcase
    end
  end

  reg [DATA_WIDTH-1:0] mstatus = rf[0];
  initial mstatus = 64'ha00001800;
  reg [DATA_WIDTH-1:0] mtvec = rf[1];
  reg [DATA_WIDTH-1:0] mepc = rf[2];
  reg [DATA_WIDTH-1:0] mcause = rf[3];

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

  wire [2:0] waddr;
  MuxKey #(.NR_KEY(`NRCSR), .KEY_LEN(12), .DATA_LEN(3)) u_mux1 (
    .out(waddr),
    .key(i_waddr),
    .lut({
      `MSTATUS, 2'd0,
      `MTVEC,   2'd1,
      `MEPC,    2'd2,
      `MCAUSE,  2'd3
    })
  );
  always @(posedge i_clk) begin
    if (i_wen) begin
      case (i_Exctr)
        4'b1101: begin // Environment call from M-mode Expection Code: 11
                  mepc <= i_epc;
                  mcause <= 64'd11;
                 end
        4'b1001: rf[waddr] <= rf[waddr] | i_wdata; // csrrs
        default: rf[waddr] <= i_wdata; // csrrw
      endcase
    end
  end


endmodule
