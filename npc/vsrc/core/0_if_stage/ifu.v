// ysyx_22050710 Instruction Fetch Unit

module ysyx_22050710_ifu #(
  parameter INST_WD                                          ,
  parameter SRAM_DATA_WD
) (
  input                        i_pc_align                    , // 取指访问指令sram 64位对齐 根据 pc[2] 选择前32bits还是后32bits
  output [INST_WD-1:0        ] o_inst                        ,
  // inst sram interface
  input  [SRAM_DATA_WD-1:0   ] i_inst_sram_rdata
);

  assign o_inst              = i_pc_align == 1'b0
                             ? i_inst_sram_rdata[31:0]
                             : i_inst_sram_rdata[63:32]      ;

endmodule
