// ysyx_22050710
import "DPI-C" function void npc_pmem_read(input longint raddr, output longint rdata);

module ysyx_22050710_ifu (
  input [63:0] i_pc,
  output [31:0] o_inst
);

  always @(*) begin
    pmem_read(i_pc, o_inst);
  end
endmodule
