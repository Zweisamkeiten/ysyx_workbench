// ysyx_22050710 Control Status arithmetic and logic unit

module ysyx_22050710_csu #(
  parameter GPR_WD                                           ,
  parameter WORD_WD                                          ,
  parameter CSR_WD
) (
  input  [GPR_WD-1:0         ] i_rs1data                     ,
  input  [CSR_WD-1:0         ] i_csrrdata                    ,
  input  [WORD_WD-1:0        ] i_imm                         ,
  input  [2:0                ] i_csr_op                      ,
  input                        i_csr_imm_rs1_sel             ,
  output [CSR_WD-1:0         ] o_csr_result
);

  wire [WORD_WD-1:0          ] csr_oprand                    ;
  assign csr_oprand          = i_csr_imm_rs1_sel
                             ? i_imm
                             : i_rs1data                     ;

  MuxKeyWithDefault #(.NR_KEY(2), .KEY_LEN(3), .DATA_LEN(CSR_WD)) u_mux0 (
    .out(o_csr_result),
    .key(i_csr_op),
    .default_out(64'b0),
    .lut({
      3'b001, csr_oprand, // csrrw
      3'b101, csr_oprand, // csrrwi
      3'b010, i_csrrdata | csr_oprand // csrrs
    })
  );

endmodule
