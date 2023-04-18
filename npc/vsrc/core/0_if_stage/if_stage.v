// ysyx_22050710 If stage

module ysyx_22050710_if_stage #(
  parameter INST_WD                                          ,
  parameter PC_RESETVAL                                      ,
  parameter PC_WD                                            ,
  parameter FS_TO_DS_BUS_WD                                  ,
  parameter BR_BUS_WD                                        ,
  parameter SRAM_ADDR_WD                                     ,
  parameter SRAM_DATA_WD                                     ,
  parameter SRAM_WMASK_WD
) (
  input                        i_clk                         ,
  input                        i_rst                         ,
  // allowin
  input                        i_ds_allowin                  ,
  // brbus
  input  [BR_BUS_WD-1:0 ]      i_br_bus                      ,
  output                       o_flush_br_buf                ,
  // to ds
  output                       o_fs_to_ds_valid              ,
  output [FS_TO_DS_BUS_WD-1:0] o_fs_to_ds_bus                ,
  // inst sram
  output                       o_inst_sram_req               , // 请求信号, 为 1 时有读写请求, 为 0 时无读写请求
  output                       o_inst_sram_op                , // 为 1 表示该次是写请求, 为 0 表示该次是读请求
  output [1:0                ] o_inst_sram_size              , // 该次请求传输的字节数, 0: 1byte; 1: 2bytes; 2: 4bytes; 3: 8bytes
  output [SRAM_ADDR_WD-1:0   ] o_inst_sram_addr              , // 该次请求的地址
  output [SRAM_WMASK_WD-1:0  ] o_inst_sram_wstrb             , // 该次请求的写字节使能
  output [SRAM_DATA_WD-1:0   ] o_inst_sram_wdata             , // 该次写请求的写数据
  input                        i_inst_sram_addr_ok           , // 该次请求的地址传输 OK, 读: 地址被接收; 写: 地址和数据被接收
  input                        i_inst_sram_data_ok           , // 该次请求的数据传输 OK, 读: 数据返回  ; 写: 数据写入完成
  input  [SRAM_DATA_WD-1:0   ] i_inst_sram_rdata               // 该次请求返回的读数据
);

  assign o_inst_sram_req     = fs_allowin                    ;
  assign o_inst_sram_op      = 0                             ; // 恒为 0, 表示只有读请求
  assign o_inst_sram_size    = 2'd2                          ; // 恒为 2, 表示每次请求 4 bytes
  assign o_inst_sram_wstrb   = 0                             ; // 恒为 0, 没有写请求
  assign o_inst_sram_wdata   = 0                             ; // 恒为 0, 没有写请求

  wire                         req_fire                      ;
  wire                         resp_fire                     ;
  assign req_fire            = o_inst_sram_req && i_inst_sram_addr_ok;
  assign resp_fire           = i_inst_sram_data_ok           ; // master 对于数据响应总是可以接收

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
  assign pre_fs_ready_go     = ~br_stall & req_fire          ;
  assign pre_fs_to_fs_valid  = ~i_rst & pre_fs_ready_go      ;

  // if stage
  wire                         fs_valid                      ;
  wire                         fs_ready_go                   ;
  wire                         fs_allowin                    ;

  assign fs_ready_go         = resp_fire || fs_inst_with_valid_buffer[INST_WD];
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
    .din                      ({resp_fire, fs_inst         }),
    .dout                     (fs_inst_with_valid_buffer    ),
    .wen                      (resp_fire && ~i_ds_allowin   )
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

  assign o_flush_br_buf      = o_fs_to_ds_valid && i_ds_allowin;

endmodule
