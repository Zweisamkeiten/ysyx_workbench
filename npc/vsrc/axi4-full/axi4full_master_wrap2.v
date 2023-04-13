// ysyx_22050710 axi4-full Wrap 以axi4-full接口封装的master模块
`include "axi_defines.v"

module ysyx_22050710_axi4full_master_wrap #(
  // Width of data bus in bits
  parameter DATA_WIDTH       = 64                            ,
  // Width of address bus in bits
  parameter ADDR_WIDTH       = 32                            ,
  // Width of wstrb (width of data bus in words)
  parameter STRB_WIDTH       = (DATA_WIDTH/8)                ,
  parameter ID_WIDTH         = `YSYX_22050710_AXI_ID_WIDTH   ,
  parameter TRANSLEN_WIDTH   = `YSYX_22050710_AXI_TRANSLEN_WIDTH  ,

  parameter BURST_TYPE_FIXED = `YSYX_22050710_AXI_BURST_TYPE_FIXED,
  parameter BURST_TYPE_INCR  = `YSYX_22050710_AXI_BURST_TYPE_INCR ,
  parameter BURST_TYPE_WRAP  = `YSYX_22050710_AXI_BURST_TYPE_WRAP ,

  parameter PROT_UNPRIVILEGED_ACCESS      = `YSYX_22050710_AXI_PROT_UNPRIVILEGED_ACCESS     ,
  parameter PROT_PRIVILEGED_ACCESS        = `YSYX_22050710_AXI_PROT_PRIVILEGED_ACCESS       ,
  parameter PROT_SECURE_ACCESS            = `YSYX_22050710_AXI_PROT_SECURE_ACCESS           ,
  parameter PROT_NON_SECURE_ACCESS        = `YSYX_22050710_AXI_PROT_NON_SECURE_ACCESS       ,
  parameter PROT_DATA_ACCESS              = `YSYX_22050710_AXI_PROT_DATA_ACCESS             ,
  parameter PROT_INSTRUCTION_ACCESS       = `YSYX_22050710_AXI_PROT_INSTRUCTION_ACCESS      ,
  parameter AWCACHE_DEVICE_NON_BUFFERABLE = `YSYX_22050710_AXI_AWCACHE_DEVICE_NON_BUFFERABLE,
  parameter ARCACHE_DEVICE_NON_BUFFERABLE = `YSYX_22050710_AXI_ARCACHE_DEVICE_NON_BUFFERABLE
) (
	input                        i_rw_req                      ,  //IF&MEM输入信号
	input                        i_rw_wr                       ,  //IF&MEM输入信号
	input  [1:0                ] i_rw_size                     ,  //IF&MEM输入信号
  input  [ADDR_WIDTH-1:0     ] i_rw_addr                     ,  //IF&MEM输入信号
  input  [STRB_WIDTH-1:0     ] i_rw_wstrb                    ,  //IF&MEM输入信号
  input  [DATA_WIDTH-1:0     ] i_rw_wdata                    ,  //IF&MEM输入信号
	output                       o_rw_addr_ok                  ,  //IF&MEM输入信号
	output                       o_rw_data_ok                  ,  //IF&MEM输入信号
  output [DATA_WIDTH-1:0     ] o_rw_rdata                    ,  //IF&MEM输入信号

  input                        i_aclk                        ,  // AXI 时钟
  input                        i_arsetn                      ,  // AXI 复位 低电平复位

  // Wirte address channel
  output [ADDR_WIDTH-1:0     ] o_awaddr                      ,  // 写请求地址
  output [TRANSLEN_WIDTH-1:0 ] o_awlen                       ,  // 写请求控制信号, 请求传输的长度(数据传输拍数) 固定为0(without cache)
  output [2:0                ] o_awsize                      ,  // 写请求控制信号, 请求传输的大小(数据传输每拍的字节数)
  output [1:0                ] o_awburst                     ,  // 写请求控制信号, 传输类型 固定为0b01(without cache)
  output [1:0                ] o_awlock                      ,  // 写请求控制信号, 原子锁 固定为0
  output [3:0                ] o_awcache                     ,  // 写请求控制信号, Cache 属性 固定为 0
  output [2:0                ] o_awprot                      ,  // 写请求控制信号, 保护属性 写权限
  output                       o_awvalid                     ,  // 写请求地址握手信号, 写请求地址有效
  input                        i_awready                     ,  // 写请求地址握手信号, slave 端准备好接收地址传输

  // Write data channel
  output [DATA_WIDTH-1:0     ] o_wdata                       ,  // 写请求的写数据
  output [STRB_WIDTH-1:0     ] o_wstrb                       ,  // 写请求控制信号, 字节选通位
  output                       o_wlast                       ,  // 写请求控制信号, 本次写请求的最后一拍数据的指示信号
  output                       o_wvalid                      ,  // 写请求数据握手信号, 写请求数据有效
  input                        i_wready                      ,  // 写请求数据握手信号, slave 端准备好将接收数据传输

  // Write response channel
  input  [1:0                ] i_bresp                       ,  // 写请求控制信号, 本次写请求是否成功完成
  input                        i_bvalid                      ,  // 写请求响应握手信号, 写请求响应有效
  output                       o_bready                      ,  // 写请求响应握手信号, master 端准备好接收写响应

  // Read address channel
  output [ADDR_WIDTH-1:0     ] o_araddr                      ,  // 读请求的地址
  output [TRANSLEN_WIDTH-1:0 ] o_arlen                       ,  // 读请求控制信号, 请求传输的长度(数据传输拍数) 固定为0
  output [2:0                ] o_arsize                      ,  // 读请求控制信号, 请求传输的大小(数据传输每拍的字节数)
  output [1:0                ] o_arburst                     ,  // 读请求控制信号, 传输类型 固定为 0b01(without cache)
  output [1:0                ] o_arlock                      ,  // 读请求控制信号, 原子锁 固定为 0
  output [3:0                ] o_arcache                     ,  // 读请求控制信号, Cache 属性 固定为 0
  output [2:0                ] o_arprot                      ,  // 读请求控制信号, 保护属性 固定为 0
  output                       o_arvalid                     ,  // 读请求地址握手信号, 读请求地址有效
  input                        i_arready                     ,  // 读请求地址握手信号, slave 端准备好接收地址传输

  // Read data channel
  input  [DATA_WIDTH-1:0     ] i_rdata                       ,  // 读请求的读回数据
  input  [1:0                ] i_rresp                       ,  // 读请求控制信号, 本次读请求是否成功完成 可忽略
  input                        i_rlast                       ,  // 读请求控制信号, 本次读请求的最后一拍数据的知识信号 可忽略
  input                        i_rvalid                      ,  // 读请求数据握手信号, 读请求数据有效
  output                       o_rready                         // 读请求数据握手信号, master 端准备好接收数据传输
);

  // ---------------------------------------------------------
  wire aw_fire                                               ;
  wire w_fire                                                ;
  wire b_fire                                                ;
  wire ar_fire                                               ;
  wire r_fire                                                ;

  // 主机主动向从机发送信号 !
  // --------------------------------------------------------
  assign aw_fire             = o_awvalid & i_awready         ;
  assign w_fire              = o_wvalid  & i_wready          ;
  assign b_fire              = o_bready  & i_bvalid          ;
  assign ar_fire             = o_arvalid & i_arready         ;
  assign r_fire              = o_rready  & i_rvalid          ;

  // ------------------State Machine--------------------------
  localparam [1:0]
      READ_STATE_IDLE        = 2'd0                          ,
      READ_STATE_ADDR        = 2'd1                          ,
      READ_STATE_READ        = 2'd2                          ;

  reg [1:0] read_state_reg   = READ_STATE_IDLE               ;

  wire r_state_idle = read_state_reg == READ_STATE_IDLE      ;
  wire r_state_addr = read_state_reg == READ_STATE_ADDR      ;
  wire r_state_read = read_state_reg == READ_STATE_READ      ;

  // 读通道状态切换
  always @(posedge i_aclk) begin
    if (~i_arsetn) begin
      read_state_reg <= READ_STATE_IDLE;
    end
    else begin
      case (read_state_reg)
        READ_STATE_IDLE : if (i_rw_req && ~i_rw_wr) read_state_reg <= READ_STATE_ADDR ;
        READ_STATE_ADDR : if (ar_fire) read_state_reg <= READ_STATE_READ ;
        READ_STATE_READ : if (r_fire ) read_state_reg <= READ_STATE_IDLE ;
        default         :              read_state_reg <= READ_STATE_IDLE ;
      endcase
    end
  end

  localparam [1:0]
      WRITE_STATE_IDLE       = 2'd0                          ,
      WRITE_STATE_ADDR       = 2'd1                          ,
      WRITE_STATE_WRITE      = 2'd2                          ,
      WRITE_STATE_RESP       = 2'd3                          ;

  reg [1:0] write_state_reg  = WRITE_STATE_IDLE              ;

  wire w_state_idle  = write_state_reg == WRITE_STATE_IDLE   ;
  wire w_state_addr  = write_state_reg == WRITE_STATE_ADDR   ;
  wire w_state_write = write_state_reg == WRITE_STATE_WRITE  ;
  wire w_state_resp  = write_state_reg == WRITE_STATE_RESP   ;

  // 写通道状态切换
  always @(posedge i_aclk) begin
    if (~i_arsetn) begin
      write_state_reg <= WRITE_STATE_IDLE;
    end
    else begin
      case (write_state_reg)
        WRITE_STATE_IDLE  : if (i_rw_req && i_rw_wr) write_state_reg <= WRITE_STATE_ADDR  ;
        WRITE_STATE_ADDR  : if (aw_fire) write_state_reg <= WRITE_STATE_WRITE ;
        WRITE_STATE_WRITE : if (w_fire ) write_state_reg <= WRITE_STATE_RESP  ;
        WRITE_STATE_RESP  : if (b_fire ) write_state_reg <= WRITE_STATE_IDLE  ;
        default           :              write_state_reg <= WRITE_STATE_IDLE  ;
      endcase
    end
  end

  // ------------------Write Transaction----------------------
  wire [TRANSLEN_WIDTH-1:0   ] axi_len                       ;
  assign axi_len             = 0                             ;

  // 写地址通道
  assign o_awvalid           = w_state_addr                  ;
  assign o_awaddr            = i_rw_addr                     ;
  assign o_awprot            = PROT_UNPRIVILEGED_ACCESS
                             | PROT_SECURE_ACCESS
                             | PROT_DATA_ACCESS              ;  // 初始化信号即可 固定为 0
  assign o_awlen             = axi_len                       ;  // 固定为 0
  assign o_awsize            = {1'b0, i_rw_size}             ;
  assign o_awburst           = BURST_TYPE_INCR               ;  // 固定为 2'b01
  assign o_awlock            = 0                             ;  // 固定为 0
  assign o_awcache           = AWCACHE_DEVICE_NON_BUFFERABLE ;  // 固定为 0

  // 写数据通道
  assign o_wvalid            = w_state_write                 ;
  assign o_wdata             = i_rw_wdata                    ;
  assign o_wstrb             = i_rw_wstrb                    ;
  assign o_wlast             = 1'b1                          ; // 固定为 1

  // 写应答通道
  assign o_bready            = w_state_resp                  ;

  // ------------------Read Transaction-----------------------

  // Read address channel signals
  assign o_arvalid           = r_state_addr                  ;
  assign o_araddr            = i_rw_addr                     ;
  assign o_arprot            = PROT_UNPRIVILEGED_ACCESS
                             | PROT_SECURE_ACCESS
                             | PROT_DATA_ACCESS              ;  // 初始化信号即可 固定为 0
  assign o_arlen             = axi_len                       ;  // 固定为 0
  assign o_arsize            = {1'b0, i_rw_size}             ;
  assign o_arburst           = BURST_TYPE_INCR               ;  // 固定为 2'b01
  assign o_arlock            = 0                             ;  // 固定为 0
  assign o_arcache           = ARCACHE_DEVICE_NON_BUFFERABLE ;  // 固定为 0

  // Read data channel signals
  assign o_rready            = r_state_read                  ;

  assign o_rw_addr_ok        = ar_fire | w_fire              ;
  assign o_rw_data_ok        = r_fire  | b_fire              ;
  assign o_rw_rdata          = i_rdata                       ;

endmodule
