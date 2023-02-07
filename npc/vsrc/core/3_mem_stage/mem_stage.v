// ysyx_22050710 Memory Stage

module ysyx_22050710_mem_stage #(
  parameter WORD_WD                                          ,
  parameter PC_WD                                            ,
  parameter GPR_WD                                           ,
  parameter GPR_ADDR_WD                                      ,
  parameter CSR_WD                                           ,
  parameter IMM_WD                                           ,
  parameter DS_TO_ES_BUS_WD                                  ,
  parameter ES_TO_MS_BUS_WD
) (
  input                        i_clk                         ,
  input                        i_rst                         ,
);
