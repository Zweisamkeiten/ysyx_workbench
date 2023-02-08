// ysyx_22050710 Data Sram

module ysyx_22050710_data_sram #(
  parameter SRAM_ADDR_WD                                     ,
  parameter SRAM_WMASK_WD                                    ,
  parameter SRAM_DATA_WD
) (
  input                        i_clk                         ,

  input  [SRAM_ADDR_WD-1:0   ] i_addr                        ,  // 单端口用于读写地址
  // read port
  input                        i_ren                         ,
  output [SRAM_DATA_WD-1:0   ] o_rdata                       ,
  // write port
  input                        i_wen                         ,
  input  [SRAM_WMASK_WD-1:0  ] i_wmask                       ,
  input  [SRAM_DATA_WD-1:0   ] i_wdata
);

  wire [SRAM_ADDR_WD-1:0     ] raddr;
  wire [SRAM_ADDR_WD-1:0     ] waddr;
  assign raddr               = i_addr;
  assign waddr               = i_addr;

  reg  [SRAM_DATA_WD-1:0     ] rdata                         ;  // TODO read register for pmem read.

  // read port
  always @(*) begin                                             // TODO 改为 同步接口 延迟一周期返回
    if (i_ren) begin
      npc_pmem_read({32'b0, raddr}, rdata);
    end
    else begin
      rdata = 0;
    end
  end

  // write port
  always @(posedge i_clk) begin
    if (i_wen) begin
      npc_pmem_write({32'b0, waddr}, i_wdata, i_wmask);
    end
  end

  assign o_rdata             = i_ren ? rdata : 0             ;

endmodule
