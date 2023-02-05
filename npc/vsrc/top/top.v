// ysyx_22050710 TOP

module ysyx_22050710_top (
  input i_clk,
  input i_rst
);

  //cpu inst sram
  wire        cpu_inst_en;
  wire [31:0] cpu_inst_addr;
  wire [63:0] cpu_inst_rdata;
  ysyx_22050710_core u_core (
    .i_clk(i_clk),
    .i_rst(i_rst),

    .o_inst_sram_en     (cpu_inst_en   ),
    .o_inst_sram_addr   (cpu_inst_addr ),
    .i_inst_sram_rdata  (cpu_inst_rdata)
  );

  //inst ram
  ysyx_22050710_inst_sram u_inst_ram (
      .i_clk   (i_clk              ),
      .i_en    (cpu_inst_en        ),
      .i_addr  (cpu_inst_addr      ),
      .o_rdata (cpu_inst_rdata     )    //63:0
  );

endmodule
