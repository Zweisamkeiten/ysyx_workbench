// ysyx_22050710 axi lite Wrap 以axi-lite接口封装的inst sram 模块
`include "axi_defines.v"

module ysyx_22050710_axil_data_sram_wrap #(
  // Width of data bus in bits
  parameter DATA_WIDTH       = 64                            ,
  // Width of address bus in bits
  parameter ADDR_WIDTH       = 32                            ,
  // Width of wstrb (width of data bus in words)
  parameter STRB_WIDTH       = (DATA_WIDTH/8)                ,
  parameter SRAM_ADDR_WD                                     ,
  parameter SRAM_WMASK_WD                                    ,
  parameter SRAM_DATA_WD
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
  output [DATA_WIDTH-1:0     ] o_rdata                       ,
  output [1:0                ] o_rresp
);

  reg awready_reg            = 1'b0, awready_next            ;
  reg wready_reg             = 1'b0, wready_next             ;
  reg bvalid_reg             = 1'b0, bvalid_next             ;
  reg arready_reg            = 1'b0, arready_next            ;
  reg rvalid_reg             = 1'b0, rvalid_next             ;

  assign o_awready           = awready_reg                   ;
  assign o_wready            = wready_reg                    ;
  assign o_bresp             = 2'b00                         ;
  assign o_bvalid            = bvalid_reg                    ;
  assign o_arready           = arready_reg                   ;
  assign o_rresp             = 2'b00                         ;
  assign o_rvalid            = rvalid_reg                    ;

  reg mem_wr_en;
  reg mem_rd_en;

  always @(*) begin
    mem_wr_en = 1'b0;

    awready_next = 1'b0;
    wready_next = 1'b0;
    bvalid_next = bvalid_reg && !i_bready;

    if (i_awvalid && i_wvalid && (!o_bvalid || i_bready) && (!o_awready && !o_wready)) begin
      awready_next = 1'b1;
      wready_next = 1'b1;
      bvalid_next = 1'b1;

      mem_wr_en = 1'b1;
    end
  end

  always @(posedge i_aclk) begin
    if (rst) begin
      awready_reg <= 1'b0;
      wready_reg <= 1'b0;
      bvalid_reg <= 1'b0;
    end
    else begin
      awready_reg <= awready_next;
      wready_reg <= wready_next;
      bvalid_reg <= bvalid_next;
    end
  end

  always @(*) begin
    mem_rd_en = 1'b0;

    arready_next = 1'b0;

    if (i_arvalid && (!o_rvalid || i_rready) && (!o_arready)) begin
      arready_next = 1'b1;
      rvalid_next = 1'b1;

      mem_rd_en = 1'b1;
    end
  end

  always @(posedge i_aclk) begin
    if (rst) begin
      arready_reg <= 1'b0;
      rvalid_reg <= 1'b0;
    end
    else begin
      arready_reg <= arready_next;
      rvalid_reg <= rvalid_next;
    end
  end

  ysyx_22050710_data_sram #(
    .SRAM_ADDR_WD            (SRAM_ADDR_WD                  ),
    .SRAM_WMASK_WD           (SRAM_WMASK_WD                 ),
    .SRAM_DATA_WD            (SRAM_DATA_WD                  )
  ) u_data_ram (
    .i_clk                   (i_aclk                        ),
    .i_addr                  (i_awaddr | i_araddr           ),
    .i_ren                   (mem_rd_en                     ),
    .o_rdata                 (o_rdata                       ),  //63:0
    .i_wen                   (mem_wr_en                     ),
    .i_wmask                 (i_wstrb                       ),
    .i_wdata                 (i_wdata                       )   // 63:0
  );

endmodule
