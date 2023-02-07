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

  parameter SRAM_ADDR_WD                                     ,
  parameter SRAM_DATA_WD
) (
  input                        i_clk                         ,
  input                        i_rst                         ,
  // inst sram interface
  output                       o_inst_sram_en                ,
  output [SRAM_ADDR_WD-1:0   ] o_inst_sram_addr              ,
  input  [SRAM_DATA_WD-1:0   ] i_inst_sram_rdata
);

  /* wire         ds_allowin; */
  /* wire         es_allowin; */
  /* wire         ms_allowin; */
  /* wire         ws_allowin; */
  wire                         fs_to_ds_valid                ;
  /* wire         ds_to_es_valid; */
  /* wire         es_to_ms_valid; */
  /* wire         ms_to_ws_valid; */
  wire [FS_TO_DS_BUS_WD-1:0  ] fs_to_ds_bus                  ;
  wire [DS_TO_ES_BUS_WD-1:0  ] ds_to_es_bus                  ;
  wire [ES_TO_MS_BUS_WD-1:0  ] es_to_ms_bus                  ;
  wire [MS_TO_WS_BUS_WD -1:0 ] ms_to_ws_bus                  ;
  wire [WS_TO_RF_BUS_WD -1:0 ] ws_to_rf_bus                  ;
  wire [BR_BUS_WD-1:0        ] br_bus                        ;

  ysyx_22050710_if_stage #(
    .INST_WD                  (INST_WD                      ),
    .PC_RESETVAL              (PC_RESETVAL                  ),
    .PC_WD                    (PC_WD                        ),
    .FS_TO_DS_BUS_WD          (FS_TO_DS_BUS_WD              ),
    .BR_BUS_WD                (BR_BUS_WD                    ),
    .SRAM_ADDR_WD             (SRAM_ADDR_WD                 ),
    .SRAM_DATA_WD             (SRAM_DATA_WD                 )
  ) u_if_stage (
    .i_clk                    (i_clk                        ),
    .i_rst                    (i_rst                        ),
    // br bus
    .i_br_bus                 (br_bus                       ),
    // output
    .o_fs_to_ds_valid         (fs_to_ds_valid               ),
    .o_fs_to_ds_bus           (fs_to_ds_bus                 ),
    // inst sram interface
    .o_inst_sram_en           (o_inst_sram_en               ),
    .o_inst_sram_addr         (o_inst_sram_addr             ),
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
    .WS_TO_RF_BUS_WD          (WS_TO_RF_BUS_WD              )
  ) u_id_stage (
    .i_clk                    (i_clk                        ),
    .i_rst                    (i_rst                        ),
    // from fs
    .i_fs_to_ds_valid         (fs_to_ds_valid               ),
    .i_fs_to_ds_bus           (fs_to_ds_bus                 ),
    // to es
    .o_ds_to_es_bus           (ds_to_es_bus                 ),
    // to fs
    .o_br_bus                 (br_bus                       ),
    // from ws to rf: for write back
    .i_ws_to_rf_bus           (ws_to_rf_bus                 )
  );

  ysyx_22050710_ex_stage #(
    .WORD_WD                  (WORD_WD                      ),
    .PC_WD                    (PC_WD                        ),
    .GPR_WD                   (GPR_WD                       ),
    .GPR_ADDR_WD              (GPR_ADDR_WD                  ),
    .IMM_WD                   (IMM_WD                       ),
    .CSR_WD                   (CSR_WD                       ),
    .CSR_ADDR_WD              (CSR_ADDR_WD                  ),
    .DS_TO_ES_BUS_WD          (DS_TO_ES_BUS_WD              ),
    .ES_TO_MS_BUS_WD          (ES_TO_MS_BUS_WD              )
  ) u_ex_stage (
    /* .i_clk                    (i_clk                        ), */
    /* .i_rst                    (i_rst                        ), */
    // from ds
    .i_ds_to_es_bus           (ds_to_es_bus                 ),
    // to ms
    .o_es_to_ms_bus           (es_to_ms_bus                 )
  );

  ysyx_22050710_mem_stage #(
    .WORD_WD                  (WORD_WD                      ),
    .GPR_ADDR_WD              (GPR_ADDR_WD                  ),
    .CSR_ADDR_WD              (CSR_ADDR_WD                  ),
    .ES_TO_MS_BUS_WD          (ES_TO_MS_BUS_WD              ),
    .MS_TO_WS_BUS_WD          (MS_TO_WS_BUS_WD              )
  ) u_mem_stage (
    .i_clk                    (i_clk                        ),
    .i_rst                    (i_rst                        ),
    // from es
    .i_es_to_ms_bus           (es_to_ms_bus                 ),
    // to ws
    .o_ms_to_ws_bus           (ms_to_ws_bus                 )
  );

  ysyx_22050710_wb_stage #(
    .WORD_WD                  (WORD_WD                      ),
    .GPR_ADDR_WD              (GPR_ADDR_WD                  ),
    .GPR_WD                   (GPR_WD                       ),
    .CSR_ADDR_WD              (CSR_ADDR_WD                  ),
    .CSR_WD                   (CSR_WD                       ),
    .MS_TO_WS_BUS_WD          (MS_TO_WS_BUS_WD              ),
    .WS_TO_RF_BUS_WD          (WS_TO_RF_BUS_WD              )
  ) u_wb_stage (
    /* .i_clk                    (i_clk                        ), */
    /* .i_rst                    (i_rst                        ), */
    // from ms
    .i_ms_to_ws_bus           (ms_to_ws_bus                 ),
    // to rf
    .o_ws_to_rf_bus           (ws_to_rf_bus                 )
  );

endmodule
