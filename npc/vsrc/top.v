// ysyx_22050710 TOP
`include "defines.v"

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
  parameter SRAM_DATA_WD     = `ysyx_22050710_SRAM_DATA_WD
) (
  input                        i_clk                         ,
  input                        i_rst
);

  //cpu inst sram
  wire                         cpu_inst_en                   ;
  wire [SRAM_ADDR_WD-1:0     ] cpu_inst_addr                 ;
  wire [SRAM_DATA_WD-1:0     ] cpu_inst_rdata                ;

  ysyx_22050710_core #( 
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
    .SRAM_DATA_WD             (SRAM_DATA_WD                 )
  ) u_core (
    .i_clk                    (i_clk                        ),
    .i_rst                    (i_rst                        ),

    .o_inst_sram_en           (cpu_inst_en                  ),
    .o_inst_sram_addr         (cpu_inst_addr                ),
    .i_inst_sram_rdata        (cpu_inst_rdata               )
  );

  //inst ram
  ysyx_22050710_inst_sram #(
    .SRAM_ADDR_WD            (SRAM_ADDR_WD                  ),
    .SRAM_DATA_WD            (SRAM_DATA_WD                  )
  ) u_inst_ram (
    .i_clk                   (i_clk                         ),
    .i_en                    (cpu_inst_en                   ),
    .i_addr                  (cpu_inst_addr                 ),
    .o_rdata                 (cpu_inst_rdata                )    //63:0
  );

endmodule
