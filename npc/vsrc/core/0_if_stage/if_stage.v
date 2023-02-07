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
  wire to_fs_valid                                           ;

  assign to_fs_valid         = ~i_rst;
  wire                         br_sel                        ;
  wire [PC_WD-1:0            ] br_target                     ;
  assign {br_sel, br_target} = i_br_bus                      ;

  always @* $display("%x", br_target);

  assign fs_ready_go         = 1'b1                          ;
  assign o_fs_to_ds_valid    = fs_valid && fs_ready_go       ;

  wire [INST_WD-1:0          ] fs_inst                       ;
  wire [PC_WD-1:0            ] fs_pc                         ;
  assign o_fs_to_ds_bus      = {fs_inst, fs_pc}              ;

  Reg #(
    .WIDTH                    (1                            ),
    .RESET_VAL                (1'b0                         )
  ) u_fs_valid (
    .clk                      (i_clk                        ),
    .rst                      (i_rst                        ),
    .din                      (~fs_valid                    ),
    .dout                     (fs_valid                     ),
    .wen                      (1'b1                         )
  );

  ysyx_22050710_pc #(
    .PC_RESETVAL              (PC_RESETVAL                  ),
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
    .SRAM_ADDR_WD             (SRAM_ADDR_WD                 ),
    .SRAM_DATA_WD             (SRAM_DATA_WD                 )
  ) u_ifu (
    .i_to_fs_valid            (to_fs_valid                  ),
    .i_pc                     (fs_pc                        ),
    .o_inst                   (fs_inst                      ),
    // inst sram interface
    .o_inst_sram_en           (o_inst_sram_en               ),
    .o_inst_sram_addr         (o_inst_sram_addr             ),
    .i_inst_sram_rdata        (i_inst_sram_rdata            )
  );

endmodule
