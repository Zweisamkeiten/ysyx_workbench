// ysyx_22050710 Memory Stage

module ysyx_22050710_mem_stage #(
  parameter WORD_WD                                          ,
  parameter PC_WD                                            ,
  parameter INST_WD                                          ,
  parameter GPR_ADDR_WD                                      ,
  parameter CSR_ADDR_WD                                      ,
  parameter ES_TO_MS_BUS_WD                                  ,
  parameter MS_TO_WS_BUS_WD                                  ,
  parameter SRAM_DATA_WD                                     ,
  parameter DEBUG_BUS_WD
) (
  input                        i_clk                         ,
  input                        i_rst                         ,
  // allowin
  input                        i_ws_allowin                  ,
  output                       o_ms_allowin                  ,
  // from es
  input                        i_es_to_ms_valid              ,
  input  [ES_TO_MS_BUS_WD-1:0] i_es_to_ms_bus                ,
  // to ws
  output                       o_ms_to_ws_valid              ,
  output [MS_TO_WS_BUS_WD-1:0] o_ms_to_ws_bus                ,
  // from data-sram
  input  [SRAM_DATA_WD-1:0   ] i_data_sram_rdata             , // data ram 读数据返回 进入 lsu 进行处理
  // 阻塞解决数据相关性冲突: es, ms, ws 目的寄存器比较
  output [GPR_ADDR_WD-1:0    ] o_ms_to_ds_gpr_rd             ,
  output [CSR_ADDR_WD-1:0    ] o_ms_to_ds_csr_rd             ,
  // debug
  input  [DEBUG_BUS_WD-1:0   ] i_debug_es_to_ms_bus          ,
  output [DEBUG_BUS_WD-1:0   ] o_debug_ms_to_ws_bus
);

  wire                         ms_valid                      ;
  wire                         ms_ready_go                   ;
  assign ms_ready_go         = 1'b1                          ;
  assign o_ms_allowin        = (!ms_valid) || (ms_ready_go && i_ws_allowin);
  assign o_ms_to_ws_valid    = ms_valid && ms_ready_go       ;

  Reg #(
    .WIDTH                    (1                            ),
    .RESET_VAL                (1'b0                         )
  ) u_ms_valid (
    .clk                      (i_clk                        ),
    .rst                      (i_rst                        ),
    .din                      (i_es_to_ms_valid             ),
    .dout                     (ms_valid                     ),
    .wen                      (o_ms_allowin                 )
  );

  wire [ES_TO_MS_BUS_WD-1:0  ] es_to_ms_bus_r                ;

  Reg #(
    .WIDTH                    (ES_TO_MS_BUS_WD              ),
    .RESET_VAL                (0                            )
  ) u_es_to_ms_bus_r (
    .clk                      (i_clk                        ),
    .rst                      (i_rst                        ),
    .din                      (i_es_to_ms_bus               ),
    .dout                     (es_to_ms_bus_r               ),
    .wen                      (i_es_to_ms_valid&&o_ms_allowin)
  );

  // debug
  wire [DEBUG_BUS_WD-1:0     ] debug_es_to_ms_bus_r          ;

  Reg #(
    .WIDTH                    (DEBUG_BUS_WD                 ),
    .RESET_VAL                (0                            )
  ) u_debug_es_to_ms_bus_r (
    .clk                      (i_clk                        ),
    .rst                      (i_rst                        ),
    .din                      (i_debug_es_to_ms_bus         ),
    .dout                     (debug_es_to_ms_bus_r         ),
    .wen                      (1'b1                         )
  );

  wire                         ms_debug_valid                ;
  wire [INST_WD-1:0          ] ms_debug_inst                 ;
  wire [PC_WD-1:0            ] ms_debug_pc                   ;
  wire [PC_WD-1:0            ] ms_debug_dnpc                 ;

  assign {ms_debug_valid                                     ,
          ms_debug_inst                                      ,
          ms_debug_pc                                        ,
          ms_debug_dnpc
         }                   = debug_es_to_ms_bus_r          ;

  assign o_debug_ms_to_ws_bus= {ms_debug_valid               ,
                                ms_debug_inst                ,
                                ms_debug_pc                  ,
                                ms_debug_dnpc
                                                             };

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
          }                  = es_to_ms_bus_r                ;

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

  assign o_ms_to_ds_gpr_rd   = {GPR_ADDR_WD{ms_valid}} & {GPR_ADDR_WD{ms_gpr_wen}} & ms_rd;
  assign o_ms_to_ds_csr_rd   = {CSR_ADDR_WD{ms_valid}} & {CSR_ADDR_WD{ms_csr_wen}} & ms_csr;

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
