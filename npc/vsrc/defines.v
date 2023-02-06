`ifndef ysyx_2205_0710_H
  // sram addr width
  `define ysyx_2205_0710_SRAM_ADDR_WD               32
  `define ysyx_2205_0710_SRAM_DATA_WD               64

  // pc width
  `define ysyx_2205_0710_PC_WD                      64            

  // inst width
  `define ysyx_2205_0710_INST_WD                    32            

  // Bus width
  `define ysyx_2205_0710_FS_TO_DS_BUS_WD            96  // {fs_inst[31:0], fs_pc[63:0]} 32 + 64
  `define ysyx_2205_0710_DS_TO_ES_BUS_WD            32
  `define ysyx_2205_0710_ES_TO_MS_BUS_WD            32
  `define ysyx_2205_0710_MS_TO_WS_BUS_WD            32
  `define ysyx_2205_0710_WS_TO_RF_BUS_WD            32
  `define ysyx_22050710_BR_BUS_WD                   65  // {br_sel[0:0], br_target[63:0]} 1 + 64
`endif
