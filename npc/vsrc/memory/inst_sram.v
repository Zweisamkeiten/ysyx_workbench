module ysyx_22050710_inst_sram #(parameter ADDR_WIDTH = 32, DATA_WIDTH = 64) (
  input  i_clk,

  input  i_en,
  input  [3:0] i_wen,
  input  [ADDR_WIDTH-1:0] i_addr,
  input  [DATA_WIDTH-1:0] i_wdata,
  output [DATA_WIDTH-1:0] o_rdata
);

  reg [DATA_WIDTH-1:0] rdata;  // address register for pmem read.
  assign o_rdata = rdata;

  always @(posedge i_clk) begin
    if (i_en) begin
      npc_pmem_read({32'b0, i_addr}, rdata);
    end
  end 
endmodule
