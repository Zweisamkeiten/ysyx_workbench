// ysyx_22050710 axi lite Wrap 以axi-lite接口封装的inst sram 模块
`include "axi_defines.v"

module ysyx_22050710_axil_inst_sram_wrap #(
  // Width of data bus in bits
  parameter DATA_WIDTH       = 64                            ,
  // Width of address bus in bits
  parameter ADDR_WIDTH       = 32                            ,
  // Width of wstrb (width of data bus in words)
  parameter STRB_WIDTH       = (DATA_WIDTH/8)
) (
  input                        i_aclk                        ,
  input                        i_arsetn                      ,

  // Wirte address channel
  input                        i_awvalid                     ,
  output                       o_awready                     ,
  input  [ADDR_WIDTH-1:0     ] i_awaddr                      ,
  input  [2:0                ] i_awprot                      , // define the access permission for write accesses.

  // Write data channel
  input                        i_wvalid                      ,
  output                       o_wready                      ,
  input  [DATA_WIDTH-1:0     ] i_wdata                       ,
  input  [STRB_WIDTH-1:0     ] i_wstrb                       ,

  // Write response channel
  output                       o_bvalid                      ,
  input                        i_bready                      ,
  output [1:0                ] o_bresp                       ,

  // Read address channel
  input                        i_arvalid                     ,
  output                       o_arready                     ,
  input  [ADDR_WIDTH-1:0     ] i_araddr                      ,
  input  [2:0                ] i_arprot                      ,

  // Read data channel
  output reg                   o_rvalid                      ,
  input                        i_rready                      ,
  output reg [DATA_WIDTH-1:0 ] o_rdata                       ,
  output [1:0                ] o_rresp
);
  // ---------------------------------------------------------
  wire ar_fire                                               ;
  wire r_fire                                                ;

  // --------------------------------------------------------
  assign ar_fire             = i_arvalid & o_arready         ;
  assign r_fire              = i_rready  & o_rvalid          ;

  // ------------------State Machine--------------------------
  localparam [1:0]
      READ_STATE_IDLE        = 2'd0                          ,
      READ_STATE_ADDR        = 2'd1                          ,
      READ_STATE_READ        = 2'd2                          ;

  reg [1:0] read_state_reg   = READ_STATE_IDLE;

  wire r_state_idle          = read_state_reg == READ_STATE_IDLE  ;
  wire r_state_addr          = read_state_reg == READ_STATE_ADDR  ;
  wire r_state_read          = read_state_reg == READ_STATE_READ  ;

  assign o_arready           = r_state_addr;
  assign o_rvalid            = rvalid;
  assign o_awready           = 0;
  assign o_wready            = 0;
  assign o_bvalid            = 0;
  assign o_bresp             = 0;
  assign o_rresp             = 0;

  // 读通道状态切换
  always @(posedge i_aclk) begin
    if (~i_arsetn) begin
      read_state_reg <= READ_STATE_IDLE;
    end
    else begin
      case (read_state_reg)
        READ_STATE_IDLE : if (i_arvalid) read_state_reg <= READ_STATE_ADDR ;
        READ_STATE_ADDR : if (ar_fire  ) read_state_reg <= READ_STATE_READ ;
        READ_STATE_READ : if (r_fire   ) read_state_reg <= READ_STATE_IDLE ;
        default         :                read_state_reg <= READ_STATE_IDLE ;
      endcase
    end
  end

  reg [DATA_WIDTH-1:0] rdata;
  always @(*) begin
    if (r_state_read) begin
      npc_pmem_read({32'b0, i_araddr}, rdata);
    end
    else begin
      rdata = 0;
    end
  end

  reg [0:0] rvalid = 0;
  always @(posedge i_aclk) begin
    if (r_state_read) begin
      o_rdata <= rdata;
      rvalid <= 1;
    end
    else begin
      o_rdata <= 0;
      rvalid <= 0;
    end
  end

endmodule
