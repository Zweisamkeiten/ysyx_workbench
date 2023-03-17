// ysyx_22050710 Cache

module ysyx_22050710_cache #(
  parameter CACHELINE_WD     = `ysyx_22050710_WORD_WD        ,
) (
  input                        i_clk                         , // 时钟信号
  input                        i_rst                         , // 复位信号

  // Cache 与 CPU 流水线接口
  input                        i_valid                       , // 表明请求有效
  input                        i_op                          , // 1 : WRITE; 0: READ
  input                        i_index                       , // 地址的 index  域 addr[11:4]
  input  [20-1:0             ] i_tag                         , // 地址的 tag    域 addr[31:12]
  input  [4-1:0              ] i_offset                      , // 地址的 offset 域 addr[3:0]
  input  [4-1:0              ] i_wstrb                       , // 写字节使能信号
  input  [32-1:0             ] i_wdata                       , // 写数据
  output                       o_addr_ok                     , // 该次请求的地址传输 OK, 读: 地址被接收; 写: 地址和数据被接收
  output                       o_data_ok                     , // 该次请求的数据传输 OK, 读: 数据返回; 写: 数据写入完成
  output [32-1:0             ] o_rdata                       , // 读 Cache 的结果

  // Cache 与 AXI 总线接口的交互接口
  output                       o_rd_req                      , // 读请求有效信号, 高电平有效
  output [3-1:0              ] o_rd_type                     , // 读请求类型 3'b000: 字节, 3'b001: 半字, 3'b010: 字, 3'b100: Cache 行
  output [32-1:0             ] o_rd_addr                     , // 读请求起始地址
  input                        i_rd_rdy                      , // 读请求能否被接收的握手信号. 高电平有效.
  input                        i_ret_valid                   , // 返回数据有效. 高电平有效.
  input  [2-1:0              ] i_ret_last                    , // 返回数据是一次读请求对应的最后一个返回数据
  input  [32-1:0             ] i_ret_data                    , // 读返回数据
  output                       o_wr_req                      , // 写请求有效信号. 高电平有效
  output [3-1:0              ] o_wr_type                     , // 写请求类型 3'b000: 字节, 3'b001: 半字, 3'b010: 字, 3'b100:  Cache 行
  output [32-1:0             ] o_wr_addr                     , // 写请求起始地址
  output [4-1:0              ] o_wr_wstrb                    , // 写操作的字节掩码. 仅在写请求类型为 3'b000, 3'b001, 3'b010的情况下才有意义
  output [32-1:0             ] o_wr_data                     , // 写数据
  input                        i_wr_rdy                        // 写请求能否被接收的握手信号. 高电平有效. 此处要求 wr_rdy 要先于
);

  

endmodule
