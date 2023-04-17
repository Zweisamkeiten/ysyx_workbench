// ysyx_22050710 axi sram Wrap 以axi4-full接口封装的 sram 模块
`include "axi_defines.v"

module ysyx_22050710_axi4full_sram_wrap #(
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
  input  [3:0                ] i_awid                        ,
  input  [ADDR_WIDTH-1:0     ] i_awaddr                      ,
  input  [7:0                ] i_awlen                       ,
  input  [2:0                ] i_awsize                      ,
  input  [1:0                ] i_awburst                     ,
  input  [1:0                ] i_awlock                      ,
  input  [3:0                ] i_awcache                     ,
  input  [2:0                ] i_awprot                      ,
  input                        i_awvalid                     ,
  output                       o_awready                     ,

  // Write data channel
  input  [3:0                ] i_wid                         ,
  input  [DATA_WIDTH-1:0     ] i_wdata                       ,
  input  [STRB_WIDTH-1:0     ] i_wstrb                       ,
  input                        i_wlast                       ,
  input                        i_wvalid                      ,
  output                       o_wready                      ,

  // Write response channel
  output [3:0                ] o_bid                         ,
  output [1:0                ] o_bresp                       ,
  output                       o_bvalid                      ,
  input                        i_bready                      ,

  // Read address channel
  input  [3:0               ]  i_arid                        ,
  input  [ADDR_WIDTH-1:0    ]  i_araddr                      ,
  input  [7:0               ]  i_arlen                       ,
  input  [2:0               ]  i_arsize                      ,
  input  [1:0               ]  i_arburst                     ,
  input  [1:0               ]  i_arlock                      ,
  input  [3:0               ]  i_arcache                     ,
  input  [2:0               ]  i_arprot                      ,
  input                        i_arvalid                     ,
  output                       o_arready                     ,

  // Read data channel
  output [3:0               ]  o_rid                         ,
  output [DATA_WIDTH-1:0    ]  o_rdata                       ,
  output [1:0               ]  o_rresp                       ,
  output                       o_rlast                       ,
  output                       o_rvalid                      ,
  input                        i_rready 
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
        READ_STATE_READ : if ((|arlen == 1'b0) ? r_fire : o_rlast) read_state_reg <= READ_STATE_IDLE;
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

  wire [ADDR_WIDTH-1:0] araddr;
  Reg #(
    .WIDTH                    (ADDR_WIDTH                   ),
    .RESET_VAL                (0                            )
  ) u_ar_addr_r (
    .clk                      (i_aclk                       ),
    .rst                      (!i_arsetn || o_rlast         ),
    .din                      ((r_state_read ? araddr : i_araddr) + 32'd8),
    .dout                     (araddr                       ),
    .wen                      ((i_arvalid && (|i_arlen != 1'b0)) || r_state_read      )
  );

  wire [7:0] arlen;
  Reg #(
    .WIDTH                    (8                            ),
    .RESET_VAL                (0                            )
  ) u_arlen_r (
    .clk                      (i_aclk                       ),
    .rst                      (!i_arsetn                    ),
    .din                      (i_arlen                      ),
    .dout                     (arlen                        ),
    .wen                      (ar_fire                      )
  );

  always @(posedge i_aclk) begin
    if (ar_fire && r_state_idle) begin
      npc_pmem_read({32'b0, i_araddr}, o_rdata);
    end
    else if (r_state_read) begin
      npc_pmem_read({32'b0, araddr}, o_rdata);
    end
  end

  wire [ADDR_WIDTH-1:0] awaddr;
  Reg #(
    .WIDTH                    (ADDR_WIDTH                   ),
    .RESET_VAL                (0                            )
  ) u_aw_addr_r (
    .clk                      (i_aclk                       ),
    .rst                      (!i_arsetn                    ),
    .din                      (i_awaddr                     ),
    .dout                     (awaddr                       ),
    .wen                      (i_awvalid                    )
  );

  // write port
  always @(posedge i_aclk) begin
    if (w_state_write) begin
      npc_pmem_write({32'b0, awaddr}, i_wdata, i_wstrb);
    end
  end

  assign o_arready           = r_state_idle                  ;
  assign o_awready           = w_state_idle                  ;
  assign o_wready            = w_state_write                 ;
  assign o_bresp             = 2'b00                         ;
  assign o_rresp             = 2'b00                         ; // trans ok
  assign o_rlast             = (r_state_read && (nums_have_sent == arlen));

  wire [7:0]                   nums_have_sent                ;
  Reg #(
    .WIDTH                    (8                            ),
    .RESET_VAL                (0                            )
  ) u_nums_have_sent (
    .clk                      (i_aclk                       ),
    .rst                      (!i_arsetn || o_rlast         ),
    .din                      (nums_have_sent + 8'b1        ),
    .dout                     (nums_have_sent               ),
    .wen                      ((i_arlen != 8'b0) && (ar_fire || (r_state_read && (arlen != 8'b0)))) // TODO
  );

  assign o_rvalid = r_state_read;

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

  Reg #(
    .WIDTH                    (4                            ),
    .RESET_VAL                (0                            )
  ) u_o_bid (
    .clk                      (i_aclk                       ),
    .rst                      (!i_arsetn                    ),
    .din                      (i_awid | i_wid               ),
    .dout                     (o_bid                        ),
    .wen                      (1                            )
  );

  Reg #(
    .WIDTH                    (4                            ),
    .RESET_VAL                (0                            )
  ) u_o_rid (
    .clk                      (i_aclk                       ),
    .rst                      (!i_arsetn                    ),
    .din                      (i_arid                       ),
    .dout                     (o_rid                        ),
    .wen                      (ar_fire                      )
  );

endmodule
