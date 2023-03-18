// ysyx_22050710 Cache

module ysyx_22050710_cache #(
  parameter ADDR_WIDTH       = 32                            ,
  parameter DATA_WIDTH       = 64                            ,
  parameter CACHE_SIZE       = 4096                          , // cache size in bytes
  parameter CACHELINE_SIZE   = 16                            , // cache line size in bytes
  parameter ASSOC_NUM        = 4                             , // 四路组相连
  parameter WAY_SIZE         = CACHE_SIZE / ASSOC_NUM        , // 路大小
  parameter OFFSET_WIDTH     = $clog2(CACHELINE_SIZE)        , // Cache 行内偏移
  parameter INDEX_WIDTH      = $clog2(CACHE_SIZE/CACHELINE_SIZE/ASSOC_NUM),  // index width in bits 6bits
  parameter TAG_WIDTH        = ADDR_WIDTH - $clog2(WAY_SIZE)   // 物理地址宽度 - log2(路大小)
) (
  input                        i_clk                         , // 时钟信号
  input                        i_rst                         , // 复位信号

  // Cache 与 CPU 流水线接口
  input                        i_valid                       , // 表明请求有效
  input                        i_op                          , // 1 : WRITE; 0: READ
  input  [INDEX_WIDTH-1:0    ] i_index                       , // 地址的 index  域 addr[9:4]
  input  [TAG_WIDTH-1:0      ] i_tag                         , // 地址的 tag    域 addr[31:10]
  input  [OFFSET_WIDTH-1:0   ] i_offset                      , // 地址的 offset 域 addr[3:0]
  input  [OFFSET_WIDTH-1:0   ] i_wstrb                       , // 写字节使能信号
  input  [DATA_WIDTH-1:0     ] i_wdata                       , // 写数据
  output                       o_addr_ok                     , // 该次请求的地址传输 OK, 读: 地址被接收; 写: 地址和数据被接收
  output                       o_data_ok                     , // 该次请求的数据传输 OK, 读: 数据返回; 写: 数据写入完成
  output [32-1:0             ] o_rdata                       , // 读 Cache 的结果

  // Cache 与 AXI 总线接口的交互接口
  output                       o_rd_req                      , // 读请求有效信号, 高电平有效
  output [3-1:0              ] o_rd_type                     , // 读请求类型 3'b000: 字节, 3'b001: 半字, 3'b010: 字, 3'b100: Cache 行
  output [ADDR_WIDTH-1:0     ] o_rd_addr                     , // 读请求起始地址
  input                        i_rd_rdy                      , // 读请求能否被接收的握手信号. 高电平有效.
  input                        i_ret_valid                   , // 返回数据有效. 高电平有效.
  input  [2-1:0              ] i_ret_last                    , // 返回数据是一次读请求对应的最后一个返回数据
  input  [DATA_WIDTH-1:0     ] i_ret_data                    , // 读返回数据
  output                       o_wr_req                      , // 写请求有效信号. 高电平有效
  output [3-1:0              ] o_wr_type                     , // 写请求类型 3'b000: 字节, 3'b001: 半字, 3'b010: 字, 3'b100:  Cache 行
  output [ADDR_WIDTH-1:0     ] o_wr_addr                     , // 写请求起始地址
  output [OFFSET_WIDTH-1:0   ] o_wr_wstrb                    , // 写操作的字节掩码. 仅在写请求类型为 3'b000, 3'b001, 3'b010的情况下才有意义
  output [DATA_WIDTH-1:0     ] o_wr_data                     , // 写数据
  input                        i_wr_rdy                        // 写请求能否被接收的握手信号. 高电平有效. 此处要求 wr_rdy 要先于
);


  parameter Bits             = 128                           ;
  wire [4-1:0                ] wstrb                         ;
  wire                         cen                           ;
  wire                         op                            ;
  wire [Bits-1:0             ] bwen                          ;
  assign wstrb               = ~i_wstrb                      ;
  assign cen                 = ~i_valid                      ;
  assign wen                 = ~i_op                         ;

  MuxKey #(
    .NR_KEY                   (16                           ),
    .KEY_LEN                  (4                            ),
    .DATA_LEN                 (128                          )
  ) u_mux0 (
    .out                      (bwen                         ),
    .key                      (wstrb                        ),
    .lut                      ({
                                 4'd0, 128'b0                ,
                                 4'd1, {120'b0, 8'b1        },
                                 4'd2, {112'b0, 8'b1,   8'b0},
                                 4'd3, {104'b0, 8'b1,  16'b0},
                                 4'd4, { 96'b0, 8'b1,  24'b0},
                                 4'd5, { 88'b0, 8'b1,  32'b0},
                                 4'd6, { 80'b0, 8'b1,  40'b0},
                                 4'd7, { 72'b0, 8'b1,  48'b0},
                                 4'd8, { 64'b0, 8'b1,  56'b0},
                                 4'd9, { 56'b0, 8'b1,  64'b0},
                                4'd10, { 48'b0, 8'b1,  72'b0},
                                4'd11, { 40'b0, 8'b1,  80'b0},
                                4'd12, { 32'b0, 8'b1,  88'b0},
                                4'd13, { 24'b0, 8'b1,  96'b0},
                                4'd14, { 16'b0, 8'b1, 104'b0},
                                4'd15, {  8'b0, 8'b1, 112'b0}
    })
  );

  // ---------------------------------------------------------
  // tag array
  reg [TAG_WIDTH-1:0] tag   [INDEX_WIDTH-1:0][ASSOC_NUM-1:0] ;
  reg [ASSOC_NUM-1:0] valid [INDEX_WIDTH-1:0]                ;
  reg [ASSOC_NUM-1:0] dirty [INDEX_WIDTH-1:0]                ;

  wire [CACHELINE_SIZE-1:0] cacheline_way [ASSOC_NUM-1]      ;
  // ---------------------------------------------------------
  // data array
  ysyx_22050710_S011HD1P_X32Y2D128_BW u_way0 (
    .Q                        (cacheline_way[0]             ), // 读数据
    .CLK                      (i_clk                        ), // 时钟
    .CEN                      (cen                          ), // 使能信号, 低电平有效
    .WEN                      (wen                          ), // 写使能信号, 低电平有效
    .BWEN                     (bwen                         ), // 写掩码信号, 掩码粒度为 1bit, 低电平有效
    .A                        (i_index                      ), // 读写地址
    .D                        ()  // 写数据
  );

  ysyx_22050710_S011HD1P_X32Y2D128_BW u_way1 (
    .Q                        (cacheline_way[1]             ), // 读数据
    .CLK                      (i_clk                        ), // 时钟
    .CEN                      (cen                          ), // 使能信号, 低电平有效
    .WEN                      (wen                          ), // 写使能信号, 低电平有效
    .BWEN                     (bwen                         ), // 写掩码信号, 掩码粒度为 1bit, 低电平有效
    .A                        (i_index                      ), // 读写地址
    .D                        ()  // 写数据
  );
  
  ysyx_22050710_S011HD1P_X32Y2D128_BW u_way2 (
    .Q                        (cacheline_way[2]             ), // 读数据
    .CLK                      (i_clk                        ), // 时钟
    .CEN                      (cen                          ), // 使能信号, 低电平有效
    .WEN                      (wen                          ), // 写使能信号, 低电平有效
    .BWEN                     (bwen                         ), // 写掩码信号, 掩码粒度为 1bit, 低电平有效
    .A                        (i_index                      ), // 读写地址
    .D                        ()  // 写数据
  );

  ysyx_22050710_S011HD1P_X32Y2D128_BW u_way3 (
    .Q                        (cacheline_way[3]             ), // 读数据
    .CLK                      (i_clk                        ), // 时钟
    .CEN                      (cen                          ), // 使能信号, 低电平有效
    .WEN                      (wen                          ), // 写使能信号, 低电平有效
    .BWEN                     (bwen                         ), // 写掩码信号, 掩码粒度为 1bit, 低电平有效
    .A                        (i_index                      ), // 读写地址
    .D                        ()  // 写数据
  );
  // ---------------------------------------------------------
endmodule
