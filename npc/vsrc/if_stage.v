// ysyx_22050710 Instruction Fetch Unit

module ysyx_22050710_ifu (
  input   i_clk, i_rst,
  input   [63:0] i_pc,
  output  [31:0] o_inst
  /* output  [31:0] o_unused */
);

  wire [63:0] rdata;
  assign o_inst = rdata[63:0] >> {i_pc[2], {31{1'b0}}};
  /* assign o_inst = rdata[31:0]; */
  /* assign o_unused = rdata[63:32]; */

  always @(posedge i_clk) begin
    if (!i_rst) begin
      npc_pmem_read(i_pc, rdata);
    end
  end
endmodule
