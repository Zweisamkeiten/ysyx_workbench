// ysyx_22050710 Memory Stage

module ysyx_22050710_mem_stage #(
  parameter WORD_WD                                          ,
  parameter GPR_ADDR_WD                                      ,
  parameter CSR_ADDR_WD                                      ,
  parameter ES_TO_MS_BUS_WD                                  ,
  parameter MS_TO_WS_BUS_WD
) (
  input                        i_clk                         ,
  input                        i_rst                         ,
  // from es
  input  [ES_TO_MS_BUS_WD-1:0] i_es_to_ms_bus                ,
  // to ws
  output [MS_TO_WS_BUS_WD-1:0] o_ms_to_ws_bus
);

  // result reg dest
  wire [GPR_ADDR_WD-1:0      ] ms_rd                         ;
  wire [CSR_ADDR_WD-1:0      ] ms_csr                        ;
  wire                         ms_gpr_wen                    ; // gpr 写使能
  wire                         ms_csr_wen                    ; // csr 写使能
  wire                         ms_mem_ren                    ; // mem 读使能
  wire                         ms_mem_wen                    ; // mem 写使能
  wire [2:0                  ] ms_mem_op                     ; // mem 操作 op
  wire                         ms_csr_inst_sel               ; // write csrrdata to gpr
  wire [WORD_WD-1:0          ] ms_rs2data                    ;
  wire [WORD_WD-1:0          ] ms_csrdata                    ;
  wire [WORD_WD-1:0          ] ms_alu_result                 ;
  wire [WORD_WD-1:0          ] ms_csr_result                 ;

  assign {ms_rd                                              ,
          ms_csr                                             ,
          ms_gpr_wen                                         ,
          ms_csr_wen                                         ,
          ms_mem_ren                                         ,
          ms_mem_wen                                         ,
          ms_mem_op                                          ,
          ms_csr_inst_sel                                    ,
          ms_rs2data                                         ,
          ms_csrrdata                                        ,
          ms_alu_result                                      ,
          ms_csr_result               
          }                  = i_es_to_ms_bus                ;

  wire [WORD_WD-1:0          ] ms_gpr_final_result           ;
  wire [WORD_WD-1:0          ] ms_csr_final_result           ;
  assign o_ms_to_ws_bus      = {ms_gpr_wen                   ,
                                ms_rd                        ,
                                ms_gpr_final_result          ,
                                ms_csr_wen                   ,
                                ms_csr                       ,
                                ms_csr_final_result          };

  wire [WORD_WD-1:0          ] lsu_addr                      ;
  assign lsu_addr            = ms_alu_result                 ; // x[rs1] + imm

  ysyx_22050710_lsu #(
    .WORD_WD                  (WORD_WD                      ),
  ) u_lsu (
    .i_clk                    (i_clk                        ),
    .i_rst                    (i_rst                        ),
    .i_addr                   (lsu_addr                     ),
    .i_wdata                  (ms_rs2data                   ),
    .i_alu_result             (ms_alu_result                ),
    .i_csr_result             (ms_csr_result                ),
    .i_csrrdata               (ms_csrdata                   ),
    .i_mem_ren                (ms_mem_ren                   ),
    .i_mem_wen                (ms_mem_wen                   ),
    .i_mem_op                 (ms_mem_op                    ),
    .i_csr_inst_sel           (ms_csr_inst_sel              ), // write csrrdata to gpr
    .o_gpr_final_result       (ms_gpr_final_result          ),
    .o_csr_final_result       (ms_csr_final_result          )
  );

endmodule
