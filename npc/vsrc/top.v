// ysyx_22050710 TOP
`include "defines.v"

import "DPI-C" function void npc_pmem_read(input longint raddr, output longint rdata);
import "DPI-C" function void npc_pmem_write(input longint waddr, input longint wdata, input byte wmask);


module ysyx_22050710_top #(
  parameter WORD_WD          = `ysyx_22050710_WORD_WD         ,
  parameter PC_RESETVAL      = `ysyx_22050710_PC_RESETVAL     ,
  parameter PC_WD            = `ysyx_22050710_PC_WD           ,
  parameter GPR_WD           = `ysyx_22050710_GPR_WD          ,
  parameter GPR_ADDR_WD      = `ysyx_22050710_GPR_ADDR_WD     ,
  parameter IMM_WD           = `ysyx_22050710_IMM_WD          ,
  parameter CSR_WD           = `ysyx_22050710_CSR_WD          ,
  parameter CSR_ADDR_WD      = `ysyx_22050710_CSR_ADDR_WD     ,
  parameter INST_WD          = `ysyx_22050710_INST_WD         ,
  parameter SRAM_ADDR_WD     = `ysyx_22050710_SRAM_ADDR_WD    ,
  parameter SRAM_WMASK_WD    = `ysyx_22050710_SRAM_WMASK_WD   ,
  parameter SRAM_DATA_WD     = `ysyx_22050710_SRAM_DATA_WD
) (
  input                        i_clk                         ,
  input                        i_rst
);

  // cpu inst sram
  wire [SRAM_ADDR_WD-1:0     ] cpu_inst_addr                 ;
  wire                         cpu_inst_ren                  ;
  wire [SRAM_DATA_WD-1:0     ] cpu_inst_rdata                ;
  // cpu data sram
  wire [SRAM_ADDR_WD-1:0     ] cpu_data_addr                 ;
  wire                         cpu_data_ren                  ;
  wire [SRAM_DATA_WD-1:0     ] cpu_data_rdata                ;
  wire                         cpu_data_wen                  ;
  wire [SRAM_WMASK_WD-1:0    ] cpu_data_wmask                ;
  wire [SRAM_DATA_WD-1:0     ] cpu_data_wdata                ;

  ysyx_22050710_core #( 
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
  ) u_core (
    .i_clk                   (i_clk                         ),
    .i_rst                   (i_rst                         ),

    .o_inst_sram_ren         (cpu_inst_ren                  ),
    .o_inst_sram_addr        (cpu_inst_addr                 ),
    .i_inst_sram_rdata       (cpu_inst_rdata                ),

    // data sram interface
    .o_data_sram_addr        (cpu_data_addr                 ),
    .o_data_sram_ren         (cpu_data_ren                  ),
    .i_data_sram_rdata       (cpu_data_rdata                ),
    .o_data_sram_wen         (cpu_data_wen                  ),
    .o_data_sram_wmask       (cpu_data_wmask                ),
    .o_data_sram_wdata       (cpu_data_wdata                )
  );

  // inst ram
  ysyx_22050710_inst_sram #(
    .SRAM_ADDR_WD            (SRAM_ADDR_WD                  ),
    .SRAM_DATA_WD            (SRAM_DATA_WD                  )
  ) u_inst_ram (
    .i_clk                   (i_clk                         ),
    .i_ren                   (cpu_inst_ren                  ),
    .i_addr                  (cpu_inst_addr                 ),
    .o_rdata                 (cpu_inst_rdata                )   //63:0
  );

  // data ram
  ysyx_22050710_data_sram #(
    .SRAM_ADDR_WD            (SRAM_ADDR_WD                  ),
    .SRAM_WMASK_WD           (SRAM_WMASK_WD                 ),
    .SRAM_DATA_WD            (SRAM_DATA_WD                  )
  ) u_data_ram (
    .i_clk                   (i_clk                         ),
    .i_addr                  (cpu_data_addr                 ),
    .i_ren                   (cpu_data_ren                  ),
    .o_rdata                 (cpu_data_rdata                ),  //63:0
    .i_wen                   (cpu_data_wen                  ),
    .i_wmask                 (cpu_data_wmask                ),
    .i_wdata                 (cpu_data_wdata                )   // 63:0
  );

endmodule
