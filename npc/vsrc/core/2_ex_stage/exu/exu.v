// ysyx_22050710 Execute Unit

import "DPI-C" function void set_state_end();
import "DPI-C" function void set_state_abort();

module ysyx_22050710_exu #(
  parameter WORD_WD                                          ,
  parameter PC_WD                                            ,
  parameter GPR_WD                                           ,
  parameter CSR_WD                                           ,
  parameter IMM_WD
) (
  // oprand
  input  [GPR_WD-1:0         ] i_rs1data                     ,
  input  [GPR_WD-1:0         ] i_rs2data                     ,
  input  [IMM_WD-1:0         ] i_imm                         ,
  input  [PC_WD-1:0          ] i_pc                          ,
  input  [CSR_WD-1:0         ] i_csrrdata                    ,
  // alu control
  input                        i_alu_src1_sel                ,
  input  [1:0                ] i_alu_src2_sel                ,
  input  [4:0                ] i_alu_op                      ,
  input                        i_alu_word_cut_sel            ,
  // csr 运算操作
  input  [2:0                ] i_csr_op                      ,
  // ebreak
  input                        i_ebreak_sel                  ,
  // invalid inst
  input                        i_invalid_inst_sel            ,
  // output
  output [WORD_WD-1:0        ] o_alu_result                  ,
  output [WORD_WD-1:0        ] o_csr_result
);

  // word_cut: cut operand to 32bits and unsigned extend OR dont cut
  wire [WORD_WD-1:0   ] src1 = i_alu_word_cut_sel ? {{32{1'b0}}, i_rs1data[31:0]} : i_rs1data;
  wire [WORD_WD-1:0   ] src2 = i_alu_word_cut_sel ? {{32{1'b0}}, i_rs2data[31:0]} : i_rs2data;
  wire [WORD_WD-1:0   ] imm  = i_alu_word_cut_sel ? {{32{1'b0}}, i_imm[31:0]} : i_imm;

  // ALU
  wire [WORD_WD-1:0          ] src_a                         ;
  wire [WORD_WD-1:0          ] src_b                         ;

  assign src_a               = i_alu_src1_sel ? i_pc : src1  ;
  MuxKey #(.NR_KEY(3), .KEY_LEN(2), .DATA_LEN(64)) u_mux0 (
    .out(src_b),
    .key(i_alu_src2_sel),
    .lut({
      2'b00, src2,
      2'b01, imm,
      2'b10, 64'd4
    })
  );

  ysyx_22050710_alu #(
    .WORD_WD                  (WORD_WD                      )
  ) u_alu (
    .i_src_a                  (src_a                        ),
    .i_src_b                  (src_b                        ),
    .i_alu_op                 (i_alu_op                     ),
    .i_alu_word_cut_sel       (i_alu_word_cut_sel           ),
    .o_alu_result             (o_alu_result                 )
  );

  wire                         csr_imm_rs1_sel              ;
  assign csr_imm_rs1_sel     = i_alu_src2_sel == 2'b01      ;
  ysyx_22050710_csu #(
    .GPR_WD                   (GPR_WD                       ),
    .WORD_WD                  (WORD_WD                      ),
    .CSR_WD                   (CSR_WD                       )
  ) u_csu (
    .i_rs1data                (i_rs1data                    ),
    .i_csrrdata               (i_csrrdata                   ),
    .i_imm                    (i_imm                        ),
    .i_csr_op                 (i_csr_op                     ),
    .i_csr_imm_rs1_sel        (csr_imm_rs1_sel            ),
    .o_csr_result             (o_csr_result                 )
  );

  always @(*) begin
    if (i_ebreak_sel) begin
      set_state_end(); // ebreak
    end
  end

  always @(i_invalid_inst_sel) begin // 敏感变量只有 i_is_invalid_inst, reset(10) 因此只处理一次
    if (i_invalid_inst_sel) set_state_abort(); // invalid inst
  end

endmodule
