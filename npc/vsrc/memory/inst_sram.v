module ysyx_22050710_inst_sram #(parameter ADDR_WIDTH = 32, DATA_WIDTH = 64) (
  input  i_clk,

  input  i_en,
  input  [ADDR_WIDTH-1:0] i_addr,
  output [DATA_WIDTH-1:0] o_rdata
);

  reg [DATA_WIDTH-1:0] rdata;  // address register for pmem read.
  assign o_rdata = rdata;

  reg ready_go = 0;
  always @(posedge i_clk) begin
    if (ready_go) begin
      ready_go <= 0;
    end
  end

  always @(posedge i_clk) begin
    $display("%x, %x", )
  end

  always @(posedge i_clk) begin
    if (i_en && ready_go == 0) begin
      npc_pmem_read({32'b0, i_addr}, rdata);
      ready_go <= 1;
    end
  end
endmodule
