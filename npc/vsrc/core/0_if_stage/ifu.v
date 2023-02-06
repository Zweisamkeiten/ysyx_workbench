// ysyx_22050710 Instruction Fetch Unit

module ysyx_22050710_ifu #(
  parameter INST_WD                                          ,
  parameter PC_WD                                            ,
  parameter SRAM_ADDR_WD                                     ,
  parameter SRAM_DATA_WD                        
) (
  input                        i_clk                         ,
  input                        i_rst                         ,
  input  [PC_WD-1:0          ] i_pc                          ,
  output                       o_ifu_ready                   ,
  output [INST_WD-1:0        ] o_inst                        ,
  // inst sram interface
  output                       o_inst_sram_en                ,
  output [SRAM_ADDR_WD-1:0   ] o_inst_sram_addr              ,
  input  [SRAM_DATA_WD-1:0   ] i_inst_sram_rdata
);

  assign o_inst              = i_pc[2] == 1'b0
                             ? i_inst_sram_rdata[31:0]
                             : i_inst_sram_rdata[63:32]      ;

  always @(posedge i_clk) begin
    if (!i_rst) begin
      if (ready) ready <= 1'b0;
      else ready <= 1'b1;
    end
  end

  reg ready                  = 1'b0                          ;
  assign o_ifu_ready         = ready                         ;

  assign o_inst_sram_en      = 1'b1                          ;
  assign o_inst_sram_addr    = i_pc[31:0]                    ;

endmodule
