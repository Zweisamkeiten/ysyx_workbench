// ysyx_22050710 Write Back Stage

import "DPI-C" function void finish_handle(input longint pc, input longint inst);

module ysyx_22050710_wb_stage #(
  parameter WORD_WD                                          ,
  parameter PC_WD                                            ,
  parameter INST_WD                                          ,
  parameter GPR_ADDR_WD                                      ,
  parameter GPR_WD                                           ,
  parameter CSR_ADDR_WD                                      ,
  parameter CSR_WD                                           ,
  parameter MS_TO_WS_BUS_WD                                  ,
  parameter WS_TO_RF_BUS_WD
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
  // 阻塞解决数据相关性冲突: es, ms, ws 目的寄存器比较
  output [GPR_ADDR_WD-1:0    ] o_ws_to_ds_gpr_rd             ,
  output [CSR_ADDR_WD-1:0    ] o_ws_to_ds_csr_rd
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

  wire                         debug_valid                   ;
  Reg #(
    .WIDTH                    (1                            ),
    .RESET_VAL                (0                            )
  ) u_debug_valid_r (
    .clk                      (i_clk                        ),
    .rst                      (i_rst                        ),
    .din                      (1'b1                         ),
    .dout                     (debug_valid                  ),
    .wen                      (i_ms_to_ws_valid&&o_ws_allowin)
  );

  wire [PC_WD-1:0             ] debug_pc                      ;
  wire [INST_WD-1:0           ] debug_inst                    ;
  Reg #(
    .WIDTH                    (PC_WD                        ),
    .RESET_VAL                (0                            )
  ) u_debug_pc_r (
    .clk                      (i_clk                        ),
    .rst                      (i_rst                        ),
    .din                      (ws_pc                        ),
    .dout                     (debug_pc                     ),
    .wen                      (i_ms_to_ws_valid&&o_ws_allowin)
  );
  Reg #(
    .WIDTH                    (INST_WD                      ),
    .RESET_VAL                (0                            )
  ) u_debug_inst_r (
    .clk                      (i_clk                        ),
    .rst                      (i_rst                        ),
    .din                      (ws_inst                      ),
    .dout                     (debug_inst                   ),
    .wen                      (i_ms_to_ws_valid&&o_ws_allowin)
  );

  always @(posedge i_clk) begin
    if (debug_valid) begin
      finish_handle(debug_pc, {32'b0, debug_inst});
    end
  end

  wire [GPR_ADDR_WD-1:0      ] ws_rd                         ;
  wire [CSR_ADDR_WD-1:0      ] ws_csr                        ;
  wire                         ws_gpr_wen                    ; // gpr 写使能
  wire                         ws_csr_wen                    ; // csr 写使能
  wire [WORD_WD-1:0          ] ws_gpr_final_result           ;
  wire [WORD_WD-1:0          ] ws_csr_final_result           ;

  // debug
  wire [PC_WD-1:0            ] ws_pc                         ;
  wire [INST_WD-1:0          ] ws_inst                       ;

  assign {ws_inst                                            ,
          ws_pc                                              ,
          ws_gpr_wen                                         ,
          ws_rd                                              ,
          ws_gpr_final_result                                ,
          ws_csr_wen                                         ,
          ws_csr                                             ,
          ws_csr_final_result
          }                  = ms_to_ws_bus_r                ;

  assign o_ws_to_ds_gpr_rd   = {GPR_ADDR_WD{ws_valid}} & {GPR_ADDR_WD{ws_gpr_wen}} & ws_rd;
  assign o_ws_to_ds_csr_rd   = {CSR_ADDR_WD{ws_valid}} & {CSR_ADDR_WD{ws_csr_wen}} & ws_csr;

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
