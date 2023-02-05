// Burst types
`define AXI_BURST_TYPE_FIXED                                2'b00               //突发类型  FIFO
`define AXI_BURST_TYPE_INCR                                 2'b01               //ram  
`define AXI_BURST_TYPE_WRAP                                 2'b10
// Access permissions
`define AXI_PROT_UNPRIVILEGED_ACCESS                        3'b000
`define AXI_PROT_PRIVILEGED_ACCESS                          3'b001
`define AXI_PROT_SECURE_ACCESS                              3'b000
`define AXI_PROT_NON_SECURE_ACCESS                          3'b010
`define AXI_PROT_DATA_ACCESS                                3'b000
`define AXI_PROT_INSTRUCTION_ACCESS                         3'b100
// Memory types (AR)
`define AXI_ARCACHE_DEVICE_NON_BUFFERABLE                   4'b0000
`define AXI_ARCACHE_DEVICE_BUFFERABLE                       4'b0001
`define AXI_ARCACHE_NORMAL_NON_CACHEABLE_NON_BUFFERABLE     4'b0010
`define AXI_ARCACHE_NORMAL_NON_CACHEABLE_BUFFERABLE         4'b0011
`define AXI_ARCACHE_WRITE_THROUGH_NO_ALLOCATE               4'b1010
`define AXI_ARCACHE_WRITE_THROUGH_READ_ALLOCATE             4'b1110
`define AXI_ARCACHE_WRITE_THROUGH_WRITE_ALLOCATE            4'b1010
`define AXI_ARCACHE_WRITE_THROUGH_READ_AND_WRITE_ALLOCATE   4'b1110
`define AXI_ARCACHE_WRITE_BACK_NO_ALLOCATE                  4'b1011
`define AXI_ARCACHE_WRITE_BACK_READ_ALLOCATE                4'b1111
`define AXI_ARCACHE_WRITE_BACK_WRITE_ALLOCATE               4'b1011
`define AXI_ARCACHE_WRITE_BACK_READ_AND_WRITE_ALLOCATE      4'b1111
// Memory types (AW)
`define AXI_AWCACHE_DEVICE_NON_BUFFERABLE                   4'b0000
`define AXI_AWCACHE_DEVICE_BUFFERABLE                       4'b0001
`define AXI_AWCACHE_NORMAL_NON_CACHEABLE_NON_BUFFERABLE     4'b0010
`define AXI_AWCACHE_NORMAL_NON_CACHEABLE_BUFFERABLE         4'b0011
`define AXI_AWCACHE_WRITE_THROUGH_NO_ALLOCATE               4'b0110
`define AXI_AWCACHE_WRITE_THROUGH_READ_ALLOCATE             4'b0110
`define AXI_AWCACHE_WRITE_THROUGH_WRITE_ALLOCATE            4'b1110
`define AXI_AWCACHE_WRITE_THROUGH_READ_AND_WRITE_ALLOCATE   4'b1110
`define AXI_AWCACHE_WRITE_BACK_NO_ALLOCATE                  4'b0111
`define AXI_AWCACHE_WRITE_BACK_READ_ALLOCATE                4'b0111
`define AXI_AWCACHE_WRITE_BACK_WRITE_ALLOCATE               4'b1111
`define AXI_AWCACHE_WRITE_BACK_READ_AND_WRITE_ALLOCATE      4'b1111

`define AXI_SIZE_BYTES_1                                    3'b000                //突发宽度一个数据的宽度
`define AXI_SIZE_BYTES_2                                    3'b001
`define AXI_SIZE_BYTES_4                                    3'b010
`define AXI_SIZE_BYTES_8                                    3'b011
`define AXI_SIZE_BYTES_16                                   3'b100
`define AXI_SIZE_BYTES_32                                   3'b101
`define AXI_SIZE_BYTES_64                                   3'b110
`define AXI_SIZE_BYTES_128                                  3'b111


module ysyx_22050710_axi_rw # (
    parameter RW_DATA_WIDTH     = 64,
    parameter RW_ADDR_WIDTH     = 32,
    parameter AXI_DATA_WIDTH    = 64,
    parameter AXI_ADDR_WIDTH    = 32,
    parameter AXI_ID_WIDTH      = 4,
    parameter AXI_STRB_WIDTH    = AXI_DATA_WIDTH/8,
    parameter AXI_USER_WIDTH    = 1
)(
  input                               i_clock,
  input                               i_reset,

	input                               i_rw_valid,         //IF&MEM输入信号
	output                              o_rw_ready,         //IF&MEM输入信号
  output reg [RW_DATA_WIDTH-1:0]      o_data_read,        //IF&MEM输入信号
  input  [RW_DATA_WIDTH-1:0]          i_rw_w_data,        //IF&MEM输入信号
  input  [RW_ADDR_WIDTH-1:0]          i_rw_addr,          //IF&MEM输入信号
  input  [7:0]                        i_rw_size,          //IF&MEM输入信号



  // Advanced eXtensible Interface
  input                               i_axi_aw_ready,              
  output                              o_axi_aw_valid,
  output [AXI_ADDR_WIDTH-1:0]         o_axi_aw_addr,
  output [2:0]                        o_axi_aw_prot,
  output [AXI_ID_WIDTH-1:0]           o_axi_aw_id,
  output [AXI_USER_WIDTH-1:0]         o_axi_aw_user,
  output [7:0]                        o_axi_aw_len,
  output [2:0]                        o_axi_aw_size,
  output [1:0]                        o_axi_aw_burst,
  output                              o_axi_aw_lock,
  output [3:0]                        o_axi_aw_cache,
  output [3:0]                        o_axi_aw_qos,
  output [3:0]                        o_axi_aw_region,

  input                               i_axi_w_ready,                
  output                              o_axi_w_valid,
  output [AXI_DATA_WIDTH-1:0]         o_axi_w_data,
  output [AXI_DATA_WIDTH/8-1:0]       o_axi_w_strb,
  output                              o_axi_w_last,
  output [AXI_USER_WIDTH-1:0]         o_axi_w_user,
  
  output                              o_axi_b_ready,                
  input                               i_axi_b_valid,
  input  [1:0]                        i_axi_b_resp,                 
  input  [AXI_ID_WIDTH-1:0]           i_axi_b_id,
  input  [AXI_USER_WIDTH-1:0]         i_axi_b_user,

  input                               i_axi_ar_ready,                
  output                              o_axi_ar_valid,
  output [AXI_ADDR_WIDTH-1:0]         o_axi_ar_addr,
  output [2:0]                        o_axi_ar_prot,
  output [AXI_ID_WIDTH-1:0]           o_axi_ar_id,
  output [AXI_USER_WIDTH-1:0]         o_axi_ar_user,
  output [7:0]                        o_axi_ar_len,
  output [2:0]                        o_axi_ar_size,
  output [1:0]                        o_axi_ar_burst,
  output                              o_axi_ar_lock,
  output [3:0]                        o_axi_ar_cache,
  output [3:0]                        o_axi_ar_qos,
  output [3:0]                        o_axi_ar_region,
  
  output                              o_axi_r_ready,                 
  input                               i_axi_r_valid,                
  input  [1:0]                        i_axi_r_resp,
  input  [AXI_DATA_WIDTH-1:0]         i_axi_r_data,
  input                               i_axi_r_last,
  input  [AXI_ID_WIDTH-1:0]           i_axi_r_id,
  input  [AXI_USER_WIDTH-1:0]         i_axi_r_user
);
    
  // ------------------State Machine------------------TODO
  localparam [1:0]
    READ_STATE_IDLE = 2'd0,
    READ_STATE_ADDR = 2'd1;
    READ_STATE_READ = 2'd2;

  reg [1:0] read_state_reg = READ_STATE_IDLE, read_state_next;
  wire r_state_addr = read_state_reg == READ_STATE_ADDR;
  wire r_state_read = read_state_reg == READ_STATE_READ;

  localparam [1:0]
    WRITE_STATE_IDLE  = 2'd0,
    WRITE_STATE_ADDR  = 2'd1,
    WRITE_STATE_WRITE = 2'd2,
    WRITE_STATE_RESP  = 2'd3;

  reg [1:0] write_state_reg = WRITE_STATE_IDLE, write_state_next;
  wire w_state_addr = write_state_reg == WRITE_STATE_ADDR;
  wire w_state_data = write_state_reg == WRITE_STATE_WRITE;
  wire w_state_resp = write_state_reg == WRITE_STATE_RESP;
  
  // 写通道状态切换
  always @(posedge i_clock) begin
    if (i_reset == 0) begin
      write_state_next <= 2'd0;
    end
    else begin
      case (write_state_reg)
        WRITE_STATE_IDLE: begin
          write_state_next <= WRITE_STATE_ADDR
        end
      endcase
    end
  end
    

   // 读通道状态切换
  

  // ------------------Write Transaction------------------
  parameter AXI_SIZE        = $clog2(AXI_DATA_WIDTH / 8);
  wire [AXI_ID_WIDTH-1:0] axi_id              = {AXI_ID_WIDTH{1'b0}};
  wire [AXI_USER_WIDTH-1:0] axi_user          = {AXI_USER_WIDTH{1'b0}};
  wire [7:0] axi_len        =  8'b0 ;
  wire [2:0] axi_size       = AXI_SIZE[2:0];
  // 写地址通道  以下没有备注初始化信号的都可能是你需要产生和用到的
  assign o_axi_aw_valid     = w_state_addr;
  assign o_axi_aw_addr      = i_rw_addr;
  assign o_axi_aw_prot      = `AXI_PROT_UNPRIVILEGED_ACCESS | `AXI_PROT_SECURE_ACCESS | `AXI_PROT_DATA_ACCESS;  //初始化信号即可
  assign o_axi_aw_id        = axi_id;                                                                           //初始化信号即可
  assign o_axi_aw_user      = axi_user;                                                                         //初始化信号即可
  assign o_axi_aw_len       = axi_len;
  assign o_axi_aw_size      = axi_size;
  assign o_axi_aw_burst     = `AXI_BURST_TYPE_INCR;                                                             
  assign o_axi_aw_lock      = 1'b0;                                                                             //初始化信号即可
  assign o_axi_aw_cache     = `AXI_AWCACHE_WRITE_BACK_READ_AND_WRITE_ALLOCATE;                                  //初始化信号即可
  assign o_axi_aw_qos       = 4'h0;                                                                             //初始化信号即可
  assign o_axi_aw_region    = 4'h0;                                                                             //初始化信号即可

  // 写数据通道
  assign o_axi_w_valid      = w_state_write;
  assign o_axi_w_data       = i_rw_w_data ;
  assign o_axi_w_strb       = i_rw_size;
  assign o_axi_w_last       = 1'b0;
  assign o_axi_w_user       = axi_user;                                                                         //初始化信号即可

  // 写应答通道
  assign o_axi_b_ready      = w_state_resp;

  // ------------------Read Transaction------------------

  // Read address channel signals
  assign o_axi_ar_valid     = r_state_addr;
  assign o_axi_ar_addr      = i_rw_addr;
  assign o_axi_ar_prot      = `AXI_PROT_UNPRIVILEGED_ACCESS | `AXI_PROT_SECURE_ACCESS | `AXI_PROT_DATA_ACCESS;  //初始化信号即可
  assign o_axi_ar_id        = axi_id;                                                                           //初始化信号即可                        
  assign o_axi_ar_user      = axi_user;                                                                         //初始化信号即可
  assign o_axi_ar_len       = axi_len;                                                                          
  assign o_axi_ar_size      = axi_size;
  assign o_axi_ar_burst     = `AXI_BURST_TYPE_INCR;
  assign o_axi_ar_lock      = 1'b0;                                                                             //初始化信号即可
  assign o_axi_ar_cache     = `AXI_ARCACHE_NORMAL_NON_CACHEABLE_NON_BUFFERABLE;                                 //初始化信号即可
  assign o_axi_ar_qos       = 4'h0;                                                                             //初始化信号即可

  // Read data channel signals
  assign o_axi_r_ready      = r_state_read;

endmodule
