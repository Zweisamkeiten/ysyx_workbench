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
  wire                         awvalid                       ;
  wire                         awready                       ;
  wire [SRAM_ADDR_WD-1:0     ] awaddr                        ;
  wire [2:0                  ] awprot                        ; // define the access permission for write accesses.

  // Write data channel
  wire                         wvalid                        ;
  wire                         wready                        ;
  wire [SRAM_DATA_WD-1:0     ] wdata                         ;
  wire [STRB_WIDTH-1:0       ] wstrb                         ;

  // Write response channel
  wire                         bvalid                        ;
  wire                         bready                        ;
  wire [1:0                  ] bresp                         ;

  // Read address channel
  wire                         arvalid                       ;
  wire                         arready                       ;
  wire [SRAM_ADDR_WD-1:0     ] araddr                        ;
  wire [2:0                  ] arprot                        ;

  // Read data channel
  wire                         rvalid                        ;
  wire                         rready                        ;
  wire [SRAM_DATA_WD-1:0     ] rdata                         ;
  wire [1:0                  ] rresp                         ;

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
    .o_awvalid                (awvalid                      ),
    .i_awready                (awready                      ),
    .o_awaddr                 (awaddr                       ),
    .o_awprot                 (awprot                       ), // define the access permission for write accesses.

  // Write data channel
    .o_wvalid                 (wvalid                       ),
    .i_wready                 (wready                       ),
    .o_wdata                  (wdata                        ),
    .o_wstrb                  (wstrb                        ),

  // Write response channel
    .i_bvalid                 (bvalid                       ),
    .o_bready                 (bready                       ),
    .i_bresp                  (bresp                        ),

  // Read address channel
    .o_arvalid                (arvalid                      ),
    .i_arready                (arready                      ),
    .o_araddr                 (araddr                       ),
    .o_arprot                 (arprot                       ),

  // Read data channel
    .i_rvalid                 (rvalid                       ),
    .o_rready                 (rready                       ),
    .i_rdata                  (rdata                        ),
    .i_rresp                  (rresp                        )
  );

  // data ram
  ysyx_22050710_axil_sram_wrap #(
  ) u_sram_wrap (
    .i_aclk                   (i_clk                        ),
    .i_arsetn                 (~i_rst                       ),

    // Wirte address channel
    .i_awvalid                (awvalid                      ),
    .o_awready                (awready                      ),
    .i_awaddr                 (awaddr                       ),
    .i_awprot                 (awprot                       ), // define the access permission for write accesses.

    // Write data channel
    .i_wvalid                 (wvalid                       ),
    .o_wready                 (wready                       ),
    .i_wdata                  (wdata                        ),
    .i_wstrb                  (wstrb                        ),

    // Write response channel 
    .o_bvalid                 (bvalid                       ),
    .i_bready                 (bready                       ),
    .o_bresp                  (bresp                        ),

    // Read address channel
    .i_arvalid                (arvalid                      ),
    .o_arready                (arready                      ),
    .i_araddr                 (araddr                       ),
    .i_arprot                 (arprot                       ),

    // Read data channel
    .o_rvalid                 (rvalid                       ),
    .i_rready                 (rready                       ),
    .o_rdata                  (rdata                        ),
    .o_rresp                  (rresp                        )
  );

endmodule
