// ysyx_22050710
module ysyx_22050710_cpu_top #(
  parameter WORD_WD                                          ,
  parameter PC_RESETVAL                                      ,
  parameter PC_WD                                            ,
  parameter GPR_WD                                           ,
  parameter GPR_ADDR_WD                                      ,
  parameter CSR_WD                                           ,
  parameter CSR_ADDR_WD                                      ,
  parameter IMM_WD                                           ,
  parameter INST_WD                                          ,

  parameter SRAM_ADDR_WD                                     ,
  parameter SRAM_WMASK_WD                                    ,
  parameter SRAM_DATA_WD                                     ,
  parameter STRB_WIDTH = (SRAM_DATA_WD/8)
) (
  input                        i_aclk                        ,
  input                        i_arsetn                      ,

  // Wirte address channel
  output                       o_ifu_awvalid                 ,
  input                        i_ifu_awready                 ,
  output [SRAM_ADDR_WD-1:0   ] o_ifu_awaddr                  ,
  output [2:0                ] o_ifu_awprot                  , // define the access permission for write accesses.

  // Write data channel
  output                       o_ifu_wvalid                  ,
  input                        i_ifu_wready                  ,
  output [SRAM_DATA_WD-1:0   ] o_ifu_wdata                   ,
  output [STRB_WIDTH-1:0     ] o_ifu_wstrb                   ,

  // Write response channel
  input                        i_ifu_bvalid                  ,
  output                       o_ifu_bready                  ,
  input  [1:0                ] i_ifu_bresp                   ,

  // Read address channel
  output                       o_ifu_arvalid                 ,
  input                        i_ifu_arready                 ,
  output [SRAM_ADDR_WD-1:0   ] o_ifu_araddr                  ,
  output [2:0                ] o_ifu_arprot                  ,

  // Read data channel
  input                        i_ifu_rvalid                  ,
  output                       o_ifu_rready                  ,
  input  [SRAM_DATA_WD-1:0   ] i_ifu_rdata                   ,
  input  [1:0                ] i_ifu_rresp                   ,

  // Wirte address channel
  output                       o_lsu_awvalid                 ,
  input                        i_lsu_awready                 ,
  output [SRAM_ADDR_WD-1:0   ] o_lsu_awaddr                  ,
  output [2:0                ] o_lsu_awprot                  , // define the access permission for write accesses.

  // Write data channel
  output                       o_lsu_wvalid                  ,
  input                        i_lsu_wready                  ,
  output [SRAM_DATA_WD-1:0   ] o_lsu_wdata                   ,
  output [STRB_WIDTH-1:0     ] o_lsu_wstrb                   ,

  // Write response channel
  input                        i_lsu_bvalid                  ,
  output                       o_lsu_bready                  ,
  input  [1:0                ] i_lsu_bresp                   ,

  // Read address channel
  output                       o_lsu_arvalid                 ,
  input                        i_lsu_arready                 ,
  output [SRAM_ADDR_WD-1:0   ] o_lsu_araddr                  ,
  output [2:0                ] o_lsu_arprot                  ,

  // Read data channel
  input                        i_lsu_rvalid                  ,
  output                       o_lsu_rready                  ,
  input  [SRAM_DATA_WD-1:0   ] i_lsu_rdata                   ,
  input  [1:0                ] i_lsu_rresp
);
  // cpu inst sram
  wire [SRAM_ADDR_WD-1:0     ] cpu_inst_addr                 ;
  wire                         cpu_inst_ren                  ;
  wire [SRAM_DATA_WD-1:0     ] cpu_inst_rdata                ;
  wire                         cpu_inst_addr_ok              ;
  wire                         cpu_inst_data_ok              ;
  // cpu data sram
  wire [SRAM_ADDR_WD-1:0     ] cpu_data_addr                 ;
  wire                         cpu_data_ren                  ;
  wire [SRAM_DATA_WD-1:0     ] cpu_data_rdata                ;
  wire                         cpu_data_wen                  ;
  wire [SRAM_WMASK_WD-1:0    ] cpu_data_wmask                ;
  wire [SRAM_DATA_WD-1:0     ] cpu_data_wdata                ;
  wire                         cpu_data_addr_ok              ;
  wire                         cpu_data_data_ok              ;

  ysyx_22050710_core #( 
    .WORD_WD                  (WORD_WD                       ),
    .PC_RESETVAL              (PC_RESETVAL                   ),
    .PC_WD                    (PC_WD                         ),
    .GPR_WD                   (GPR_WD                        ),
    .GPR_ADDR_WD              (GPR_ADDR_WD                   ),
    .IMM_WD                   (IMM_WD                        ),
    .CSR_WD                   (CSR_WD                        ),
    .CSR_ADDR_WD              (CSR_ADDR_WD                   ),
    .INST_WD                  (INST_WD                       ),
    .SRAM_ADDR_WD             (SRAM_ADDR_WD                  ),
    .SRAM_WMASK_WD            (SRAM_WMASK_WD                 ),
    .SRAM_DATA_WD             (SRAM_DATA_WD                  )
  ) u_core (
    .i_clk                    (i_aclk                        ),
    .i_rst                    (~i_arsetn                     ),

    .o_inst_sram_addr         (cpu_inst_addr                 ),
    .o_inst_sram_ren          (cpu_inst_ren                  ),
    .i_inst_sram_rdata        (cpu_inst_rdata                ),
    .i_inst_sram_addr_ok      (cpu_inst_addr_ok              ),
    .i_inst_sram_data_ok      (cpu_inst_data_ok              ),

    // data sram interface
    .o_data_sram_addr         (cpu_data_addr                 ),
    .o_data_sram_ren          (cpu_data_ren                  ),
    .i_data_sram_rdata        (cpu_data_rdata                ),
    .o_data_sram_wen          (cpu_data_wen                  ),
    .o_data_sram_wmask        (cpu_data_wmask                ),
    .o_data_sram_wdata        (cpu_data_wdata                ),
    .i_data_sram_addr_ok      (cpu_data_addr_ok              ),
    .i_data_sram_data_ok      (cpu_data_data_ok              )
  );

  ysyx_22050710_axil_master_wrap u_ifu_axi_wrap (
    .i_rw_valid               (cpu_inst_ren                ),  //IF&MEM输入信号
    .o_rw_addr_ok             (cpu_inst_addr_ok            ),  //IF&MEM输入信号
    .o_rw_data_ok             (cpu_inst_data_ok            ),  //IF&MEM输入信号
    .i_rw_ren                 (cpu_inst_ren                ),  //IF&MEM输入信号
    .i_rw_wen                 (0                           ),  //IF&MEM输入信号
    .i_rw_addr                (cpu_inst_addr               ),  //IF&MEM输入信号
    .o_data_read              (cpu_inst_rdata              ),  //IF&MEM输入信号
    .i_rw_w_data              (64'b0                       ),  //IF&MEM输入信号
    .i_rw_size                (8'b0                        ),  //IF&MEM输入信号

    .i_aclk                   (i_aclk                      ),
    .i_arsetn                 (i_arsetn                    ),

    // Wirte address channel
    .o_awvalid                (o_ifu_awvalid               ),
    .i_awready                (i_ifu_awready               ),
    .o_awaddr                 (o_ifu_awaddr                ),
    .o_awprot                 (o_ifu_awprot                ), // define the access permission for write accesses.

    // Write data channel
    .o_wvalid                 (o_ifu_wvalid                ),
    .i_wready                 (i_ifu_wready                ),
    .o_wdata                  (o_ifu_wdata                 ),
    .o_wstrb                  (o_ifu_wstrb                 ),

    // Write response channel
    .i_bvalid                 (i_ifu_bvalid                ),
    .o_bready                 (o_ifu_bready                ),
    .i_bresp                  (i_ifu_bresp                 ),

    // Read address channel
    .o_arvalid                (o_ifu_arvalid               ),
    .i_arready                (i_ifu_arready               ),
    .o_araddr                 (o_ifu_araddr                ),
    .o_arprot                 (o_ifu_arprot                ),

    // Read data channel
    .i_rvalid                 (i_ifu_rvalid                ),
    .o_rready                 (o_ifu_rready                ),
    .i_rdata                  (i_ifu_rdata                 ),
    .i_rresp                  (i_ifu_rresp                 )
  );

  ysyx_22050710_axil_master_wrap u_lsu_axi_wrap (
    .i_rw_valid               (cpu_data_ren | cpu_data_wen ),  //IF&MEM输入信号
    .o_rw_addr_ok             (cpu_data_addr_ok            ),  //IF&MEM输入信号
    .o_rw_data_ok             (cpu_data_data_ok            ),  //IF&MEM输入信号
    .i_rw_ren                 (cpu_data_ren                ),  //IF&MEM输入信号
    .i_rw_wen                 (cpu_data_wen                ),  //IF&MEM输入信号
    .i_rw_addr                (cpu_data_addr               ),  //IF&MEM输入信号
    .o_data_read              (cpu_data_rdata              ),  //IF&MEM输入信号
    .i_rw_w_data              (cpu_data_wdata              ),  //IF&MEM输入信号
    .i_rw_size                (cpu_data_wmask              ),  //IF&MEM输入信号

    .i_aclk                   (i_aclk                      ),
    .i_arsetn                 (i_arsetn                    ),

    // Wirte address channel
    .o_awvalid                (o_lsu_awvalid               ),
    .i_awready                (i_lsu_awready               ),
    .o_awaddr                 (o_lsu_awaddr                ),
    .o_awprot                 (o_lsu_awprot                ), // define the access permission for write accesses.

    // Write data channel
    .o_wvalid                 (o_lsu_wvalid                ),
    .i_wready                 (i_lsu_wready                ),
    .o_wdata                  (o_lsu_wdata                 ),
    .o_wstrb                  (o_lsu_wstrb                 ),

    // Write response channel
    .i_bvalid                 (i_lsu_bvalid                ),
    .o_bready                 (o_lsu_bready                ),
    .i_bresp                  (i_lsu_bresp                 ),

    // Read address channel
    .o_arvalid                (o_lsu_arvalid               ),
    .i_arready                (i_lsu_arready               ),
    .o_araddr                 (o_lsu_araddr                ),
    .o_arprot                 (o_lsu_arprot                ),

    // Read data channel
    .i_rvalid                 (i_lsu_rvalid                ),
    .o_rready                 (o_lsu_rready                ),
    .i_rdata                  (i_lsu_rdata                 ),
    .i_rresp                  (i_lsu_rresp                 )
  );

endmodule
