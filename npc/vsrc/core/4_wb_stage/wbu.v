// ysyx_22050710 Write back unit

module ysyx_22050710_wbu #(
  parameter GPR_ADDR_WD                                      ,
  parameter GPR_WD                                           ,
  parameter CSR_ADDR_WD                                      ,
  parameter CSR_WD                                           ,
  parameter WS_TO_RF_BUS_WD
) (
  // gpr
  input                        i_gpr_wen                     ,
  input  [GPR_ADDR_WD-1:0    ] i_gpr_waddr                   ,
  input  [GPR_WD-1:0         ] i_gpr_wdata                   ,
  // csr
  input                        i_csr_wen                     ,
  input  [CSR_ADDR_WD-1:0    ] i_csr_waddr                   ,
  input  [CSR_WD-1:0         ] i_csr_wdata                   ,
  // output to rf bus
  output [WS_TO_RF_BUS_WD-1:0] o_to_rf_bus
);

  assign o_to_rf_bus         = {i_gpr_wen                    ,
                                i_gpr_waddr                  ,
                                i_gpr_wdata                  ,
                                i_csr_wen                    ,
                                i_csr_waddr                  ,
                                i_csr_wdata                 };

endmodule
