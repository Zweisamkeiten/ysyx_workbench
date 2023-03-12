// ysyx_22050710 axi lite arbiter 2x1

module ysyx_22050710_axil_arbiter_2x1 #(
  // Width of data bus in bits
  parameter DATA_WIDTH       = 64                            ,
  // Width of address bus in bits
  parameter ADDR_WIDTH       = 32                            ,
  // Width of wstrb (width of data bus in words)
  parameter STRB_WIDTH       = (DATA_WIDTH/8)
) (
  input                        i_aclk                        ,
  input                        i_arsetn                      ,  // 低电平复位

  // ---------------------------------------------------------
  // A
  // Wirte address channel
  input                        i_a_awvalid                   ,
  output                       o_a_awready                   ,
  input  [ADDR_WIDTH-1:0     ] i_a_awaddr                    ,
  input  [2:0                ] i_a_awprot                    ,

  // Write data channel
  input                        i_a_wvalid                    ,
  output                       o_a_wready                    ,
  input  [DATA_WIDTH-1:0     ] i_a_wdata                     ,
  input  [STRB_WIDTH-1:0     ] i_a_wstrb                     ,

  // Write response channel
  output                       o_a_bvalid                    ,
  input                        i_a_bready                    ,
  output [1:0                ] o_a_bresp                     ,

  // a_Read address channel
  input                        i_a_arvalid                   ,
  output                       o_a_arready                   ,
  input  [ADDR_WIDTH-1:0     ] i_a_araddr                    ,
  input  [2:0                ] i_a_arprot                    ,

  // a_Read data channel
  output                       o_a_rvalid                    ,
  input                        i_a_rready                    ,
  output [DATA_WIDTH-1:0     ] o_a_rdata                     ,
  output [1:0                ] o_a_rresp                     ,

  // ---------------------------------------------------------
  // B
  // Wirte address channel
  input                        i_b_awvalid                   ,
  output                       o_b_awready                   ,
  input  [ADDR_WIDTH-1:0     ] i_b_awaddr                    ,
  input  [2:0                ] i_b_awprot                    ,

  // Write data channel
  input                        i_b_wvalid                    ,
  output                       o_b_wready                    ,
  input  [DATA_WIDTH-1:0     ] i_b_wdata                     ,
  input  [STRB_WIDTH-1:0     ] i_b_wstrb                     ,

  // Write response channel
  output                       o_b_bvalid                    ,
  input                        i_b_bready                    ,
  output [1:0                ] o_b_bresp                     ,

  // Read address channel
  input                        i_b_arvalid                   ,
  output                       o_b_arready                   ,
  input  [ADDR_WIDTH-1:0     ] i_b_araddr                    ,
  input  [2:0                ] i_b_arprot                    ,

  // Read data channel
  output                       o_b_rvalid                    ,
  input                        i_b_rready                    ,
  output [DATA_WIDTH-1:0     ] o_b_rdata                     ,
  output [1:0                ] o_b_rresp                     ,

  // ---------------------------------------------------------
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
  wire aw_sel                                                ; // 0 for a; 1 for b
  wire w_sel                                                 ; // 0 for a; 1 for b
  wire b_sel                                                 ; // 0 for a; 1 for b
  wire ar_sel                                                ; // 0 for a; 1 for b
  wire r_sel                                                 ; // 0 for a; 1 for b

  assign aw_sel    = ~i_a_awvalid & i_b_awvalid ? 1'b1 : 1'b0; // 优先 a
  assign w_sel     = ~i_a_wvalid  & i_b_wvalid  ? 1'b1 : 1'b0; // 优先 a
  assign b_sel     = ~i_a_bready  & i_b_bready  ? 1'b1 : 1'b0; // 优先 a
  assign ar_sel    = ~i_a_arvalid & i_b_arvalid ? 1'b1 : 1'b0; // 优先 a
  assign r_sel     = ~i_a_rready  & i_b_rready  ? 1'b1 : 1'b0; // 优先 a

  assign o_awvalid   = aw_sel ? i_b_awvalid : i_a_awvalid    ;
  assign o_a_awready = i_awready & ~aw_sel                   ;
  assign o_b_awready = i_awready &  aw_sel                   ;
  assign o_awaddr    = aw_sel ? i_b_awaddr  : i_a_awaddr     ;
  assign o_awprot    = aw_sel ? i_b_awprot  : i_a_awprot     ;

  assign o_wvalid    = w_sel  ? i_b_wvalid  : i_a_wvalid     ;
  assign o_a_wready  = i_wready & ~w_sel                     ;
  assign o_b_wready  = i_wready &  w_sel                     ;
  assign o_wdata     = w_sel  ? i_b_wdata   : i_a_wdata      ;
  assign o_wstrb     = w_sel  ? i_b_wstrb   : i_a_wstrb      ;

  assign o_a_bvalid  = i_bvalid & ~b_sel                     ;
  assign o_b_bvalid  = i_bvalid &  b_sel                     ;
  assign o_bready    = b_sel  ? i_b_bready  : i_a_bready     ;
  assign o_a_bresp   = i_bresp  & {2{~b_sel}}                ;
  assign o_b_bresp   = i_bresp  & {2{ b_sel}}                ;

  assign o_arvalid   = ar_sel ? i_b_arvalid : i_a_arvalid    ;
  assign o_a_arready = i_arready& ~ar_sel                    ;
  assign o_b_arready = i_arready&  ar_sel                    ;
  assign o_araddr    = ar_sel ? i_b_araddr  : i_a_araddr     ;
  assign o_arprot    = ar_sel ? i_b_arprot  : i_a_arprot     ;

  assign o_a_rvalid  = i_rvalid & ~r_sel                     ;
  assign o_b_rvalid  = i_rvalid &  r_sel                     ;
  assign o_rready    = r_sel ? i_b_rready   : i_a_rready     ;
  assign o_a_rdata   = i_rdata  & {DATA_WIDTH{~r_sel}}       ;
  assign o_b_rdata   = i_rdata  & {DATA_WIDTH{ r_sel}}       ;
  assign o_a_rresp   = i_rresp  & {2{~r_sel}}                ;
  assign o_b_rresp   = i_rresp  & {2{ r_sel}}                ;

endmodule
