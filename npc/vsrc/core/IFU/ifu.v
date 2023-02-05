// ysyx_22050710 Instruction Fetch Unit

module ysyx_22050710_ifu #(INST_WIDTH = 32, DATA_WIDTH = 64) (
  input   i_clk, i_rst,
  input   [DATA_WIDTH-1:0] i_nextpc,
  output  [DATA_WIDTH-1:0] o_pc,
  output  [INST_WIDTH-1:0] o_inst,
  output  o_ifu_ready,
  // inst sram interface
  output        o_inst_sram_en   ,
  output [ 3:0] o_inst_sram_wen  ,
  output [31:0] o_inst_sram_addr ,
  output [63:0] o_inst_sram_wdata,
  input  [63:0] i_inst_sram_rdata
);

  wire [DATA_WIDTH-1:0] pc;
  ysyx_22050710_pc u_pc (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_load(ready),
    .i_in(i_nextpc),
    .o_pc(pc)
  );

  assign o_inst = pc[2] == 1'b0 ? i_inst_sram_rdata[31:0] : i_inst_sram_rdata[63:32];

  always @(posedge i_clk) begin
    if (!i_rst) begin
      if (ready) ready <= 1'b0;
      else ready <= 1'b1;
    end
  end

  reg ready = 1'b0;
  assign o_ifu_ready = ready;

  assign o_pc = pc;

  assign o_inst_sram_en    = 1'b1;
  assign o_inst_sram_wen   = 4'h0;
  assign o_inst_sram_addr  = pc[31:0];
  assign o_inst_sram_wdata = 64'b0;

endmodule
