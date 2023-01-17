// ysyx_22050710 Instruction Fetch Unit

module ysyx_22050710_ifu (
  input   i_clk, i_rst,
  input   [63:0] i_pc,
  output  [31:0] o_inst
  /* output  [31:0] o_unused */
);

  wire [63:0] rdata;
  assign o_inst = i_pc[2] == 1'b0 ? rdata[31:0] : rdata[63:32];
  /* assign o_unused = rdata[63:32]; */

  always @(posedge i_clk) begin
    if (!i_rst) begin
      $display("%x", i_pc[2] == 1'b0);
      npc_pmem_read(i_pc, rdata);
    end
  end
endmodule
