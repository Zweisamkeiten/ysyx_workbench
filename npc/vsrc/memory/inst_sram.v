module ysyx_22050710_inst_sram #(
  parameter SRAM_ADDR_WD                                     ,
  parameter SRAM_DATA_WD
) (
  input                        i_clk                         ,

  input                        i_ren                         ,
  input  [SRAM_ADDR_WD   -1:0] i_addr                        ,
  output [SRAM_DATA_WD   -1:0] o_rdata
);

  reg [SRAM_DATA_WD-1:0]       rdata                         ;  // address register for pmem read.
  assign o_rdata             = rdata                         ;

  always @(posedge i_clk) begin
    if (i_ren) begin
      npc_pmem_read({32'b0, i_addr}, rdata);
    end
    else begin
      rdata <= 0;
    end
  end

endmodule
