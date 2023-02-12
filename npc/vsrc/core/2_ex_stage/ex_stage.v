// ysyx_22050710 Execute Stage

module ysyx_22050710_ex_stage #(
  parameter WORD_WD                                          ,
  parameter PC_WD                                            ,
  parameter INST_WD                                          ,
  parameter GPR_WD                                           ,
  parameter GPR_ADDR_WD                                      ,
  parameter CSR_WD                                           ,
  parameter CSR_ADDR_WD                                      ,
  parameter IMM_WD                                           ,
  parameter DS_TO_ES_BUS_WD                                  ,
  parameter ES_TO_MS_BUS_WD                                  ,
  parameter SRAM_ADDR_WD                                     ,
  parameter SRAM_WMASK_WD                                    ,
  parameter SRAM_DATA_WD                                     ,
  parameter DEBUG_BUS_WD
) (
  input                        i_clk                         ,
  input                        i_rst                         ,
  // allowin
  input                        i_ms_allowin                  ,
  output                       o_es_allowin                  ,
  // from ds
  input                        i_ds_to_es_valid              ,
  input  [DS_TO_ES_BUS_WD-1:0] i_ds_to_es_bus                ,
  // to ms
  output                       o_es_to_ms_valid              ,
  output [ES_TO_MS_BUS_WD-1:0] o_es_to_ms_bus                ,
  // data sram interface
  output [SRAM_ADDR_WD-1:0   ] o_data_sram_addr              ,  // data ram 读请求或写请求是在 ex stage 发出
  output                       o_data_sram_ren               ,  // data ram 的读数据在mem stage 返回
  output                       o_data_sram_wen               ,
  output [SRAM_WMASK_WD-1:0  ] o_data_sram_wmask             ,
  output [SRAM_DATA_WD-1:0   ] o_data_sram_wdata             ,
  // 阻塞解决数据相关性冲突: es, ms, ws 目的寄存器比较
  output [GPR_ADDR_WD-1:0    ] o_es_to_ds_gpr_rd             ,
  output [CSR_ADDR_WD-1:0    ] o_es_to_ds_csr_rd             ,
  // debug
  input  [DEBUG_BUS_WD-1:0   ] i_debug_ds_to_es_bus          ,
  output [DEBUG_BUS_WD-1:0   ] o_debug_es_to_ms_bus
);

  wire                         es_valid                      ;
  wire                         es_ready_go                   ;
  assign es_ready_go         = 1'b1                          ;
  assign o_es_allowin        = (!es_valid) || (es_ready_go && i_ms_allowin);
  assign o_es_to_ms_valid    = es_valid && es_ready_go       ;

  Reg #(
    .WIDTH                    (1                            ),
    .RESET_VAL                (1'b0                         )
  ) u_es_valid (
    .clk                      (i_clk                        ),
    .rst                      (i_rst                        ),
    .din                      (i_ds_to_es_valid             ),
    .dout                     (es_valid                     ),
    .wen                      (o_es_allowin                 )
  );

  wire [DS_TO_ES_BUS_WD-1:0  ] ds_to_es_bus_r                ;

  Reg #(
    .WIDTH                    (DS_TO_ES_BUS_WD              ),
    .RESET_VAL                (0                            )
  ) u_ds_to_es_bus_r (
    .clk                      (i_clk                        ),
    .rst                      (i_rst                        ),
    .din                      (i_ds_to_es_bus               ),
    .dout                     (ds_to_es_bus_r               ),
    .wen                      (i_ds_to_es_valid&&o_es_allowin)
  );

  // oprand
  wire [GPR_WD-1:0           ] es_rs1data                    ;
  wire [GPR_WD-1:0           ] es_rs2data                    ;
  wire [CSR_WD-1:0           ] es_csrrdata                   ;
  wire [IMM_WD-1:0           ] es_imm                        ;
  wire [PC_WD-1:0            ] es_pc                         ;
  // result reg dest
  wire [GPR_ADDR_WD-1:0      ] es_rd                         ;
  wire [CSR_ADDR_WD-1:0      ] es_csr                        ;
  // idu 产生的控制信号
  wire                         es_alu_src1_sel               ; // 选择 alu 操作数 1
  wire [1:0                 ]  es_alu_src2_sel               ; // 选择 alu 操作数 2
  wire                         es_alu_word_cut_sel           ; // 字长截断使能
  wire [4:0                  ] es_alu_op                     ; // alu op
  wire                         es_gpr_wen                    ; // gpr 写使能
  wire                         es_csr_wen                    ; // csr 写使能
  wire                         es_mem_ren                    ; // mem 读使能
  wire                         es_mem_wen                    ; // mem 写使能
  wire [2:0                  ] es_mem_op                     ; // mem 操作 op
  wire                         es_csr_inst_sel               ; // write csrrdata to gpr
  wire [2:0                  ] es_csr_op                     ; // csr 相关逻辑运算操作
  wire                         es_ebreak_sel                 ; // 环境断点 用于结束运行
  wire                         es_invalid_inst_sel           ; // 译码错误 非法指令
  
  assign {es_rs1data                                         ,  // 358:295
          es_rs2data                                         ,  // 294:231
          es_csrrdata                                        ,  // 230:167
          es_imm                                             ,  // 166:103
          es_pc                                              ,  // 102:39
          es_alu_src1_sel                                    ,  //  38:38
          es_alu_src2_sel                                    ,  //  37:36
          es_alu_word_cut_sel                                ,  //  35:35
          es_alu_op                                          ,  //  34:30
          es_rd                                              ,  //  29:25
          es_csr                                             ,  //  24:13
          es_gpr_wen                                         ,  //  12:12
          es_csr_wen                                         ,  //  11:11
          es_mem_ren                                         ,  //  10:10
          es_mem_wen                                         ,  //   9:9
          es_mem_op                                          ,  //   8:6
          es_csr_inst_sel                                    ,  //   5:5
          es_csr_op                                          ,  //   4:2
          es_ebreak_sel                                      ,  //   1:1
          es_invalid_inst_sel                                   //   0:0
          }                   = ds_to_es_bus_r               ;

  // debug
  wire [DEBUG_BUS_WD-1:0     ] debug_ds_to_es_bus_r         ;

  Reg #(
    .WIDTH                    (DEBUG_BUS_WD                 ),
    .RESET_VAL                (0                            )
  ) u_debug_ds_to_es_bus_r (
    .clk                      (i_clk                        ),
    .rst                      (i_rst                        ),
    .din                      (i_debug_ds_to_es_bus         ),
    .dout                     (debug_ds_to_es_bus_r         ),
    .wen                      (1'b1                         )
  );

  wire                         es_debug_valid                ;
  wire [INST_WD-1:0          ] es_debug_inst                 ;
  wire [PC_WD-1:0            ] es_debug_pc                   ;

  assign {es_debug_valid                                     ,
          es_debug_inst                                      ,
          es_debug_pc
         }                   = debug_ds_to_es_bus_r          ;

  assign o_debug_es_to_ms_bus= {es_debug_valid               ,
                                es_debug_inst                ,
                                es_debug_pc
                                                             };

  wire [WORD_WD-1:0          ] es_alu_result                 ;
  wire [WORD_WD-1:0          ] es_csr_result                 ;
  assign o_es_to_ms_bus      = {es_rd                        ,
                                es_csr                       ,
                                es_gpr_wen                   ,
                                es_csr_wen                   ,
                                es_mem_ren                   ,
                                es_mem_op                    ,
                                es_csr_inst_sel              ,
                                es_csrrdata                  ,
                                es_alu_result                ,
                                es_csr_result               };

  assign o_es_to_ds_gpr_rd   = {GPR_ADDR_WD{es_valid}} & {GPR_ADDR_WD{es_gpr_wen}} & es_rd;
  assign o_es_to_ds_csr_rd   = {CSR_ADDR_WD{es_valid}} & {CSR_ADDR_WD{es_csr_wen}} & es_csr;

  ysyx_22050710_exu #(
    .WORD_WD                  (WORD_WD                      ),
    .PC_WD                    (PC_WD                        ),
    .GPR_WD                   (GPR_WD                       ),
    .CSR_WD                   (CSR_WD                       ),
    .IMM_WD                   (IMM_WD                       )
  ) u_exu (
    .i_clk                    (i_clk                        ),
    // oprand
    .i_rs1data                (es_rs1data                   ),
    .i_rs2data                (es_rs2data                   ),
    .i_imm                    (es_imm                       ),
    .i_pc                     (es_pc                        ),
    .i_csrrdata               (es_csrrdata                  ),
    // alu control
    .i_alu_src1_sel           (es_alu_src1_sel              ),
    .i_alu_src2_sel           (es_alu_src2_sel              ),
    .i_alu_op                 (es_alu_op                    ),
    .i_alu_word_cut_sel       (es_alu_word_cut_sel          ),
    // csr 运算相关
    .i_csr_op                 (es_csr_op                    ),
    // ebreak
    .i_ebreak_sel             (es_ebreak_sel                ),
    // invalid inst
    .i_invalid_inst_sel       (es_invalid_inst_sel          ),
    // output
    .o_alu_result             (es_alu_result                ),
    .o_csr_result             (es_csr_result                )
  );

  ysyx_22050710_lsu_store #(
    .GPR_WD                   (GPR_WD                       ),
    .SRAM_WMASK_WD            (SRAM_WMASK_WD                ),
    .SRAM_DATA_WD             (SRAM_DATA_WD                 )
  ) u_lsu_store (
    .i_mem_op                 (es_mem_op                    ),
    .i_waddr_align            (es_alu_result[2:0]           ), // x[rs1] + imm
    .i_wdata                  (es_rs2data                   ), // store inst
    .o_wmask                  (o_data_sram_wmask            ),
    .o_wdata                  (o_data_sram_wdata            )
  );

  assign o_data_sram_ren     = es_mem_ren                    ;
  assign o_data_sram_wen     = es_mem_wen && es_valid        ;
  assign o_data_sram_addr    = es_alu_result[31:0]           ; // x[rs1] + imm

endmodule
