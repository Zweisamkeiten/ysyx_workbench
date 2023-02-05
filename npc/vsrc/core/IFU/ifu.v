// ysyx_22050710 Instruction Fetch Unit

module ysyx_22050710_ifu #(INST_WIDTH = 32, DATA_WIDTH = 64) (
  input   i_clk, i_rst,
  input   [DATA_WIDTH-1:0] i_nextpc,
  output  [DATA_WIDTH-1:0] o_pc,
  output  [INST_WIDTH-1:0] o_inst,
  output  o_ifu_ready

  /* output        o_inst_sram_en   , */
  /* output [ 3:0] o_inst_sram_wen  , */
  /* output [DATA_WIDTH-1:0] o_inst_sram_addr , */
  /* output [DATA_WIDTH-1:0] o_inst_sram_wdata, */
  /* input  [DATA_WIDTH-1:0] i_inst_sram_rdata */
);

  wire [DATA_WIDTH-1:0] pc;
  ysyx_22050710_pc u_pc (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_load(1'b1),
    .i_in(nextpc),
    .o_pc(pc)
  );

  reg [DATA_WIDTH-1:0] rdata;
  assign o_inst = pc[2] == 1'b0 ? rdata[31:0] : rdata[63:32];

  reg [DATA_WIDTH-1:0] nextpc;
  always @(posedge i_clk) begin
    if (ready) begin
      nextpc <= i_nextpc;
    end
    else begin
      nextpc <= pc;
    end
  end

  reg ready;
  assign o_ifu_ready = ready;
  always @(posedge i_clk) begin
    ready <= 1'b0;
    if (!i_rst) begin
      npc_pmem_read(pc, rdata);
      ready <= 1'b1;
    end
  end

  assign o_pc = pc;

endmodule
