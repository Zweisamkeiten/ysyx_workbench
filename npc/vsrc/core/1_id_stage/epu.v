// ysyx_22050710 Excepption unit

module ysyx_22050710_epu #(
  parameter CSR_WD                                           ,
  parameter PC_WD
) (
  input                        i_ecall_sel                   ,
  input                        i_mret_sel                    ,
  input  [CSR_WD-1:0         ] i_mtvec                       ,
  input  [CSR_WD-1:0         ] i_mepc                        ,
  output                       o_ep_sel                      ,
  output [PC_WD-1:0          ] o_epnpc
);

  assign o_ep_sel            = i_ecall_sel | i_mret_sel      ;

  assign o_epnpc             = i_ecall_sel
                             ? i_mtvec
                             : i_mret_sel
                               ? i_mepc
                               : 0                           ;

endmodule
