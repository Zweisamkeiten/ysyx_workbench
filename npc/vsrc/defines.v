`ifndef YSYX_22050710_MYCPU_TOP_H
  `define YSYX_22050710_MYCPU_TOP_H

  `define ysyx_22050710_WORD_WD                     64
  // sram addr width
  `define ysyx_22050710_SRAM_WMASK_WD                8
  `define ysyx_22050710_SRAM_ADDR_WD                32
  `define ysyx_22050710_SRAM_DATA_WD                64

  // pc
  `define ysyx_22050710_PC_RESETVAL                 64'h7ffffffc
  `define ysyx_22050710_PC_WD                       64

  // gpr
  `define ysyx_22050710_GPR_ADDR_WD                  5 // 32 gprs
  `define ysyx_22050710_GPR_WD                      64

  // csr
  `define ysyx_22050710_CSR_ADDR_WD                 12 // [11:0]
  `define ysyx_22050710_CSR_WD                      64

  // imm width
  `define ysyx_22050710_IMM_WD                      64

  // inst width
  `define ysyx_22050710_INST_WD                     32
`endif


`ifndef YSYX_22050710_MYCPU_STAGE_BUS_H
  `define YSYX_22050710_MYCPU_STAGE_BUS_H
  // Bus width
  `define ysyx_22050710_FS_TO_DS_BUS_WD             96   // {fs_inst[31:0], fs_pc[63:0]} 32 + 64
  `define ysyx_22050710_DS_TO_ES_BUS_WD             359
  `define ysyx_22050710_ES_TO_MS_BUS_WD             216
  `define ysyx_22050710_MS_TO_WS_BUS_WD             147
  `define ysyx_22050710_WS_TO_RF_BUS_WD             147  // {gpr_rf_wen[0:0], gpr_rf_waddr[4:0], gpr_rf_wdata[63:0]
                                                         //  csr_rf_wen[0:0], csr_rf_waddr[11:0], csr_rf_wdata[63:0]}
  `define ysyx_22050710_BR_BUS_WD                   66   // {br_sel[0:0], br_target[63:0]} 1 + 64
  `define ysyx_22050710_DEBUG_BUS_WD                97   // {debug_invalid, ds_inst[31:0], ds_pc[63:0]} 1 + 32 + 64
`endif

`ifndef YSYX_22050710_MYCPU_CSRS_ADDR_H
  `define YSYX_22050710_MYCPU_CSRS_ADDR_H
  `define ysyx_22050710_NRCSR                        4
  // csr addr
  `define ysyx_22050710_MSTATUS                     12'h300
  `define ysyx_22050710_MTVEC                       12'h305
  `define ysyx_22050710_MEPC                        12'h341
  `define ysyx_22050710_MCAUSE                      12'h342
`endif

