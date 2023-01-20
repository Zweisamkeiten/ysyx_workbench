// ysyx_22050710 Instruction Fetch Unit

module ysyx_22050710_ifu (
  input   i_clk, i_rst,
  input   [63:0] i_pc,
  output  [31:0] o_inst
);

  wire [63:0] rdata;
  assign o_inst = i_pc[2] == 1'b0 ? rdata[31:0] : rdata[63:32];

  always @(*) begin
    $display("pc: %x", i_pc);
    $display("rdata: %x", rdata);
  end

  always @(*) begin
    if (!i_rst & !i_clk) begin
      npc_pmem_read(i_pc, rdata);
    end
  end
endmodule
