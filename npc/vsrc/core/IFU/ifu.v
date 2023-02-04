// ysyx_22050710 Instruction Fetch Unit

module ysyx_22050710_ifu (
  input   i_clk, i_rst,
  input   i_nextpc,
  output  [63:0] o_pc,
  output  [31:0] o_inst
);

  wire [63:0] pc;
  ysyx_22050710_pc u_pc (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_load(1'b1),
    .i_in(i_nextpc),
    .o_pc(pc)
  );

  reg [63:0] rdata;
  assign o_inst = pc[2] == 1'b0 ? rdata[31:0] : rdata[63:32];

  always @(posedge i_clk) begin
    if (!i_rst) begin
      npc_pmem_read(pc, rdata);
    end
  end

  assign o_pc = pc;

endmodule
