// ysyx_22050710 NPC CORE

module ysyx_22050710_core #(
  parameter WORD_WD                                          ,
  parameter PC_RESETVAL                                      ,
  parameter PC_WD                                            ,
  parameter GPR_WD                                           ,
  parameter GPR_ADDR_WD                                      ,
  parameter CSR_WD                                           ,
  parameter CSR_ADDR_WD                                      ,
  parameter IMM_WD                                           ,
  parameter INST_WD                                          ,

  parameter FS_TO_DS_BUS_WD  = `ysyx_22050710_FS_TO_DS_BUS_WD,
  parameter DS_TO_ES_BUS_WD  = `ysyx_22050710_DS_TO_ES_BUS_WD,
  parameter ES_TO_MS_BUS_WD  = `ysyx_22050710_ES_TO_MS_BUS_WD,
  parameter MS_TO_WS_BUS_WD  = `ysyx_22050710_MS_TO_WS_BUS_WD,
  parameter WS_TO_RF_BUS_WD  = `ysyx_22050710_WS_TO_RF_BUS_WD,
  parameter BR_BUS_WD        = `ysyx_22050710_BR_BUS_WD      ,
  parameter DEBUG_BUS_WD     = `ysyx_22050710_DEBUG_BUS_WD   ,
  parameter BYPASS_BUS_WD    = `ysyx_22050710_BYPASS_BUS_WD  ,

  parameter SRAM_ADDR_WD                                     ,
  parameter SRAM_WMASK_WD                                    ,
  parameter SRAM_DATA_WD
) (
  input                        i_clk                         ,
  input                        i_rst                         ,
  // inst sram interface
  output                       o_inst_sram_req               , // 请求信号, 为 1 时有读写请求, 为 0 时无读写请求
  output                       o_inst_sram_op                , // 为 1 表示该次是写请求, 为 0 表示该次是读请求
  output [1:0                ] o_inst_sram_size              , // 该次请求传输的字节数, 0: 1byte; 1: 2bytes; 2: 4bytes; 3: 8bytes
  output [SRAM_ADDR_WD-1:0   ] o_inst_sram_addr              , // 该次请求的地址
  output [SRAM_WMASK_WD-1:0  ] o_inst_sram_wstrb             , // 该次请求的写字节使能
  output [SRAM_DATA_WD-1:0   ] o_inst_sram_wdata             , // 该次写请求的写数据
  input                        i_inst_sram_addr_ok           , // 该次请求的地址传输 OK, 读: 地址被接收; 写: 地址和数据被接收
  input                        i_inst_sram_data_ok           , // 该次请求的数据传输 OK, 读: 数据返回  ; 写: 数据写入完成
  input  [SRAM_DATA_WD-1:0   ] i_inst_sram_rdata             , // 该次请求返回的读数据

  // data sram interface
  output                       o_data_sram_req               , // 请求信号, 为 1 时有读写请求, 为 0 时无读写请求
  output                       o_data_sram_op                , // 为 1 表示该次是写请求, 为 0 表示该次是读请求
  output [1:0                ] o_data_sram_size              , // 该次请求传输的字节数, 0: 1byte; 1: 2bytes; 2: 4bytes; 3: 8bytes
  output [SRAM_ADDR_WD-1:0   ] o_data_sram_addr              , // 该次请求的地址
  output [SRAM_WMASK_WD-1:0  ] o_data_sram_wstrb             , // 该次请求的写字节使能
  output [SRAM_DATA_WD-1:0   ] o_data_sram_wdata             , // 该次写请求的写数据
  input                        i_data_sram_addr_ok           , // 该次请求的地址传输 OK, 读: 地址被接收; 写: 地址和数据被接收
  input                        i_data_sram_data_ok           , // 该次请求的数据传输 OK, 读: 数据返回  ; 写: 数据写入完成
  input  [SRAM_DATA_WD-1:0   ] i_data_sram_rdata               // 该次请求返回的读数据
);

  wire                         ds_allowin                    ;
  wire                         es_allowin                    ;
  wire                         ms_allowin                    ;
  wire                         ws_allowin                    ;
  wire                         fs_to_ds_valid                ;
  wire                         ds_to_es_valid                ;
  wire                         es_to_ms_valid                ;
  wire                         ms_to_ws_valid                ;
  wire [FS_TO_DS_BUS_WD-1:0  ] fs_to_ds_bus                  ;
  wire [DS_TO_ES_BUS_WD-1:0  ] ds_to_es_bus                  ;
  wire [ES_TO_MS_BUS_WD-1:0  ] es_to_ms_bus                  ;
  wire [MS_TO_WS_BUS_WD-1:0  ] ms_to_ws_bus                  ;
  wire [WS_TO_RF_BUS_WD-1:0  ] ws_to_rf_bus                  ;
  wire [BR_BUS_WD-1:0        ] br_bus                        ;

  wire [BYPASS_BUS_WD-1:0    ] es_to_ds_bypass_bus           ;
  wire [BYPASS_BUS_WD-1:0    ] ms_to_ds_bypass_bus           ;
  wire [BYPASS_BUS_WD-1:0    ] ws_to_ds_bypass_bus           ;

  // for load stall
  wire                         es_to_ds_load_sel             ;

  wire                         ms_data_stall                 ;
  wire                         flush_br_buf                  ;

  // debug
  wire [DEBUG_BUS_WD-1:0     ] debug_ds_to_es_bus            ;
  wire [DEBUG_BUS_WD-1:0     ] debug_es_to_ms_bus            ;
  wire [DEBUG_BUS_WD-1:0     ] debug_ms_to_ws_bus            ;
  wire [DEBUG_BUS_WD-1:0     ] debug_ws_to_rf_bus            ;
  wire                         debug_ws_to_rf_valid          ;

  ysyx_22050710_if_stage #(
    .INST_WD                  (INST_WD                      ),
    .PC_RESETVAL              (PC_RESETVAL                  ),
    .PC_WD                    (PC_WD                        ),
    .FS_TO_DS_BUS_WD          (FS_TO_DS_BUS_WD              ),
    .BR_BUS_WD                (BR_BUS_WD                    ),
    .SRAM_ADDR_WD             (SRAM_ADDR_WD                 ),
    .SRAM_DATA_WD             (SRAM_DATA_WD                 ),
    .SRAM_WMASK_WD            (SRAM_WMASK_WD                )
  ) u_if_stage (
    .i_clk                    (i_clk                        ),
    .i_rst                    (i_rst                        ),
    // allowin
    .i_ds_allowin             (ds_allowin                   ),
    // br bus
    .i_br_bus                 (br_bus                       ),
    .o_flush_br_buf           (flush_br_buf                 ),
    // output
    .o_fs_to_ds_valid         (fs_to_ds_valid               ),
    .o_fs_to_ds_bus           (fs_to_ds_bus                 ),
    // inst sram interface
    .o_inst_sram_req          (o_inst_sram_req              ),
    .o_inst_sram_op           (o_inst_sram_op               ),
    .o_inst_sram_size         (o_inst_sram_size             ),
    .o_inst_sram_addr         (o_inst_sram_addr             ),
    .o_inst_sram_wstrb        (o_inst_sram_wstrb            ),
    .o_inst_sram_wdata        (o_inst_sram_wdata            ),
    .i_inst_sram_addr_ok      (i_inst_sram_addr_ok          ),
    .i_inst_sram_data_ok      (i_inst_sram_data_ok          ),
    .i_inst_sram_rdata        (i_inst_sram_rdata            )
  );

  ysyx_22050710_id_stage #(
    .WORD_WD                  (WORD_WD                      ),
    .INST_WD                  (INST_WD                      ),
    .PC_WD                    (PC_WD                        ),
    .GPR_WD                   (GPR_WD                       ),
    .GPR_ADDR_WD              (GPR_ADDR_WD                  ),
    .IMM_WD                   (IMM_WD                       ),
    .CSR_WD                   (CSR_WD                       ),
    .CSR_ADDR_WD              (CSR_ADDR_WD                  ),
    .FS_TO_DS_BUS_WD          (FS_TO_DS_BUS_WD              ),
    .DS_TO_ES_BUS_WD          (DS_TO_ES_BUS_WD              ),
    .BR_BUS_WD                (BR_BUS_WD                    ),
    .WS_TO_RF_BUS_WD          (WS_TO_RF_BUS_WD              ),
    .BYPASS_BUS_WD            (BYPASS_BUS_WD                ),
    .DEBUG_BUS_WD             (DEBUG_BUS_WD                 )
  ) u_id_stage (
    .i_clk                    (i_clk                        ),
    .i_rst                    (i_rst                        ),
    // allowin
    .i_es_allowin             (es_allowin                   ),
    .o_ds_allowin             (ds_allowin                   ),
    // from fs
    .i_fs_to_ds_valid         (fs_to_ds_valid               ),
    .i_fs_to_ds_bus           (fs_to_ds_bus                 ),
    // to es
    .o_ds_to_es_valid         (ds_to_es_valid               ),
    .o_ds_to_es_bus           (ds_to_es_bus                 ),
    // to fs
    .o_br_bus                 (br_bus                       ),
    // from fs
    .i_flush_br_buf           (flush_br_buf                 ),
    // from ws to rf: for write back
    .i_ws_to_rf_bus           (ws_to_rf_bus                 ),
    // for load stall
    .i_es_to_ds_load_sel      (es_to_ds_load_sel            ),
    .i_ms_data_stall          (ms_data_stall                ),
    // 前递 forward 解决数据相关性冲突:
    // 流水线组合逻辑结果前递到译码级寄存器读出
    .i_es_to_ds_bypass_bus    (es_to_ds_bypass_bus          ),
    .i_ms_to_ds_bypass_bus    (ms_to_ds_bypass_bus          ),
    .i_ws_to_ds_bypass_bus    (ws_to_ds_bypass_bus          ),
    // debug
    .i_debug_ws_to_rf_valid   (debug_ws_to_rf_valid         ),
    .i_debug_ws_to_rf_bus     (debug_ws_to_rf_bus           ),
    .o_debug_ds_to_es_bus     (debug_ds_to_es_bus           )
  );

  ysyx_22050710_ex_stage #(
    .WORD_WD                  (WORD_WD                      ),
    .PC_WD                    (PC_WD                        ),
    .INST_WD                  (INST_WD                      ),
    .GPR_WD                   (GPR_WD                       ),
    .GPR_ADDR_WD              (GPR_ADDR_WD                  ),
    .IMM_WD                   (IMM_WD                       ),
    .CSR_WD                   (CSR_WD                       ),
    .CSR_ADDR_WD              (CSR_ADDR_WD                  ),
    .DS_TO_ES_BUS_WD          (DS_TO_ES_BUS_WD              ),
    .ES_TO_MS_BUS_WD          (ES_TO_MS_BUS_WD              ),
    .BYPASS_BUS_WD            (BYPASS_BUS_WD                ),
    .SRAM_ADDR_WD             (SRAM_ADDR_WD                 ),
    .SRAM_WMASK_WD            (SRAM_WMASK_WD                ),
    .SRAM_DATA_WD             (SRAM_DATA_WD                 ),
    .DEBUG_BUS_WD             (DEBUG_BUS_WD                 )
  ) u_ex_stage (
    .i_clk                    (i_clk                        ),
    .i_rst                    (i_rst                        ),
    // allowin
    .i_ms_allowin             (ms_allowin                   ),
    .o_es_allowin             (es_allowin                   ),
    // from ds
    .i_ds_to_es_valid         (ds_to_es_valid               ),
    .i_ds_to_es_bus           (ds_to_es_bus                 ),
    // to ms
    .o_es_to_ms_valid         (es_to_ms_valid               ),
    .o_es_to_ms_bus           (es_to_ms_bus                 ),
    // for load stall
    .o_es_to_ds_load_sel      (es_to_ds_load_sel            ),
    // bypass
    .o_es_to_ds_bypass_bus    (es_to_ds_bypass_bus          ),
    // data sram interface
    .o_data_sram_req          (o_data_sram_req              ), // data ram 读请求或写请求是在 ex stage 发出
    .o_data_sram_op           (o_data_sram_op               ), // data ram 的读数据在mem stage 返回
    .o_data_sram_size         (o_data_sram_size             ),
    .o_data_sram_addr         (o_data_sram_addr             ),
    .o_data_sram_wstrb        (o_data_sram_wstrb            ),
    .o_data_sram_wdata        (o_data_sram_wdata            ),
    .i_data_sram_addr_ok      (i_data_sram_addr_ok          ),
    // debug
    .i_debug_ds_to_es_bus     (debug_ds_to_es_bus           ),
    .o_debug_es_to_ms_bus     (debug_es_to_ms_bus           )
  );

  ysyx_22050710_mem_stage #(
    .WORD_WD                  (WORD_WD                      ),
    .PC_WD                    (PC_WD                        ),
    .INST_WD                  (INST_WD                      ),
    .GPR_ADDR_WD              (GPR_ADDR_WD                  ),
    .CSR_ADDR_WD              (CSR_ADDR_WD                  ),
    .ES_TO_MS_BUS_WD          (ES_TO_MS_BUS_WD              ),
    .MS_TO_WS_BUS_WD          (MS_TO_WS_BUS_WD              ),
    .BYPASS_BUS_WD            (BYPASS_BUS_WD                ),
    .SRAM_DATA_WD             (SRAM_DATA_WD                 ),
    .DEBUG_BUS_WD             (DEBUG_BUS_WD                 )
  ) u_mem_stage (
    .i_clk                    (i_clk                        ),
    .i_rst                    (i_rst                        ),
    // allowin
    .i_ws_allowin             (ws_allowin                   ),
    .o_ms_allowin             (ms_allowin                   ),
    // to ds
    .o_ms_data_stall          (ms_data_stall                ),
    // from es
    .i_es_to_ms_valid         (es_to_ms_valid               ),
    .i_es_to_ms_bus           (es_to_ms_bus                 ),
    // to ws
    .o_ms_to_ws_valid         (ms_to_ws_valid               ),
    .o_ms_to_ws_bus           (ms_to_ws_bus                 ),
    // from data-sram
    .i_data_sram_data_ok      (i_data_sram_data_ok          ),
    .i_data_sram_rdata        (i_data_sram_rdata            ), // data ram 读数据返回 进入 lsu 进行处理
    // bypass
    .o_ms_to_ds_bypass_stall  (ms_to_ds_bypass_stall        ),
    .o_ms_to_ds_bypass_bus    (ms_to_ds_bypass_bus          ),
    // debug
    .i_debug_es_to_ms_bus     (debug_es_to_ms_bus           ),
    .o_debug_ms_to_ws_bus     (debug_ms_to_ws_bus           )
  );

  ysyx_22050710_wb_stage #(
    .WORD_WD                  (WORD_WD                      ),
    .PC_WD                    (PC_WD                        ),
    .INST_WD                  (INST_WD                      ),
    .GPR_ADDR_WD              (GPR_ADDR_WD                  ),
    .GPR_WD                   (GPR_WD                       ),
    .CSR_ADDR_WD              (CSR_ADDR_WD                  ),
    .CSR_WD                   (CSR_WD                       ),
    .MS_TO_WS_BUS_WD          (MS_TO_WS_BUS_WD              ),
    .WS_TO_RF_BUS_WD          (WS_TO_RF_BUS_WD              ),
    .BYPASS_BUS_WD            (BYPASS_BUS_WD                ),
    .DEBUG_BUS_WD             (DEBUG_BUS_WD                 )
  ) u_wb_stage (
    .i_clk                    (i_clk                        ),
    .i_rst                    (i_rst                        ),
    // allowin
    .o_ws_allowin             (ws_allowin                   ),
    // from ms
    .i_ms_to_ws_valid         (ms_to_ws_valid               ),
    .i_ms_to_ws_bus           (ms_to_ws_bus                 ),
    // to rf
    .o_ws_to_rf_bus           (ws_to_rf_bus                 ),
    // bypass
    .o_ws_to_ds_bypass_bus    (ws_to_ds_bypass_bus          ),
    // debug
    .i_debug_ms_to_ws_bus     (debug_ms_to_ws_bus           ),
    .o_debug_ws_to_rf_valid   (debug_ws_to_rf_valid         ),
    .o_debug_ws_to_rf_bus     (debug_ws_to_rf_bus           )
  );

endmodule
