// ysyx_22050710 Program Counter

module ysyx_22050710_pc #(
  parameter PC_RESETVAL                                      ,
  parameter PC_WD                                            ,
  parameter SRAM_ADDR_WD
) (
  input                        i_clk                         ,
  input                        i_rst                         ,
  input                        i_load                        ,
  input                        i_br_taken                    ,
  input  [PC_WD-1:0          ] i_br_target                   ,
  output [PC_WD-1:0          ] o_pc                          ,
  // inst sram interface
  output                       o_inst_sram_ren               ,
  output [SRAM_ADDR_WD-1:0   ] o_inst_sram_addr
);
  
  wire [PC_WD-1:0            ] pc;
  wire [PC_WD-1:0            ] snpc                          ;
  wire [PC_WD-1:0            ] dnpc                          ;

  assign o_pc                = pc;
  assign snpc                = pc + 4;
  assign dnpc                = i_br_taken
                             ? i_br_target
                             : snpc                          ; // 因为分支指令如果依赖的寄存器未写回, 被阻塞在id stage, br_target不是最终的正确跳转地址, 需要增加taken发生

  /* 取指下一周期pc指向的指令
   * bru 控制指令的跳转在 id stage 完成, 使用组合逻辑产生的dnpc
   * 即在本周期"更新 PC 的阶段"就发起对 inst sram 的请求
   * inst sram 的输出是在 if stage 完成
   */
  assign o_inst_sram_ren     = i_load                        ;
  assign o_inst_sram_addr    = dnpc[31:0]                    ;


  // 位宽为64bits, 复位值为64'h80000000, 写使能为i_load;
  Reg #(
    .WIDTH                    (PC_WD                        ),
    .RESET_VAL                (PC_RESETVAL                  )
  ) u_pcreg (
    .clk                      (i_clk                        ),
    .rst                      (i_rst                        ),
    .din                      (dnpc                         ),
    .dout                     (pc                           ),
    .wen                      (i_load                       )
  );

endmodule
