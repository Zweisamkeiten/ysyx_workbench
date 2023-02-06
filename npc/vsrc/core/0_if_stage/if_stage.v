// ysyx_22050710
module ysyx_22050710_if_stage #(
  parameter INST_WD                                          ,
  parameter PC_WD                                            ,
  parameter FS_TO_DS_BUS_WD                                  ,
  parameter BR_BUS_WD                                        ,
  parameter SRAM_ADDR_WD                                     ,
  parameter SRAM_DATA_WD                        
) (
  input                        i_clk                         ,
  input                        i_rst                         ,
  // brbus
  input  [BR_BUS_WD-1:0 ]      i_br_bus                      ,
  // to ds
  output                       o_fs_to_ds_valid              ,
  output [FS_TO_DS_BUS_WD-1:0] o_fs_to_ds_bus                ,
  // inst sram interface
  output                       o_inst_sram_en                ,
  output [SRAM_ADDR_WD-1:0   ] o_inst_sram_addr              ,
  input  [SRAM_DATA_WD-1:0   ] i_inst_sram_rdata
);

  wire fs_valid                                              ;
  wire fs_ready_go                                           ;
  wire fs_allowin                                            ;
  wire to_fs_valid                                           ;

  wire                         br_sel                        ;
  wire [PC_WD-1:0            ] br_target                     ;
  assign {br_sel, br_target} = i_br_bus                      ;

  assign fs_ready_go         = 1'b1                          ;
  assign o_fs_to_ds_valid    = fs_valid && fs_ready_go       ;

  wire [INST_WD-1:0          ] fs_inst                       ;
  wire [PC_WD-1:0            ] fs_pc                         ;
  assign o_fs_to_ds_bus      = {fs_inst, fs_pc}              ;

  ysyx_22050710_pc #(
    .PC_WD                    (PC_WD                        )
  ) u_pc (
    .i_clk                    (i_clk                        ),
    .i_rst                    (i_rst                        ),
    .i_load                   (fs_valid                     ), // if stage 有数据发往 id stage, pc 写使能 为下一周期准备
    .i_br_sel                 (br_sel                       ),
    .i_br_target              (br_target                    ),
    .o_pc                     (fs_pc                        )
  );

  ysyx_22050710_ifu #(
    .INST_WD                  (INST_WD                      ),
    .PC_WD                    (PC_WD                        ),
    .SRAM_ADDR_WD             (SRAM_ADDR_WD                 )
  ) u_ifu (
    .i_clk                    (i_clk                        ),
    .i_rst                    (i_rst                        ),
    .o_ifu_ready              (fs_valid                     ),
    .i_pc                     (fs_pc                        ),
    .o_inst                   (fs_inst                      ),
    // inst sram interface
    .o_inst_sram_en           (o_inst_sram_en               ),
    .o_inst_sram_addr         (o_inst_sram_addr             ),
    .i_inst_sram_rdata        (i_inst_sram_rdata            )
  );

endmodule
