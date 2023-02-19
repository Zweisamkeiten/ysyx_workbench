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
  wire                        ifu_awvalid                    ;
  wire                        ifu_awready                    ;
  wire [SRAM_ADDR_WD-1:0    ] ifu_awaddr                     ;
  wire [2:0                 ] ifu_awprot                     ; // define the access permission for write accesses.

  // Write data channel
  wire                        ifu_wvalid                     ;
  wire                        ifu_wready                     ;
  wire [SRAM_DATA_WD-1:0    ] ifu_wdata                      ;
  wire [STRB_WIDTH-1:0      ] ifu_wstrb                      ;

  // Write response channel
  wire                        ifu_bvalid                     ;
  wire                        ifu_bready                     ;
  wire [1:0                 ] ifu_bresp                      ;

  // Read address channel
  wire                        ifu_arvalid                    ;
  wire                        ifu_arready                    ;
  wire [SRAM_ADDR_WD-1:0    ] ifu_araddr                     ;
  wire [2:0                 ] ifu_arprot                     ;

  // Read data channel
  wire                        ifu_rvalid                     ;
  wire                        ifu_rready                     ;
  wire [SRAM_DATA_WD-1:0    ] ifu_rdata                      ;
  wire [1:0                 ] ifu_rresp                      ;

  // Wirte address channel
  wire                        lsu_awvalid                    ;
  wire                        lsu_awready                    ;
  wire [SRAM_ADDR_WD-1:0    ] lsu_awaddr                     ;
  wire [2:0                 ] lsu_awprot                     ; // define the access permission for write accesses.

  // Write data channel
  wire                        lsu_wvalid                     ;
  wire                        lsu_wready                     ;
  wire [SRAM_DATA_WD-1:0    ] lsu_wdata                      ;
  wire [STRB_WIDTH-1:0      ] lsu_wstrb                      ;

  // Write response channel
  wire                        lsu_bvalid                     ;
  wire                        lsu_bready                     ;
  wire [1:0                 ] lsu_bresp                      ;

  // Read address channel
  wire                        lsu_arvalid                    ;
  wire                        lsu_arready                    ;
  wire [SRAM_ADDR_WD-1:0    ] lsu_araddr                     ;
  wire [2:0                 ] lsu_arprot                     ;

  // Read data channel
  wire                        lsu_rvalid                     ;
  wire                        lsu_rready                     ;
  wire [SRAM_DATA_WD-1:0    ] lsu_rdata                      ;
  wire [1:0                 ] lsu_rresp                      ;

  ysyx_22050710_cpu_top #(
    .WORD_WD                 (WORD_WD                       ),
    .PC_RESETVAL             (PC_RESETVAL                   ),
    .PC_WD                   (PC_WD                         ),
    .GPR_WD                  (GPR_WD                        ),
    .GPR_ADDR_WD             (GPR_ADDR_WD                   ),
    .IMM_WD                  (IMM_WD                        ),
    .CSR_WD                  (CSR_WD                        ),
    .CSR_ADDR_WD             (CSR_ADDR_WD                   ),
    .INST_WD                 (INST_WD                       ),
    .SRAM_ADDR_WD            (SRAM_ADDR_WD                  ),
    .SRAM_WMASK_WD           (SRAM_WMASK_WD                 ),
    .SRAM_DATA_WD            (SRAM_DATA_WD                  )
  ) u_cpu_top (
    .i_aclk                  (i_clk                         ),
    .i_arsetn                (~i_rst                        ),

  // Wirte address channel
    .o_ifu_awvalid           (ifu_awvalid                   ),
    .i_ifu_awready           (ifu_awready                   ),
    .o_ifu_awaddr            (ifu_awaddr                    ),
    .o_ifu_awprot            (ifu_awprot                    ), // define the access permission for write accesses.

  // Write data channel
    .o_ifu_wvalid            (ifu_wvalid                    ),
    .i_ifu_wready            (ifu_wready                    ),
    .o_ifu_wdata             (ifu_wdata                     ),
    .o_ifu_wstrb             (ifu_wstrb                     ),

  // Write response channel
    .i_ifu_bvalid            (ifu_bvalid                    ),
    .o_ifu_bready            (ifu_bready                    ),
    .i_ifu_bresp             (ifu_bresp                     ),

  // Read address channel
    .o_ifu_arvalid           (ifu_arvalid                   ),
    .i_ifu_arready           (ifu_arready                   ),
    .o_ifu_araddr            (ifu_araddr                    ),
    .o_ifu_arprot            (ifu_arprot                    ),

  // Read data channel
    .i_ifu_rvalid            (ifu_rvalid                    ),
    .o_ifu_rready            (ifu_rready                    ),
    .i_ifu_rdata             (ifu_rdata                     ),
    .i_ifu_rresp             (ifu_rresp                     ),

  // Wirte address channel
    .o_lsu_awvalid           (lsu_awvalid                   ),
    .i_lsu_awready           (lsu_awready                   ),
    .o_lsu_awaddr            (lsu_awaddr                    ),
    .o_lsu_awprot            (lsu_awprot                    ), // define the access permission for write accesses.

  // Write data channel
    .o_lsu_wvalid            (lsu_wvalid                    ),
    .i_lsu_wready            (lsu_wready                    ),
    .o_lsu_wdata             (lsu_wdata                     ),
    .o_lsu_wstrb             (lsu_wstrb                     ),

  // Write response channel
    .i_lsu_bvalid            (lsu_bvalid                    ),
    .o_lsu_bready            (lsu_bready                    ),
    .i_lsu_bresp             (lsu_bresp                     ),

  // Read address channel
    .o_lsu_arvalid           (lsu_arvalid                   ),
    .i_lsu_arready           (lsu_arready                   ),
    .o_lsu_araddr            (lsu_araddr                    ),
    .o_lsu_arprot            (lsu_arprot                    ),

  // Read data channel
    .i_lsu_rvalid            (lsu_rvalid                    ),
    .o_lsu_rready            (lsu_rready                    ),
    .i_lsu_rdata             (lsu_rdata                     ),
    .i_lsu_rresp             (lsu_rresp                     )
  );

  // inst ram
  ysyx_22050710_axil_inst_sram_wrap #(
  ) u_inst_ram_wrap (
    .i_aclk                  (i_clk                         ),
    .i_arsetn                (~i_rst                        ),

    // Wirte address channel
    .i_awvalid               (ifu_awvalid                   ),
    .o_awready               (ifu_awready                   ),
    .i_awaddr                (ifu_awaddr                    ),
    .i_awprot                (ifu_awprot                    ), // define the access permission for write accesses.

    // Write data channel
    .i_wvalid                (ifu_wvalid                    ),
    .o_wready                (ifu_wready                    ),
    .i_wdata                 (ifu_wdata                     ),
    .i_wstrb                 (ifu_wstrb                     ),

    // Write response channel
    .o_bvalid                (ifu_bvalid                    ),
    .i_bready                (ifu_bready                    ),
    .o_bresp                 (ifu_bresp                     ),

    // Read address channel
    .i_arvalid               (ifu_arvalid                   ),
    .o_arready               (ifu_arready                   ),
    .i_araddr                (ifu_araddr                    ),
    .i_arprot                (ifu_arprot                    ),

    // Read data channel
    .o_rvalid                (ifu_rvalid                    ),
    .i_rready                (ifu_rready                    ),
    .o_rdata                 (ifu_rdata                     ),
    .o_rresp                 (ifu_rresp                     )
  );

  // data ram
  ysyx_22050710_axil_data_sram_wrap #(
  ) u_data_ram_wrap (
    .i_aclk                  (i_clk                         ),
    .i_arsetn                (~i_rst                        ),

    // Wirte address channel
    .i_awvalid               (lsu_awvalid                   ),
    .o_awready               (lsu_awready                   ),
    .i_awaddr                (lsu_awaddr                    ),
    .i_awprot                (lsu_awprot                    ), // define the access permission for write accesses.

    // Write data channel
    .i_wvalid                (lsu_wvalid                    ),
    .o_wready                (lsu_wready                    ),
    .i_wdata                 (lsu_wdata                     ),
    .i_wstrb                 (lsu_wstrb                     ),

    // Write response channel
    .o_bvalid                (lsu_bvalid                    ),
    .i_bready                (lsu_bready                    ),
    .o_bresp                 (lsu_bresp                     ),

    // Read address channel
    .i_arvalid               (lsu_arvalid                   ),
    .o_arready               (lsu_arready                   ),
    .i_araddr                (lsu_araddr                    ),
    .i_arprot                (lsu_arprot                    ),

    // Read data channel
    .o_rvalid                (lsu_rvalid                    ),
    .i_rready                (lsu_rready                    ),
    .o_rdata                 (lsu_rdata                     ),
    .o_rresp                 (lsu_rresp                     )
  );

endmodule
