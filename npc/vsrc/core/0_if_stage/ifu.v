// ysyx_22050710 Instruction Fetch Unit

module ysyx_22050710_ifu #(
  parameter INST_WD                                          ,
  parameter PC_WD                                            ,
  parameter SRAM_DATA_WD
) (
  input  [PC_WD-1:0          ] i_pc                          ,
  output [INST_WD-1:0        ] o_inst                        ,
  // inst sram interface
  input  [SRAM_DATA_WD-1:0   ] i_inst_sram_rdata
);

  assign o_inst              = i_pc[2] == 1'b0
                             ? i_inst_sram_rdata[31:0]
                             : i_inst_sram_rdata[63:32]      ;

endmodule
