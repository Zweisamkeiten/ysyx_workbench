// ysyx_22050710
module ysyx_22050710_ifu (
  input [63:0] i_pc,
  output [31:0] o_inst
);

  wire [63:0] rdata;
  assign o_inst = rdata[63:32];
  always @(*) begin
    npc_pmem_read(i_pc, rdata);
  end
endmodule
