// ysyx_22050710 axi lite Wrap 以axi-lite接口封装的master模块
`include "axi_defines.v"

module ysyx_22050710_axil_master_wrap #(
  // Width of data bus in bits
  parameter DATA_WIDTH       = 64                            ,
  // Width of address bus in bits
  parameter ADDR_WIDTH       = 32                            ,
  // Width of wstrb (width of data bus in words)
  parameter STRB_WIDTH       = (DATA_WIDTH/8)
) (
	input                        i_rw_valid                    ,  //IF&MEM输入信号
	output                       o_rw_addr_ok                  ,  //IF&MEM输入信号
	output                       o_rw_data_ok                  ,  //IF&MEM输入信号
	input                        i_rw_ren                      ,  //IF&MEM输入信号
	input                        i_rw_wen                      ,  //IF&MEM输入信号
  input  [ADDR_WIDTH-1:0]      i_rw_addr                     ,  //IF&MEM输入信号
  output [DATA_WIDTH-1:0]      o_data_read                   ,  //IF&MEM输入信号
  input  [DATA_WIDTH-1:0]      i_rw_w_data                   ,  //IF&MEM输入信号
  input  [STRB_WIDTH-1:0]      i_rw_size                     ,  //IF&MEM输入信号

  input                        i_aclk                        ,
  input                        i_arsetn                      ,  // 低电平复位

  // Wirte address channel
  output                       o_awvalid                     ,
  input                        i_awready                     ,
  output [ADDR_WIDTH-1:0     ] o_awaddr                      ,
  output [2:0                ] o_awprot                      , // define the access permission for write accesses.

  // Write data channel
  output                       o_wvalid                      ,
  input                        i_wready                      ,
  output [DATA_WIDTH-1:0     ] o_wdata                       ,
  output [STRB_WIDTH-1:0     ] o_wstrb                       ,

  // Write response channel
  input                        i_bvalid                      ,
  output                       o_bready                      ,
  input  [1:0                ] i_bresp                       ,

  // Read address channel
  output                       o_arvalid                     ,
  input                        i_arready                     ,
  output [ADDR_WIDTH-1:0     ] o_araddr                      ,
  output [2:0                ] o_arprot                      ,

  // Read data channel
  input                        i_rvalid                      ,
  output                       o_rready                      ,
  input  [DATA_WIDTH-1:0     ] i_rdata                       ,
  input  [1:0                ] i_rresp
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
        READ_STATE_IDLE : if (i_rw_valid && i_rw_ren) read_state_reg <= READ_STATE_ADDR ;
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
        WRITE_STATE_IDLE  : if (i_rw_valid && i_rw_wen) write_state_reg <= WRITE_STATE_ADDR  ;
        WRITE_STATE_ADDR  : if (aw_fire) write_state_reg <= WRITE_STATE_WRITE ;
        WRITE_STATE_WRITE : if (w_fire ) write_state_reg <= WRITE_STATE_RESP  ;
        WRITE_STATE_RESP  : if (b_fire ) write_state_reg <= WRITE_STATE_IDLE  ;
        default           :              write_state_reg <= WRITE_STATE_IDLE  ;
      endcase
    end
  end

  // ------------------Write Transaction----------------------
  // 写地址通道
  assign o_awvalid           = w_state_addr                  ;
  assign o_awaddr            = i_rw_addr                     ;
  assign o_awprot            = `YSYX_22050710_AXI_PROT_UNPRIVILEGED_ACCESS | `YSYX_22050710_AXI_PROT_SECURE_ACCESS | `YSYX_22050710_AXI_PROT_DATA_ACCESS;  //初始化信号即可

  // 写数据通道
  assign o_wvalid            = w_state_write                 ;
  assign o_wdata             = i_rw_w_data                   ;
  assign o_wstrb             = i_rw_size                     ;

  // 写应答通道
  assign o_bready            = w_state_resp                  ;

  // ------------------Read Transaction-----------------------

  // Read address channel signals
  assign o_arvalid           = r_state_addr                  ;
  assign o_araddr            = i_rw_addr                     ;
  assign o_arprot            = `YSYX_22050710_AXI_PROT_UNPRIVILEGED_ACCESS | `YSYX_22050710_AXI_PROT_SECURE_ACCESS | `YSYX_22050710_AXI_PROT_DATA_ACCESS;  //初始化信号即可

  // Read data channel signals
  assign o_rready            = r_state_read                  ;

  assign o_rw_addr_ok        = ar_fire | w_fire              ;
  assign o_rw_data_ok        = r_fire  | b_fire              ;
  assign o_data_read         = i_rdata                       ;

endmodule
