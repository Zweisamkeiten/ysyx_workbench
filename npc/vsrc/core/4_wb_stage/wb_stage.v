// ysyx_22050710 Write Back Stage

module ysyx_22050710_wb_stage #(
  parameter WORD_WD                                          ,
  parameter GPR_ADDR_WD                                      ,
  parameter GPR_WD                                           ,
  parameter CSR_ADDR_WD                                      ,
  parameter CSR_WD                                           ,
  parameter MS_TO_WS_BUS_WD                                  ,
  parameter WS_TO_RF_BUS_WD
) (
  // from ms
  input  [MS_TO_WS_BUS_WD-1:0] i_ms_to_ws_bus                ,
  // to rf
  output [WS_TO_RF_BUS_WD-1:0] o_ws_to_rf_bus
);

  wire [GPR_ADDR_WD-1:0      ] ws_rd                         ;
  wire [CSR_ADDR_WD-1:0      ] ws_csr                        ;
  wire                         ws_gpr_wen                    ; // gpr 写使能
  wire                         ws_csr_wen                    ; // csr 写使能
  wire [WORD_WD-1:0          ] ws_gpr_final_result           ;
  wire [WORD_WD-1:0          ] ws_csr_final_result           ;

  assign {ws_gpr_wen                                         ,
          ws_rd                                              ,
          ws_gpr_final_result                                ,
          ws_csr_wen                                         ,
          ws_csr                                             ,
          ws_csr_final_result
          }                  = i_ms_to_ws_bus                ;

  ysyx_22050710_wbu #(
    .GPR_ADDR_WD              (GPR_ADDR_WD                  ),
    .GPR_WD                   (GPR_WD                       ),
    .CSR_ADDR_WD              (CSR_ADDR_WD                  ),
    .CSR_WD                   (CSR_WD                       ),
    .WS_TO_RF_BUS_WD          (WS_TO_RF_BUS_WD              )
  ) u_wbu (
    // gpr
    .i_gpr_wen                (ws_gpr_wen                   ),
    .i_gpr_waddr              (ws_rd                        ),
    .i_gpr_wdata              (ws_gpr_final_result          ),
    // csr
    .i_csr_wen                (ws_csr_wen                   ),
    .i_csr_waddr              (ws_csr                       ),
    .i_csr_wdata              (ws_csr_final_result          ),
    // output to rf bus
    .o_to_rf_bus              (o_ws_to_rf_bus               )
  );

endmodule
