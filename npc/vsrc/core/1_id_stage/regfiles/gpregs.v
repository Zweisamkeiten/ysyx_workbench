// ysyx_22050710 GPR regs

import "DPI-C" function void set_gpr_ptr(input logic [63:0] a[]);

module ysyx_22050710_gpr #(
  parameter ADDR_WIDTH                                       ,
  parameter DATA_WIDTH
) (
  input                        i_clk                         ,
  // read port 1
  input  [ADDR_WIDTH-1:0     ] i_raddr1                      ,
  output [DATA_WIDTH-1:0     ] o_rdata1                      ,
  // read port 2
  input  [ADDR_WIDTH-1:0     ] i_raddr2                      ,
  output [DATA_WIDTH-1:0     ] o_rdata2                      ,
  // write port
  input                        i_wen                         ,
  input  [ADDR_WIDTH-1:0     ] i_waddr                       ,
  input  [DATA_WIDTH-1:0     ] i_wdata
);

  initial set_gpr_ptr(rf)                                    ; // 将 gpr 数组 引用至仿真环境 以供调试

  reg [DATA_WIDTH-1:0        ] rf [32-1:0]                   ;

  assign o_rdata1            = i_raddr1 == 0                   // x0 寄存器恒为零
                             ? 64'b0
                             : rf[i_raddr1]                  ;

  assign o_rdata2            = i_raddr2 == 0                   // x0 寄存器恒为零
                             ? 64'b0
                             : rf[i_raddr2]                  ;

  always @(posedge i_clk) begin
    if (i_wen) rf[i_waddr] <= i_wdata;
  end

endmodule
