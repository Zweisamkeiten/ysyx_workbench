// ysyx_22050710 Instruction Fetch Unit

module ysyx_22050710_ifu #(
  parameter INST_WD                                          ,
  parameter PC_WD                                            ,
  parameter SRAM_ADDR_WD                                     ,
  parameter SRAM_DATA_WD                        
) (
  input                        i_clk                         ,
  input                        i_rst                         ,
  input  [PC_WD-1:0          ] i_pc                          ,
  output [INST_WD-1:0        ] o_inst                        ,
  input                        i_to_fs_valid                 ,
  // inst sram interface
  output                       o_inst_sram_en                ,
  output [SRAM_ADDR_WD-1:0   ] o_inst_sram_addr              ,
  input  [SRAM_DATA_WD-1:0   ] i_inst_sram_rdata
);

  assign o_inst              = i_pc[2] == 1'b0
                             ? i_inst_sram_rdata[31:0]
                             : i_inst_sram_rdata[63:32]      ;

  assign o_inst_sram_en      = i_to_fs_valid                 ;
  assign o_inst_sram_addr    = 1'b1
                             ? i_pc[31:0]
                             : i_pc[63:32]                   ;

endmodule
