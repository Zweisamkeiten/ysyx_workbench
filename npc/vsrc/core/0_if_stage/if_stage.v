// ysyx_22050710 If stage

module ysyx_22050710_if_stage #(
  parameter INST_WD                                          ,
  parameter PC_RESETVAL                                      ,
  parameter PC_WD                                            ,
  parameter FS_TO_DS_BUS_WD                                  ,
  parameter BR_BUS_WD                                        ,
  parameter SRAM_ADDR_WD                                     ,
  parameter SRAM_DATA_WD                        
) (
  input                        i_clk                         ,
  input                        i_rst                         ,
  // allowin
  input                        i_ds_allowin                  ,
  // brbus
  input  [BR_BUS_WD-1:0 ]      i_br_bus                      ,
  // to ds
  output                       o_fs_to_ds_valid              ,
  output [FS_TO_DS_BUS_WD-1:0] o_fs_to_ds_bus                ,
  // inst sram interface
  output                       o_inst_sram_ren               ,
  output [SRAM_ADDR_WD-1:0   ] o_inst_sram_addr              ,
  input  [SRAM_DATA_WD-1:0   ] i_inst_sram_rdata             ,
  input                        i_inst_sram_addr_ok           ,
  input                        i_inst_sram_data_ok
);

  // pre if stage
  wire                         br_stall                      ;
  wire                         br_taken                      ;
  wire [PC_WD-1:0            ] br_target                     ;
  assign {br_stall                                           , // load-to-branch 阻塞一周期, 停止取指
          br_taken                                           , // br taken 发生
          br_target
         }                   = i_br_bus                      ;
  wire                         pre_fs_ready_go               ;
  wire                         pre_fs_to_fs_valid            ;
  assign pre_fs_ready_go     = ~br_stall & i_inst_sram_addr_ok;
  assign pre_fs_to_fs_valid  = ~i_rst & pre_fs_ready_go      ;
  assign o_inst_sram_ren     = fs_allowin                    ;

  // if stage
  wire                         fs_valid                      ;
  wire                         fs_ready_go                   ;
  wire                         fs_allowin                    ;

  assign fs_ready_go         = i_inst_sram_data_ok || fs_inst_with_valid_buffer[INST_WD];
  assign fs_allowin          = (!fs_valid)
                             ||(fs_ready_go && i_ds_allowin) ; // 或条件1: cpu rst后的初始状态, 每个stage都为空闲
                                                               // 或条件2: stage 直接相互依赖, 当后续设计使得当前
                                                               // stage 无法在一周期内完成, ready_go 信号会变得复杂
                                                               // 现在暂时不需要考虑, 因为每个 stage 都能在一周期完成
  assign o_fs_to_ds_valid    = fs_valid && fs_ready_go       ;

  wire [INST_WD-1:0          ] fs_inst                       ;
  wire [INST_WD:0            ] fs_inst_with_valid_buffer     ;
  wire [PC_WD-1:0            ] fs_pc                         ;
  assign o_fs_to_ds_bus      = fs_inst_with_valid_buffer[INST_WD]
                             ? {fs_inst_with_valid_buffer[INST_WD-1:0], fs_pc}
                             : {fs_inst, fs_pc}              ;

  Reg #(
    .WIDTH                    (1                            ),
    .RESET_VAL                (1'b0                         )
  ) u_fs_valid (
    .clk                      (i_clk                        ),
    .rst                      (i_rst                        ),
    .din                      (pre_fs_to_fs_valid           ), // ~reset
    .dout                     (fs_valid                     ),
    .wen                      (fs_allowin                   )
  );

  Reg #(
    .WIDTH                    (INST_WD + 1                  ),
    .RESET_VAL                (0                            )
  ) u_save_inst (
    .clk                      (i_clk                        ),
    .rst                      (i_ds_allowin || i_rst        ),
    .din                      ({i_inst_sram_data_ok, fs_inst}),
    .dout                     (fs_inst_with_valid_buffer    ),
    .wen                      (i_inst_sram_data_ok&&~i_ds_allowin)
  );

  ysyx_22050710_pc #(
    .PC_RESETVAL              (PC_RESETVAL                  ),
    .PC_WD                    (PC_WD                        ),
    .SRAM_ADDR_WD             (SRAM_ADDR_WD                 )
  ) u_pc (
    .i_clk                    (i_clk                        ),
    .i_rst                    (i_rst                        ),
    .i_load                   (pre_fs_to_fs_valid && fs_allowin), // if stage 无数据 ds stage 允许写入 准备下一条指令取指
    .i_br_taken               (br_taken                     ), // br taken 发生
    .i_br_target              (br_target                    ), // 避免控制指令冲突问题
    .o_pc                     (fs_pc                        ),
    .o_inst_sram_addr         (o_inst_sram_addr             )
  );

  ysyx_22050710_ifu #(
    .INST_WD                  (INST_WD                      ),
    .SRAM_DATA_WD             (SRAM_DATA_WD                 )
  ) u_ifu (
    .i_pc_align               (fs_pc[2]                     ), // 取指访问指令sram 64位对齐 根据 pc[2] 选择前32bits还是后32bits
    .o_inst                   (fs_inst                      ),
    // inst sram interface
    .i_inst_sram_rdata        (i_inst_sram_rdata            )
  );

endmodule
