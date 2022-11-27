// ysyx_22050710

module ysyx_22050710_if (
  input i_pc,
  output o_inst
);

  always @(posedge i_clk) begin
    if (!i_rst) begin
      npc_pmem_read(i_pc, rdata);
      /* $display(rdata[31:0]); */
    end
  end
endmodule
