// ysyx_22050710 axi data Wrap 以axi-lite接口封装的 data sram 模块
`include "axi_defines.v"

module ysyx_22050710_axil_data_sram_wrap #(
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
  output                       o_rvalid                      ,
  input                        i_rready                      ,
  output reg [DATA_WIDTH-1:0 ] o_rdata                       ,
  output [1:0                ] o_rresp
);
  // ---------------------------------------------------------
  wire aw_fire                                               ;
  wire w_fire                                                ;
  wire b_fire                                                ;
  wire ar_fire                                               ;
  wire r_fire                                                ;

  // --------------------------------------------------------
  assign aw_fire             = i_awvalid & o_awready         ;
  assign w_fire              = i_wvalid  & o_wready          ;
  assign b_fire              = i_bready  & o_bvalid          ;
  assign ar_fire             = i_arvalid & o_arready         ;
  assign r_fire              = i_rready  & o_rvalid          ;

  // ------------------State Machine--------------------------
  localparam [0:0]
      READ_STATE_IDLE        = 1'd0                          ,
      READ_STATE_READ        = 1'd1                          ;

  reg [0:0] read_state_reg   = READ_STATE_IDLE               ;

  wire r_state_idle     = read_state_reg == READ_STATE_IDLE  ;
  wire r_state_read     = read_state_reg == READ_STATE_READ  ;

  // 读通道状态切换
  always @(posedge i_aclk) begin
    if (~i_arsetn) begin
      read_state_reg <= READ_STATE_IDLE;
    end
    else begin
      case (read_state_reg)
        READ_STATE_IDLE : if (ar_fire) read_state_reg <= READ_STATE_READ;
        READ_STATE_READ : if (r_fire ) read_state_reg <= READ_STATE_IDLE;
        default         :              read_state_reg <= read_state_reg ;
      endcase
    end
  end

  localparam [1:0]
      WRITE_STATE_IDLE       = 2'd0                          ,
      WRITE_STATE_WRITE      = 2'd1                          ,
      WRITE_STATE_RESP       = 2'd2                          ;

  reg [1:0] write_state_reg  = WRITE_STATE_IDLE;

  wire w_state_idle   = write_state_reg == WRITE_STATE_IDLE  ;
  wire w_state_write  = write_state_reg == WRITE_STATE_WRITE ;
  wire w_state_resp   = write_state_reg == WRITE_STATE_RESP  ;

  // 写通道状态切换
  always @(posedge i_aclk) begin
    if (~i_arsetn) begin
      write_state_reg <= WRITE_STATE_IDLE;
    end
    else begin
      case (write_state_reg)
        WRITE_STATE_IDLE  : if (aw_fire) write_state_reg <= WRITE_STATE_WRITE;
        WRITE_STATE_WRITE : if (w_fire ) write_state_reg <= WRITE_STATE_RESP ;
        WRITE_STATE_RESP  : if (b_fire ) write_state_reg <= WRITE_STATE_IDLE ;
        default           :              write_state_reg <= write_state_reg  ;
      endcase
    end
  end

  reg [DATA_WIDTH-1:0] rdata;
  always @(*) begin
    if (ar_fire) begin
      npc_pmem_read({32'b0, i_araddr}, rdata);
    end
    else begin
      rdata = 0;
    end
  end

  // write port
  always @(posedge i_aclk) begin
    if (aw_fire) begin
      npc_pmem_write({32'b0, i_awaddr}, i_wdata, i_wstrb);
    end
  end

  Reg #(
    .WIDTH                    (DATA_WIDTH                   ),
    .RESET_VAL                (0                            )
  ) u_o_rdata (
    .clk                      (i_aclk                       ),
    .rst                      (!i_arsetn                    ),
    .din                      (rdata                        ),
    .dout                     (o_rdata                      ),
    .wen                      (ar_fire                      )
  );

  assign o_arready           = r_state_idle                  ;
  assign o_awready           = w_state_idle                  ;
  assign o_wready            = w_state_write                 ;
  assign o_bresp             = 2'b00                         ;
  assign o_rresp             = 2'b00                         ; // trans ok

  Reg #(
    .WIDTH                    (1                            ),
    .RESET_VAL                (0                            )
  ) u_o_rvalid (
    .clk                      (i_aclk                       ),
    .rst                      (!i_arsetn                    ),
    .din                      (ar_fire                      ),
    .dout                     (o_rvalid                     ),
    .wen                      (1                            )
  );

  Reg #(
    .WIDTH                    (1                            ),
    .RESET_VAL                (0                            )
  ) u_o_bvalid (
    .clk                      (i_aclk                       ),
    .rst                      (!i_arsetn                    ),
    .din                      (w_fire                       ),
    .dout                     (o_bvalid                     ),
    .wen                      (1                            )
  );

endmodule
