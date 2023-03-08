// ysyx_22050710 Write Back Stage

module ysyx_22050710_wb_stage #(
  parameter WORD_WD                                          ,
  parameter PC_WD                                            ,
  parameter INST_WD                                          ,
  parameter GPR_ADDR_WD                                      ,
  parameter GPR_WD                                           ,
  parameter CSR_ADDR_WD                                      ,
  parameter CSR_WD                                           ,
  parameter MS_TO_WS_BUS_WD                                  ,
  parameter WS_TO_RF_BUS_WD                                  ,
  parameter BYPASS_BUS_WD                                    ,
  parameter DEBUG_BUS_WD
) (
  input                        i_clk                         ,
  input                        i_rst                         ,
  // allowin
  output                       o_ws_allowin                  ,
  // from ms
  input                        i_ms_to_ws_valid              ,
  input  [MS_TO_WS_BUS_WD-1:0] i_ms_to_ws_bus                ,
  // to rf
  output [WS_TO_RF_BUS_WD-1:0] o_ws_to_rf_bus                ,
  // bypass
  output [BYPASS_BUS_WD-1:0  ] o_ws_to_ds_bypass_bus         ,
  // debug
  input  [DEBUG_BUS_WD-1:0   ] i_debug_ms_to_ws_bus          ,
  output [DEBUG_BUS_WD-1:0   ] o_debug_ws_to_rf_bus
);

  wire                         ws_valid                      ;
  wire                         ws_ready_go                   ;
  assign ws_ready_go         = 1'b1                          ;
  assign o_ws_allowin        = (!ws_valid) || (ws_ready_go)  ;

  Reg #(
    .WIDTH                    (1                            ),
    .RESET_VAL                (1'b0                         )
  ) u_ws_valid (
    .clk                      (i_clk                        ),
    .rst                      (i_rst                        ),
    .din                      (i_ms_to_ws_valid             ),
    .dout                     (ws_valid                     ),
    .wen                      (o_ws_allowin                 )
  );

  wire [MS_TO_WS_BUS_WD-1:0  ] ms_to_ws_bus_r                ;

  Reg #(
    .WIDTH                    (MS_TO_WS_BUS_WD              ),
    .RESET_VAL                (0                            )
  ) u_es_to_ms_bus_r (
    .clk                      (i_clk                        ),
    .rst                      (i_rst                        ),
    .din                      (i_ms_to_ws_bus               ),
    .dout                     (ms_to_ws_bus_r               ),
    .wen                      (i_ms_to_ws_valid&&o_ws_allowin)
  );

  // debug
  wire [DEBUG_BUS_WD-1:0     ] debug_ms_to_ws_bus_r          ;

  Reg #(
    .WIDTH                    (DEBUG_BUS_WD                 ),
    .RESET_VAL                (0                            )
  ) u_debug_ms_to_ws_bus_r (
    .clk                      (i_clk                        ),
    .rst                      (i_rst                        ),
    .din                      (i_debug_ms_to_ws_bus         ),
    .dout                     (debug_ms_to_ws_bus_r         ),
    .wen                      (1'b1                         )
  );

  wire                         ws_debug_valid                ;
  wire                         ws_debug_addnop               ;
  wire [INST_WD-1:0          ] ws_debug_inst                 ;
  wire [PC_WD-1:0            ] ws_debug_pc                   ;
  wire [PC_WD-1:0            ] ws_debug_dnpc                 ;
  wire                         ws_debug_memen                ;
  wire [WORD_WD-1:0          ] ws_debug_memaddr              ;

  assign {ws_debug_valid                                     ,
          ws_debug_addnop                                    ,
          ws_debug_inst                                      ,
          ws_debug_pc                                        ,
          ws_debug_dnpc                                      ,
          ws_debug_memen                                     ,
          ws_debug_memaddr
         }                   = debug_ms_to_ws_bus_r          ;

  assign o_debug_ws_to_rf_bus= {ws_debug_valid               ,
                                ws_debug_addnop              ,
                                ws_debug_inst                ,
                                ws_debug_pc                  ,
                                ws_debug_dnpc                ,
                                ws_debug_memen               ,
                                ws_debug_memaddr
                                                             };

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
          }                  = ms_to_ws_bus_r                ;

  assign o_ws_to_ds_bypass_bus = {BYPASS_BUS_WD{ws_valid}} &
                                  {({GPR_ADDR_WD{ws_gpr_wen}} & ws_rd),
                                   ({GPR_WD{ws_gpr_wen}} & ws_gpr_final_result),
                                   ({CSR_ADDR_WD{ws_csr_wen}} & ws_csr),
                                   ({CSR_WD{ws_csr_wen}} & ws_csr_final_result)
                                  };

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
