// ysyx_22050710 Program Counter

module ysyx_22050710_pc #(
  parameter PC_WD
) (
  input                        i_clk                         ,
  input                        i_rst                         ,
  input                        i_load                        ,
  input                        i_br_sel                      ,
  input  [PC_WD-1:0          ] i_br_target                   ,
  output [PC_WD-1:0          ] o_pc
);
  
  wire [PC_WD-1:0            ] pc;
  wire [PC_WD-1:0            ] snpc                          ;
  wire [PC_WD-1:0            ] dnpc                          ;

  assign o_pc                = pc;
  assign snpc                = pc + 64'h4;
  assign dnpc                = i_br_sel ? i_br_target : snpc ;

  // 位宽为64bits, 复位值为64'h80000000, 写使能为i_load;
  Reg #(
    .WIDTH                    (PC_WD                        ),
    .RESET_VAL                (64'h80000000                 )
  ) u_pcreg (
    .clk                      (i_clk                        ),
    .rst                      (i_rst                        ),
    .din                      (dnpc                         ),
    .dout                     (pc                           ),
    .wen                      (i_load                       )
  );

endmodule
