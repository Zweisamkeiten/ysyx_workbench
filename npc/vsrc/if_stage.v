// ysyx_22050710
import "DPI-C" function void set_inst_ptr(input logic [63:0] b[]);
module ysyx_22050710_ifu (
  input i_clk, i_rst,
  input [63:0] i_pc,
  output [31:0] o_inst,
  output [31:0] o_unused
);

  initial begin
    set_inst_ptr(rdata);
  end

  wire [63:0] rdata;
  assign o_inst = rdata[31:0];
  assign o_unused = rdata[63:32];

  always @(posedge i_clk) begin
    if (!i_rst) begin
      npc_pmem_read(i_pc, rdata);
      $display(rdata[31:0]);
    end
  end
endmodule
