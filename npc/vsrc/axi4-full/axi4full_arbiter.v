// ysyx_22050710 axi4-full arbiter 2x1

module ysyx_22050710_axi4full_arbiter_2x1 #(
  // Width of data bus in bits
  parameter DATA_WIDTH       = 64                            ,
  // Width of address bus in bits
  parameter ADDR_WIDTH       = 32                            ,
  // Width of wstrb (width of data bus in words)
  parameter STRB_WIDTH       = (DATA_WIDTH/8)
) (
  input                        i_aclk                        ,
  input                        i_arsetn                      ,  // 低电平复位

  // Wirte address channel
  input  [ADDR_WIDTH-1:0     ] i_a_awaddr                    ,
  input  [7:0                ] i_a_awlen                     ,
  input  [1:0                ] i_a_awsize                    ,
  input  [1:0                ] i_a_awburst                   ,
  input  [1:0                ] i_a_awlock                    ,
  input  [3:0                ] i_a_awcache                   ,
  input  [2:0                ] i_a_awprot                    ,
  input                        i_a_awvalid                   ,
  output                       o_a_awready                   ,

  // A Write data channel
  input  [DATA_WIDTH-1:0     ] i_a_wdata                     ,
  input  [STRB_WIDTH-1:0     ] i_a_wstrb                     ,
  input                        i_a_wlast                     ,
  input                        i_a_wvalid                    ,
  output                       o_a_wready                    ,

  // A Write response channe
  output [1:0                ] o_a_bresp                     ,
  output                       o_a_bvalid                    ,
  input                        i_a_bready                    ,

  // A Read address channel
  input  [ADDR_WIDTH-1:0     ] i_a_araddr                    ,
  input  [7:0                ] i_a_arlen                     ,
  input  [1:0                ] i_a_arsize                    ,
  input  [1:0                ] i_a_arburst                   ,
  input  [1:0                ] i_a_arlock                    ,
  input  [3:0                ] i_a_arcache                   ,
  input  [2:0                ] i_a_arprot                    ,
  input                        i_a_arvalid                   ,
  output                       o_a_arready                   ,

  // A Read data channel
  output [DATA_WIDTH-1:0     ] o_a_rdata                     ,
  output [1:0                ] o_a_rresp                     ,
  output                       o_a_rlast                     ,
  output                       o_a_rvalid                    ,
  input                        i_a_rready                    ,

  // -----------------------
  // B
  // Wirte address channel
  input  [ADDR_WIDTH-1:0     ] i_b_awaddr                    ,
  input  [7:0                ] i_b_awlen                     ,
  input  [1:0                ] i_b_awsize                    ,
  input  [1:0                ] i_b_awburst                   ,
  input  [1:0                ] i_b_awlock                    ,
  input  [3:0                ] i_b_awcache                   ,
  input  [2:0                ] i_b_awprot                    ,
  input                        i_b_awvalid                   ,
  output                       o_b_awready                   ,

  // B Write data channel
  input  [DATA_WIDTH-1:0     ] i_b_wdata                     ,
  input  [STRB_WIDTH-1:0     ] i_b_wstrb                     ,
  input                        i_b_wlast                     ,
  input                        i_b_wvalid                    ,
  output                       o_b_wready                    ,

  // B Write response channe
  output [1:0                ] o_b_bresp                     ,
  output                       o_b_bvalid                    ,
  input                        i_b_bready                    ,

  // B Read address channel
  input  [ADDR_WIDTH-1:0     ] i_b_araddr                    ,
  input  [7:0                ] i_b_arlen                     ,
  input  [1:0                ] i_b_arsize                    ,
  input  [1:0                ] i_b_arburst                   ,
  input  [1:0                ] i_b_arlock                    ,
  input  [3:0                ] i_b_arcache                   ,
  input  [2:0                ] i_b_arprot                    ,
  input                        i_b_arvalid                   ,
  output                       o_b_arready                   ,

  // B Read data channel
  output [DATA_WIDTH-1:0     ] o_b_rdata                     ,
  output [1:0                ] o_b_rresp                     ,
  output                       o_b_rlast                     ,
  output                       o_b_rvalid                    ,
  input                        i_b_rready                    ,

  // -----------------------
  // Wirte address channel
  output [3:0                ] o_awid                        ,
  output [ADDR_WIDTH-1:0     ] o_awaddr                      ,
  output [7:0                ] o_awlen                       ,
  output [1:0                ] o_awsize                      ,
  output [1:0                ] o_awburst                     ,
  output [1:0                ] o_awlock                      ,
  output [3:0                ] o_awcache                     ,
  output [2:0                ] o_awprot                      ,
  output                       o_awvalid                     ,
  input                        i_awready                     ,

  // Write data channel
  output [3:0                ] o_wid                         ,
  output [DATA_WIDTH-1:0     ] o_wdata                       ,
  output [STRB_WIDTH-1:0     ] o_wstrb                       ,
  output                       o_wlast                       ,
  output                       o_wvalid                      ,
  input                        i_wready                      ,

  // Write response channel
  input  [3:0                ] i_bid                         ,
  input  [1:0                ] i_bresp                       ,
  input                        i_bvalid                      ,
  output                       o_bready                      ,

  // Read address channel
  output [3:0                ] o_arid                        ,
  output [ADDR_WIDTH-1:0     ] o_araddr                      ,
  output [7:0                ] o_arlen                       ,
  output [1:0                ] o_arsize                      ,
  output [1:0                ] o_arburst                     ,
  output [1:0                ] o_arlock                      ,
  output [3:0                ] o_arcache                     ,
  output [2:0                ] o_arprot                      ,
  output                       o_arvalid                     ,
  input                        i_arready                     ,

  // Read data channel
  input  [3:0                ] i_rid                         ,
  input  [DATA_WIDTH-1:0     ] i_rdata                       ,
  input  [1:0                ] i_rresp                       ,
  input                        i_rlast                       ,
  input                        i_rvalid                      ,
  output                       o_rready
);
  wire aw_sel                                                ; // 0 for a; 1 for b
  wire w_sel                                                 ; // 0 for a; 1 for b
  wire b_sel                                                 ; // 0 for a; 1 for b
  wire ar_sel                                                ; // 0 for a; 1 for b
  wire r_sel                                                 ; // 0 for a; 1 for b

  assign aw_sel    = ~i_a_awvalid & i_b_awvalid ? 1'b1 : 1'b0; // 优先 a
  assign w_sel     = ~i_a_wvalid  & i_b_wvalid  ? 1'b1 : 1'b0; // 优先 a
  assign b_sel     = i_bid[0]                                ;
  assign ar_sel    = ~i_a_arvalid & i_b_arvalid ? 1'b1 : 1'b0; // 优先 a
  assign r_sel     = i_rid[0]                                ;

  assign o_awid      = aw_sel ? 4'b1        : 4'b0           ; // 固定为 1, 即写数
  assign o_awvalid   = aw_sel ? i_b_awvalid : i_a_awvalid    ;
  assign o_a_awready = i_awready & ~aw_sel                   ;
  assign o_b_awready = i_awready &  aw_sel                   ;
  assign o_awaddr    = aw_sel ? i_b_awaddr  : i_a_awaddr     ;
  assign o_awprot    = aw_sel ? i_b_awprot  : i_a_awprot     ;
  assign o_awlen     = aw_sel ? i_b_awlen   : i_a_awlen      ;
  assign o_awsize    = aw_sel ? i_b_awsize  : i_a_awsize     ;
  assign o_awburst   = aw_sel ? i_b_awburst : i_a_awburst    ;
  assign o_awlock    = aw_sel ? i_b_awlock  : i_a_awlock     ;
  assign o_awcache   = aw_sel ? i_b_awcache : i_a_awcache    ;

  assign o_wid       = w_sel  ? 4'b1        : 4'b0           ; // 固定为 1, 即写数
  assign o_wvalid    = w_sel  ? i_b_wvalid  : i_a_wvalid     ;
  assign o_a_wready  = i_wready & ~w_sel                     ;
  assign o_b_wready  = i_wready &  w_sel                     ;
  assign o_wdata     = w_sel  ? i_b_wdata   : i_a_wdata      ;
  assign o_wstrb     = w_sel  ? i_b_wstrb   : i_a_wstrb      ;
  assign o_wlast     = w_sel  ? i_b_wlast   : i_a_wlast      ;

  assign o_a_bvalid  = i_bvalid & ~b_sel                     ;
  assign o_b_bvalid  = i_bvalid &  b_sel                     ;
  assign o_bready    = b_sel  ? i_b_bready  : i_a_bready     ;
  assign o_a_bresp   = i_bresp  & {2{~b_sel}}                ;
  assign o_b_bresp   = i_bresp  & {2{ b_sel}}                ;

  assign o_arid      = ar_sel ? 4'b1        : 4'b0           ; // 取指置为 0; 取数置为 1;
  assign o_arvalid   = ar_sel ? i_b_arvalid : i_a_arvalid    ;
  assign o_a_arready = i_arready& ~ar_sel                    ;
  assign o_b_arready = i_arready&  ar_sel                    ;
  assign o_araddr    = ar_sel ? i_b_araddr  : i_a_araddr     ;
  assign o_arprot    = ar_sel ? i_b_arprot  : i_a_arprot     ;
  assign o_arlen     = ar_sel ? i_b_arlen   : i_a_arlen      ;
  assign o_arsize    = ar_sel ? i_b_arsize  : i_a_arsize     ;
  assign o_arburst   = ar_sel ? i_b_arburst : i_a_arburst    ;
  assign o_arlock    = ar_sel ? i_b_arlock  : i_a_arlock     ;
  assign o_arcache   = ar_sel ? i_b_arcache : i_a_arcache    ;

  assign o_a_rvalid  = i_rvalid & ~r_sel                     ;
  assign o_b_rvalid  = i_rvalid &  r_sel                     ;
  assign o_rready    = r_sel ? i_b_rready   : i_a_rready     ;
  assign o_a_rdata   = i_rdata  & {DATA_WIDTH{~r_sel}}       ;
  assign o_b_rdata   = i_rdata  & {DATA_WIDTH{ r_sel}}       ;
  assign o_a_rresp   = i_rresp  & {2{~r_sel}}                ;
  assign o_b_rresp   = i_rresp  & {2{ r_sel}}                ;
  assign o_a_rlast   = i_rlast  & ~r_sel                     ;
  assign o_b_rlast   = i_rlast  &  r_sel                     ;

endmodule
