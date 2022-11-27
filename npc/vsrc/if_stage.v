// ysyx_22050710
module ysyx_22050710_ifu (
  input i_clk, i_rst,
  input [63:0] i_pc,
  output [31:0] o_inst,
  output [31:0] o_unused
);

  wire [63:0] rdata;
  assign o_inst = rdata[63:32];
  assign o_unused = rdata[31:0];

  always @(posedge i_clk) begin
    if (i_rst == 0) npc_pmem_read(i_pc, rdata);
  end
endmodule
