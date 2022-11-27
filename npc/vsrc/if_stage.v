// ysyx_22050710
module ysyx_22050710_ifu (
  input [63:0] i_pc,
  output [31:0] o_inst
);

  always @(*) begin
    npc_pmem_read(i_pc, o_inst);
  end
endmodule
