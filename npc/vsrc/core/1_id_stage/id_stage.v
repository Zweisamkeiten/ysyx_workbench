// ysyx_22050710 Id stage

import "DPI-C" function void finish_handle(input longint pc, input longint inst);

module ysyx_22050710_id_stage #(
  parameter WORD_WD                                          ,
  parameter INST_WD                                          ,
  parameter PC_WD                                            ,
  parameter GPR_WD                                           ,
  parameter GPR_ADDR_WD                                      ,
  parameter CSR_WD                                           ,
  parameter CSR_ADDR_WD                                      ,
  parameter IMM_WD                                           ,
  parameter FS_TO_DS_BUS_WD                                  ,
  parameter DS_TO_ES_BUS_WD                                  ,
  parameter BR_BUS_WD                                        ,
  parameter WS_TO_RF_BUS_WD                                  ,
  parameter DEBUG_BUS_WD
) (
  input                        i_clk                         ,
  input                        i_rst                         ,
  // allowin
  input                        i_es_allowin                  ,
  output                       o_ds_allowin                  ,
  // from fs
  input                        i_fs_to_ds_valid              ,
  input  [FS_TO_DS_BUS_WD-1:0] i_fs_to_ds_bus                , // {fs_inst[31:0], fs_pc[63:0]}
  // to es
  output                       o_ds_to_es_valid              ,
  output [DS_TO_ES_BUS_WD-1:0] o_ds_to_es_bus                ,
  // to fs
  output [BR_BUS_WD-1:0      ] o_br_bus                      ,
  // from ws to rf: for write back
  input  [WS_TO_RF_BUS_WD-1:0] i_ws_to_rf_bus                ,
  // 阻塞解决数据相关性冲突: es, ms, ws 目的寄存器比较
  input  [GPR_ADDR_WD-1:0    ] i_es_to_ds_gpr_rd             ,
  input  [GPR_ADDR_WD-1:0    ] i_ms_to_ds_gpr_rd             ,
  input  [GPR_ADDR_WD-1:0    ] i_ws_to_ds_gpr_rd             ,
  input  [CSR_ADDR_WD-1:0    ] i_es_to_ds_csr_rd             ,
  input  [CSR_ADDR_WD-1:0    ] i_ms_to_ds_csr_rd             ,
  input  [CSR_ADDR_WD-1:0    ] i_ws_to_ds_csr_rd             ,
  // debug
  input  [DEBUG_BUS_WD-1:0   ] i_debug_ws_to_rf_bus          ,
  output [DEBUG_BUS_WD-1:0   ] o_debug_ds_to_es_bus
);

  wire                         ds_valid                      ;
  wire                         ds_ready_go                   ;
  wire                         ds_wb_not_finish              ;
  assign ds_wb_not_finish    = ( (i_es_to_ds_gpr_rd != 0 && (ebreak_sel ? i_es_to_ds_gpr_rd == 5'ha : (i_es_to_ds_gpr_rd == rs1 || i_es_to_ds_gpr_rd == rs2)))
                              || (i_ms_to_ds_gpr_rd != 0 && (ebreak_sel ? i_ms_to_ds_gpr_rd == 5'ha : (i_ms_to_ds_gpr_rd == rs1 || i_ms_to_ds_gpr_rd == rs2)))
                              || (i_ws_to_ds_gpr_rd != 0 && (ebreak_sel ? i_ws_to_ds_gpr_rd == 5'ha : (i_ws_to_ds_gpr_rd == rs1 || i_ws_to_ds_gpr_rd == rs2)))
                              || (i_es_to_ds_csr_rd != 0 && i_es_to_ds_csr_rd == csr)
                              || (i_ms_to_ds_csr_rd != 0 && i_ms_to_ds_csr_rd == csr)
                              || (i_ws_to_ds_csr_rd != 0 && i_ws_to_ds_csr_rd == csr));
  assign ds_ready_go         = ~ds_wb_not_finish;
  assign o_ds_allowin        = (!ds_valid) || (ds_ready_go && i_es_allowin);
  assign o_ds_to_es_valid    = ds_valid && ds_ready_go       ;

  Reg #(
    .WIDTH                    (1                            ),
    .RESET_VAL                (1'b0                         )
  ) u_ds_valid (
    .clk                      (i_clk                        ),
    .rst                      (i_rst                        ),
    .din                      (i_fs_to_ds_valid             ),
    .dout                     (ds_valid                     ),
    .wen                      (o_ds_allowin                 )
  );

  wire [PC_WD-1:0            ] fs_pc                         ;
  wire [FS_TO_DS_BUS_WD-1:0  ] fs_to_ds_bus_r                ;
  assign fs_pc               = i_fs_to_ds_bus[63:0]          ;

  Reg #(
    .WIDTH                    (FS_TO_DS_BUS_WD              ),
    .RESET_VAL                (0                            )
  ) u_fs_to_ds_bus_r (
    .clk                      (i_clk                        ),
    .rst                      (i_rst                        ),
    .din                      (br_taken ? 0 : i_fs_to_ds_bus), // br taken 发生, 将已经if stage 取来的+4地址的指令清空为nop指令
    .dout                     (fs_to_ds_bus_r               ),
    .wen                      (i_fs_to_ds_valid&&o_ds_allowin)
  );

  wire [INST_WD-1:0          ] ds_inst                       ;
  wire [PC_WD-1:0            ] ds_pc                         ;
  assign {ds_inst, ds_pc}    = fs_to_ds_bus_r                ;

  // 通用寄存器
  wire [GPR_ADDR_WD-1:0      ] rs1, rs2                      ;
  wire [GPR_ADDR_WD-1:0      ] rd                            ;
  wire [GPR_WD-1:0           ] rs1data, rs2data              ;
  // 立即数
  wire [IMM_WD-1:0           ] imm                           ;
  // 控制状态寄存器
  wire [CSR_ADDR_WD-1:0      ] csr                           ;
  wire [CSR_WD-1:0           ] csrrdata                      ;

  // idu 产生的控制信号
  wire                         bren                          ; // branch 指令使能
  wire [2:0                  ] brfunc                        ; // branch op
  wire                         alu_src1_sel                  ; // 选择 alu 操作数 1
  wire [1:0                 ]  alu_src2_sel                  ; // 选择 alu 操作数 2
  wire                         alu_word_cut_sel              ; // 字长截断使能
  wire [4:0                  ] alu_op                        ; // alu op
  wire                         gpr_wen                       ; // gpr 写使能
  wire                         csr_ren                       ; // csr 读使能
  wire                         csr_wen                       ; // csr 写使能
  wire                         mem_ren                       ; // mem 读使能
  wire                         mem_wen                       ; // mem 写使能
  wire [2:0                  ] mem_op                        ; // mem 操作 op
  wire                         csr_inst_sel                  ; // write csrrdata to gpr
  wire [2:0                  ] csr_op                        ; // csr 相关逻辑运算操作
  wire                         ebreak_sel                    ; // 环境断点 用于结束运行
  wire                         ecall_sel                     ; // 环境调用 引发环境调用异常来请求执行环境
  wire                         mret_sel                      ; // 机器模式异常状态返回
  wire                         invalid_inst_sel              ; // 译码错误 非法指令

  // ws_to_rf_bus write back stage to rf 用于寄存器写
  wire                         gpr_rf_wen                    ;
  wire [GPR_ADDR_WD-1:0      ] gpr_rf_waddr                  ;
  wire [GPR_WD-1:0           ] gpr_rf_wdata                  ;
  wire                         csr_rf_wen                    ;
  wire [CSR_ADDR_WD-1:0      ] csr_rf_waddr                  ;
  wire [CSR_WD-1:0           ] csr_rf_wdata                  ;

  assign {gpr_rf_wen                                         ,  // 146:146
          gpr_rf_waddr                                       ,  // 145:141
          gpr_rf_wdata                                       ,  // 140:77
          csr_rf_wen                                         ,  // 76 :76
          csr_rf_waddr                                       ,  // 75 :64
          csr_rf_wdata                                          // 63 :0
          }                  = i_ws_to_rf_bus                ;

  // epu to bru 用于 异常发生 跳转
  wire [CSR_WD-1:0           ] mtvec                         ;
  wire [CSR_WD-1:0           ] mepc                          ;
  wire                         ep_sel                        ;
  wire [PC_WD-1:0            ] epnpc                         ;

  // bru 产生 跳转使能 以及目标地址 to if stage
  wire                         br_taken                      ;
  wire                         br_sel                        ;
  wire [PC_WD-1:0            ] br_target                     ;
  assign br_taken            = (br_sel & ~ds_wb_not_finish)
                             ? (br_target != fs_pc)
                             : 0                             ;
  assign o_br_bus            = {br_taken, br_sel, br_target };

  // id stage to ex stage
  assign o_ds_to_es_bus      = {rs1data                      ,  // 358:295
                                rs2data                      ,  // 294:231
                                csrrdata                     ,  // 230:167
                                imm                          ,  // 166:103
                                ds_pc                        ,  // 102:39
                                alu_src1_sel                 ,  //  38:38
                                alu_src2_sel                 ,  //  37:36
                                alu_word_cut_sel             ,  //  35:35
                                alu_op                       ,  //  34:30
                                rd                           ,  //  29:25
                                csr                          ,  //  24:13
                                gpr_wen                      ,  //  12:12
                                csr_wen                      ,  //  11:11
                                mem_ren                      ,  //  10:10
                                mem_wen                      ,  //   9:9
                                mem_op                       ,  //   8:6
                                csr_inst_sel                 ,  //   5:5
                                csr_op                       ,  //   4:2
                                ebreak_sel                   ,  //   1:1
                                invalid_inst_sel                //   0:0
  };

  // debug
  wire [DEBUG_BUS_WD-1:0     ] debug_ws_to_rf_bus_r          ;

  Reg #(
    .WIDTH                    (DEBUG_BUS_WD                 ),
    .RESET_VAL                (0                            )
  ) u_debug_ws_to_rf_bus_r (
    .clk                      (i_clk                        ),
    .rst                      (i_rst                        ),
    .din                      (i_debug_ws_to_rf_bus         ),
    .dout                     (debug_ws_to_rf_bus_r         ),
    .wen                      (1'b1                         )
  );

  wire                         rf_debug_valid                ;
  wire [INST_WD-1:0          ] rf_debug_inst                 ;
  wire [PC_WD-1:0            ] rf_debug_pc                   ;

  assign {rf_debug_valid                                     ,
          rf_debug_inst                                      ,
          rf_debug_pc
         }                   = debug_ws_to_rf_bus_r          ;

  assign o_debug_ds_to_es_bus= {o_ds_to_es_valid             ,  // blocking
                                ds_inst                      ,
                                ds_pc
  };

  always @(*) begin
    if (rf_debug_valid && rf_debug_inst != 0) begin
      finish_handle(rf_debug_pc, {32'b0, rf_debug_inst});
    end
  end

  ysyx_22050710_gpr #(
    .ADDR_WIDTH               (GPR_ADDR_WD                  ),
    .DATA_WIDTH               (GPR_WD                       )
  ) u_gprs (
    .i_clk                    (i_clk                        ),
    // read port 1
    .i_raddr1                 (rs1),
    .o_rdata1                 (rs1data                      ),
    // read port 2
    .i_raddr2                 (rs2                          ),
    .o_rdata2                 (rs2data                      ),
    // write port
    .i_wen                    (gpr_rf_wen                   ),
    .i_waddr                  (gpr_rf_waddr                 ),
    .i_wdata                  (gpr_rf_wdata                 )
  );

  ysyx_22050710_csr #(
    .ADDR_WIDTH               (CSR_ADDR_WD                  ),
    .DATA_WIDTH               (CSR_WD                       )
  ) u_csrs (
    .i_clk                    (i_clk                        ),
    .i_rst                    (i_rst                        ),
    // read port
    .i_ren                    (csr_ren                      ),
    .i_raddr                  (csr                          ),
    .o_csrrdata               (csrrdata                     ),
    // write port
    .i_wen                    (csr_rf_wen                   ),
    .i_waddr                  (csr_rf_waddr                 ),
    .i_wdata                  (csr_rf_wdata                 ),
    // epu bus
    .i_ecall_sel              (ecall_sel                    ),
    .i_mret_sel               (mret_sel                     ),
    .i_epc                    (fs_pc                        ),
    .o_mtvec                  (mtvec                        ),
    .o_mepc                   (mepc                         )
  );

  ysyx_22050710_epu #(
    .CSR_WD                   (CSR_WD                       ),
    .PC_WD                    (PC_WD                        )
  ) u_epu (
    .i_ecall_sel              (ecall_sel                    ),
    .i_mret_sel               (mret_sel                     ),
    .i_mtvec                  (mtvec                        ),
    .i_mepc                   (mepc                         ),
    .o_ep_sel                 (ep_sel                       ),
    .o_epnpc                  (epnpc                        )
  );

  ysyx_22050710_bru #(
    .WORD_WD                  (WORD_WD                      ),
    .PC_WD                    (PC_WD                        ),
    .GPR_WD                   (GPR_WD                       ),
    .IMM_WD                   (IMM_WD                       )
  ) u_bru (
    .i_rs1data                (rs1data                      ),
    .i_rs2data                (rs2data                      ),
    .i_pc                     (ds_pc                        ),
    .i_imm                    (imm                          ),
    // br inst
    .i_bren                   (bren                         ),
    .i_brfunc                 (brfunc                       ),
    // ecall mret
    .i_ep_sel                 (ep_sel                       ),
    .i_epnpc                  (epnpc                        ),
    // output br bus
    .o_br_sel                 (br_sel                       ),
    .o_br_target              (br_target                    )
  );

  ysyx_22050710_idu #(
    .INST_WD                  (INST_WD                      ),
    .GPR_ADDR_WD              (GPR_ADDR_WD                  ),
    .CSR_ADDR_WD              (CSR_ADDR_WD                  ),
    .IMM_WD                   (IMM_WD                       )
  ) u_idu (
    .i_inst                   (ds_inst                      ),
    .o_rs1                    (rs1                          ),
    .o_rs2                    (rs2                          ),
    .o_rd                     (rd                           ),
    .o_imm                    (imm                          ),
    .o_csr                    (csr                          ),
    // to bru
    .o_bren                   (bren                         ),
    .o_brfunc                 (brfunc                       ),
    // to alu
    .o_alu_src1_sel           (alu_src1_sel                 ),
    .o_alu_src2_sel           (alu_src2_sel                 ),
    .o_alu_op                 (alu_op                       ),
    .o_alu_word_cut_sel       (alu_word_cut_sel             ),
    // to es then to ms
    .o_gpr_wen                (gpr_wen                      ),
    .o_csr_ren                (csr_ren                      ),
    .o_csr_wen                (csr_wen                      ),
    .o_mem_wen                (mem_wen                      ),
    .o_mem_ren                (mem_ren                      ),
    .o_mem_op                 (mem_op                       ),
    .o_csr_inst_sel           (csr_inst_sel                 ), // write csrdata to gpr
    // for ecall, ebreak, csr ctrl inst, mret
    .o_csr_op                 (csr_op                       ),
    // for ebreak, ecall, mret
    .o_ebreak_sel             (ebreak_sel                   ),
    .o_ecall_sel              (ecall_sel                    ),
    .o_mret_sel               (mret_sel                     ),
    // invalid inst
    .o_invalid_inst_sel       (invalid_inst_sel             )
  );

endmodule
