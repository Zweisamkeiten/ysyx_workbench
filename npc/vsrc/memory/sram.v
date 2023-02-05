module ysyx_22050710_inst_sram #(parameter ADDR_WIDTH = 32, DATA_WIDTH = 64) (
  input  wire i_clk,
  input  wire i_rst,

  input  wire [ADDR_WIDTH-1:0] i_addr,
  output wire [DATA_WIDTH-1:0] o_data
);

  reg [DATA_WIDTH-1:0] rdata;  // address register for pmem read.
  assign o_data = rdata;

  always @(posedge clk) begin
    if (!i_rst) begin
      npc_pmem_read(i_addr, rdata);
    end
  end 
endmodule
