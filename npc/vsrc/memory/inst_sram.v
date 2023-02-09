// ysyx_22050710 Inst sram

module ysyx_22050710_inst_sram #(
  parameter SRAM_ADDR_WD                                     ,
  parameter SRAM_DATA_WD
) (
  input                        i_clk                         ,

  input                        i_ren                         ,
  input  [SRAM_ADDR_WD-1:0   ] i_addr                        ,
  output [SRAM_DATA_WD-1:0   ] o_rdata
);

  reg  [SRAM_DATA_WD-1:0     ] rdata                         ;  // address register for pmem read.

  always @(posedge i_clk) begin
    if (i_ren) begin
      /* npc_pmem_read({32'b0, i_addr}, rdata); */
      if (i_addr == 32'h80000000 || i_addr == 32'h80000004) begin
        rdata <= 64'h000091170000413;
      end
      else if (i_addr == 32'h80000008 || i_addr == 32'h8000000c) begin
        rdata <= 64'h00c00efffc19113;
      end
    end
  end

  assign o_rdata             = i_ren ? rdata : 0             ;

endmodule
