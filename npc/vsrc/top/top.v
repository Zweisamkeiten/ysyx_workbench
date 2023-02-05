// ysyx_22050710 TOP

module ysyx_22050710_top (
  input i_clk,
  input i_rst
);

  //cpu inst sram
  wire        cpu_inst_en;
  wire [3 :0] cpu_inst_wen;
  wire [31:0] cpu_inst_addr;
  wire [63:0] cpu_inst_wdata;
  wire [63:0] cpu_inst_rdata;
  ysyx_22050710_core u_core (
    .i_clk(i_clk),
    .i_rst(i_rst),

    .o_inst_sram_en     (cpu_inst_en   ),
    .o_inst_sram_wen    (cpu_inst_wen  ),
    .o_inst_sram_addr   (cpu_inst_addr ),
    .o_inst_sram_wdata  (cpu_inst_wdata),
    .i_inst_sram_rdata  (cpu_inst_rdata)
  );

  //inst ram
  ysyx_22050710_inst_sram u_inst_ram (
      .i_clk   (i_clk              ),   
      .i_en    (cpu_inst_en        ),
      .i_wen   (cpu_inst_wen       ),   //3:0
      .i_addr  (cpu_inst_addr      ),
      .i_wdata (cpu_inst_wdata     ),   //63:0
      .o_rdata (cpu_inst_rdata     )    //63:0
  );

endmodule
