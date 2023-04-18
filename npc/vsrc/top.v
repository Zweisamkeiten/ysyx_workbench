// ysyx_22050710 TOP
`include "defines.v"

import "DPI-C" function void npc_pmem_read(input longint raddr, output longint rdata);
import "DPI-C" function void npc_pmem_write(input longint waddr, input longint wdata, input byte wmask);

module ysyx_22050710_top #(
  parameter WORD_WD          = `ysyx_22050710_WORD_WD        ,
  parameter PC_RESETVAL      = `ysyx_22050710_PC_RESETVAL    ,
  parameter PC_WD            = `ysyx_22050710_PC_WD          ,
  parameter GPR_WD           = `ysyx_22050710_GPR_WD         ,
  parameter GPR_ADDR_WD      = `ysyx_22050710_GPR_ADDR_WD    ,
  parameter IMM_WD           = `ysyx_22050710_IMM_WD         ,
  parameter CSR_WD           = `ysyx_22050710_CSR_WD         ,
  parameter CSR_ADDR_WD      = `ysyx_22050710_CSR_ADDR_WD    ,
  parameter INST_WD          = `ysyx_22050710_INST_WD        ,
  parameter SRAM_ADDR_WD     = `ysyx_22050710_SRAM_ADDR_WD   ,
  parameter SRAM_WMASK_WD    = `ysyx_22050710_SRAM_WMASK_WD  ,
  parameter SRAM_DATA_WD     = `ysyx_22050710_SRAM_DATA_WD
) (
  input                        i_clk                         ,
  input                        i_rst
);

  parameter STRB_WIDTH      = (SRAM_DATA_WD/8)               ;

  // Wirte address channel
  wire [3:0                  ] awid                          ;
  wire [SRAM_ADDR_WD-1:0     ] awaddr                        ;
  wire [2:0                  ] awprot                        ; // define the access permission for write accesses.
  wire [7:0                  ] awlen                         ;
  wire [2:0                  ] awsize                        ;
  wire [1:0                  ] awburst                       ;
  wire [1:0                  ] awlock                        ;
  wire [3:0                  ] awcache                       ;
  wire                         awvalid                       ;
  wire                         awready                       ;

  // Write data channel
  wire [3:0                  ] wid                           ;
  wire [SRAM_DATA_WD-1:0     ] wdata                         ;
  wire [STRB_WIDTH-1:0       ] wstrb                         ;
  wire                         wlast                         ;
  wire                         wvalid                        ;
  wire                         wready                        ;

  // Write response channel
  wire [3:0                  ] bid                           ;
  wire [1:0                  ] bresp                         ;
  wire                         bvalid                        ;
  wire                         bready                        ;

  // Read address channel
  wire [3:0                  ] arid                          ;
  wire [SRAM_ADDR_WD-1:0     ] araddr                        ;
  wire [7:0                  ] arlen                         ;
  wire [2:0                  ] arsize                        ;
  wire [1:0                  ] arburst                       ;
  wire [1:0                  ] arlock                        ;
  wire [3:0                  ] arcache                       ;
  wire [2:0                  ] arprot                        ;
  wire                         arvalid                       ;
  wire                         arready                       ;

  // Read data channel
  wire [3:0                  ] rid                           ;
  wire [SRAM_DATA_WD-1:0     ] rdata                         ;
  wire [1:0                  ] rresp                         ;
  wire                         rlast                         ;
  wire                         rvalid                        ;
  wire                         rready                        ;

  // --------------------------------------------------------

  ysyx_22050710_cpu_top #(
    .WORD_WD                  (WORD_WD                      ),
    .PC_RESETVAL              (PC_RESETVAL                  ),
    .PC_WD                    (PC_WD                        ),
    .GPR_WD                   (GPR_WD                       ),
    .GPR_ADDR_WD              (GPR_ADDR_WD                  ),
    .IMM_WD                   (IMM_WD                       ),
    .CSR_WD                   (CSR_WD                       ),
    .CSR_ADDR_WD              (CSR_ADDR_WD                  ),
    .INST_WD                  (INST_WD                      ),
    .SRAM_ADDR_WD             (SRAM_ADDR_WD                 ),
    .SRAM_WMASK_WD            (SRAM_WMASK_WD                ),
    .SRAM_DATA_WD             (SRAM_DATA_WD                 )
  ) u_cpu_top (
    .i_aclk                   (i_clk                        ),
    .i_arsetn                 (~i_rst                       ),

    // Wirte address channel
    .o_awid                   (awid                         ),
    .o_awaddr                 (awaddr                       ),
    .o_awlen                  (awlen                        ),
    .o_awsize                 (awsize                       ),
    .o_awburst                (awburst                      ),
    .o_awlock                 (awlock                       ),
    .o_awcache                (awcache                      ),
    .o_awprot                 (awprot                       ), // define the access permission for write accesses.
    .o_awvalid                (awvalid                      ),
    .i_awready                (awready                      ),

    // Write data channel
    .o_wid                    (wid                          ),
    .o_wdata                  (wdata                        ),
    .o_wstrb                  (wstrb                        ),
    .o_wlast                  (wlast                        ),
    .o_wvalid                 (wvalid                       ),
    .i_wready                 (wready                       ),

    // Write response channel
    .i_bid                    (bid                          ),
    .i_bresp                  (bresp                        ),
    .i_bvalid                 (bvalid                       ),
    .o_bready                 (bready                       ),

    // Read address channel
    .o_arid                   (arid                         ),
    .o_araddr                 (araddr                       ),
    .o_arlen                  (arlen                        ),
    .o_arsize                 (arsize                       ),
    .o_arburst                (arburst                      ),
    .o_arlock                 (arlock                       ),
    .o_arcache                (arcache                      ),
    .o_arprot                 (arprot                       ),
    .o_arvalid                (arvalid                      ),
    .i_arready                (arready                      ),

    // Read data channel
    .i_rid                    (rid                          ),
    .i_rdata                  (rdata                        ),
    .i_rresp                  (rresp                        ),
    .i_rlast                  (rlast                        ),
    .i_rvalid                 (rvalid                       ),
    .o_rready                 (rready                       )
  );

  // axi4-full sram
  ysyx_22050710_axi4full_sram_wrap #(
  ) u_sram_wrap (
    .i_aclk                   (i_clk                        ),
    .i_arsetn                 (~i_rst                       ),

    // Wirte address channel
    .i_awid                   (awid                         ),
    .i_awaddr                 (awaddr                       ),
    .i_awlen                  (awlen                        ),
    .i_awsize                 (awsize                       ),
    .i_awburst                (awburst                      ),
    .i_awlock                 (awlock                       ),
    .i_awcache                (awcache                      ),
    .i_awprot                 (awprot                       ), // define the access permission for write accesses.
    .i_awvalid                (awvalid                      ),
    .o_awready                (awready                      ),

    // Write data channel
    .i_wid                    (wid                          ),
    .i_wdata                  (wdata                        ),
    .i_wstrb                  (wstrb                        ),
    .i_wlast                  (wlast                        ),
    .i_wvalid                 (wvalid                       ),
    .o_wready                 (wready                       ),

    // Write response channel
    .o_bid                    (bid                          ),
    .o_bresp                  (bresp                        ),
    .o_bvalid                 (bvalid                       ),
    .i_bready                 (bready                       ),

    // Read address channel
    .i_arid                   (arid                         ),
    .i_araddr                 (araddr                       ),
    .i_arlen                  (arlen                        ),
    .i_arsize                 (arsize                       ),
    .i_arburst                (arburst                      ),
    .i_arlock                 (arlock                       ),
    .i_arcache                (arcache                      ),
    .i_arprot                 (arprot                       ),
    .i_arvalid                (arvalid                      ),
    .o_arready                (arready                      ),

    // Read data channel
    .o_rid                    (rid                          ),
    .o_rdata                  (rdata                        ),
    .o_rresp                  (rresp                        ),
    .o_rlast                  (rlast                        ),
    .o_rvalid                 (rvalid                       ),
    .i_rready                 (rready                       )
  );

endmodule
