// ysyx_22050710 Memory Stage

module ysyx_22050710_mem_stage #(
  parameter WORD_WD                                          ,
  parameter GPR_ADDR_WD                                      ,
  parameter CSR_ADDR_WD                                      ,
  parameter ES_TO_MS_BUS_WD                                  ,
  parameter MS_TO_WS_BUS_WD                                  ,
  parameter SRAM_DATA_WD
) (
  /* input                        i_clk                         , */
  /* input                        i_rst                         , */
  // from es
  input  [ES_TO_MS_BUS_WD-1:0] i_es_to_ms_bus                ,
  // to ws
  output [MS_TO_WS_BUS_WD-1:0] o_ms_to_ws_bus                ,
  // from data-sram
  input  [SRAM_DATA_WD-1:0   ] i_data_sram_rdata               // data ram 读数据返回 进入 lsu 进行处理
);

  // result reg dest
  wire [GPR_ADDR_WD-1:0      ] ms_rd                         ;
  wire [CSR_ADDR_WD-1:0      ] ms_csr                        ;
  wire                         ms_gpr_wen                    ; // gpr 写使能
  wire                         ms_csr_wen                    ; // csr 写使能
  wire                         ms_mem_ren                    ; // mem 读使能
  wire [2:0                  ] ms_mem_op                     ; // mem 操作 op
  wire                         ms_csr_inst_sel               ; // write csrrdata to gpr
  wire [WORD_WD-1:0          ] ms_csrrdata                   ;
  wire [WORD_WD-1:0          ] ms_alu_result                 ;
  wire [WORD_WD-1:0          ] ms_csr_result                 ;

  assign {ms_rd                                              ,
          ms_csr                                             ,
          ms_gpr_wen                                         ,
          ms_csr_wen                                         ,
          ms_mem_ren                                         ,
          ms_mem_op                                          ,
          ms_csr_inst_sel                                    ,
          ms_csrrdata                                        ,
          ms_alu_result                                      ,
          ms_csr_result               
          }                  = i_es_to_ms_bus                ;

  wire [WORD_WD-1:0          ] ms_gpr_final_result           ;
  wire [WORD_WD-1:0          ] ms_csr_final_result           ;
  wire [WORD_WD-1:0          ] memrdata                      ;

  assign ms_gpr_final_result = ms_mem_ren
                             ? memrdata
                             : (ms_csr_inst_sel ? ms_csrrdata : ms_alu_result);

  assign ms_csr_final_result  = ms_csr_result                 ;

  assign o_ms_to_ws_bus      = {ms_gpr_wen                   ,
                                ms_rd                        ,
                                ms_gpr_final_result          ,
                                ms_csr_wen                   ,
                                ms_csr                       ,
                                ms_csr_final_result          };

  ysyx_22050710_lsu_load #(
    .WORD_WD                  (WORD_WD                      ),
    .SRAM_DATA_WD             (SRAM_DATA_WD                 )
  ) u_lsu_load (
    .i_raddr_align            (ms_alu_result[2:0]           ), // x[rs1] + imm
    .i_data_sram_rdata        (i_data_sram_rdata            ),
    .i_mem_ren                (ms_mem_ren                   ),
    .i_mem_op                 (ms_mem_op                    ),
    .o_rdata                  (memrdata                     )
  );

endmodule
