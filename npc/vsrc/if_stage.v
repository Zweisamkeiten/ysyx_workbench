// ysyx_22050710 Instruction Fetch Unit

module ysyx_22050710_ifu (
  input   i_clk, i_rst,
  input   [63:0] i_pc,
  output reg [31:0] o_inst
);

  wire [63:0] rdata;
  /* assign o_inst = i_pc[2] == 1'b0 ? rdata[31:0] : rdata[63:32]; */

  always @(posedge i_clk) begin
    o_inst <= 64'b0;
    if (!i_rst) begin
      npc_pmem_read(i_pc, rdata);
      o_inst <= i_pc[2] == 1'b0 ? rdata[31:0] : rdata[63:32];
    end
  end
endmodule
