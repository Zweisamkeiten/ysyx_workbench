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
  output                       o_awvalid                     ,
  input                        i_awready                     ,
  output [SRAM_ADDR_WD-1:0   ] o_awaddr                      ,
  output [2:0                ] o_awprot                      , // define the access permission for write accesses.

  // Write data channel
  output                       o_wvalid                      ,
  input                        i_wready                      ,
  output [SRAM_DATA_WD-1:0   ] o_wdata                       ,
  output [STRB_WIDTH-1:0     ] o_wstrb                       ,

  // Write response channel
  input                        i_bvalid                      ,
  output                       o_bready                      ,
  input  [1:0                ] i_bresp                       ,

  // Read address channel
  output                       o_arvalid                     ,
  input                        i_arready                     ,
  output [SRAM_ADDR_WD-1:0   ] o_araddr                      ,
  output [2:0                ] o_arprot                      ,

  // Read data channel
  input                        i_rvalid                      ,
  output                       o_rready                      ,
  input  [SRAM_DATA_WD-1:0   ] i_rdata                       ,
  input  [1:0                ] i_rresp
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

  // Wirte address channel
  wire                         ifu_awvalid                   ;
  wire                         ifu_awready                   ;
  wire [SRAM_ADDR_WD-1:0     ] ifu_awaddr                    ;
  wire [2:0                  ] ifu_awprot                    ; // define the access permission for write accesses.

  // Write data channel
  wire                         ifu_wvalid                    ;
  wire                         ifu_wready                    ;
  wire [SRAM_DATA_WD-1:0     ] ifu_wdata                     ;
  wire [STRB_WIDTH-1:0       ] ifu_wstrb                     ;

  // Write response channel
  wire                         ifu_bvalid                    ;
  wire                         ifu_bready                    ;
  wire [1:0                  ] ifu_bresp                     ;

  // Read address channel
  wire                         ifu_arvalid                   ;
  wire                         ifu_arready                   ;
  wire [SRAM_ADDR_WD-1:0     ] ifu_araddr                    ;
  wire [2:0                  ] ifu_arprot                    ;

  // Read data channel
  wire                         ifu_rvalid                    ;
  wire                         ifu_rready                    ;
  wire [SRAM_DATA_WD-1:0     ] ifu_rdata                     ;
  wire [1:0                  ] ifu_rresp                     ;

  // Wirte address channel
  wire                         lsu_awvalid                   ;
  wire                         lsu_awready                   ;
  wire [SRAM_ADDR_WD-1:0     ] lsu_awaddr                    ;
  wire [2:0                  ] lsu_awprot                    ; // define the access permission for write accesses.

  // Write data channel
  wire                         lsu_wvalid                    ;
  wire                         lsu_wready                    ;
  wire [SRAM_DATA_WD-1:0     ] lsu_wdata                     ;
  wire [STRB_WIDTH-1:0       ] lsu_wstrb                     ;

  // Write response channel
  wire                         lsu_bvalid                    ;
  wire                         lsu_bready                    ;
  wire [1:0                  ] lsu_bresp                     ;

  // Read address channel
  wire                         lsu_arvalid                   ;
  wire                         lsu_arready                   ;
  wire [SRAM_ADDR_WD-1:0     ] lsu_araddr                    ;
  wire [2:0                  ] lsu_arprot                    ;

  // Read data channel
  wire                         lsu_rvalid                    ;
  wire                         lsu_rready                    ;
  wire [SRAM_DATA_WD-1:0     ] lsu_rdata                     ;
  wire [1:0                  ] lsu_rresp                     ;

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
    .o_awvalid                (ifu_awvalid                 ),
    .i_awready                (ifu_awready                 ),
    .o_awaddr                 (ifu_awaddr                  ),
    .o_awprot                 (ifu_awprot                  ), // define the access permission for write accesses.

    // Write data channel
    .o_wvalid                 (ifu_wvalid                  ),
    .i_wready                 (ifu_wready                  ),
    .o_wdata                  (ifu_wdata                   ),
    .o_wstrb                  (ifu_wstrb                   ),

    // Write response channel
    .i_bvalid                 (ifu_bvalid                  ),
    .o_bready                 (ifu_bready                  ),
    .i_bresp                  (ifu_bresp                   ),

    // Read address channel
    .o_arvalid                (ifu_arvalid                 ),
    .i_arready                (ifu_arready                 ),
    .o_araddr                 (ifu_araddr                  ),
    .o_arprot                 (ifu_arprot                  ),

    // Read data channel
    .i_rvalid                 (ifu_rvalid                  ),
    .o_rready                 (ifu_rready                  ),
    .i_rdata                  (ifu_rdata                   ),
    .i_rresp                  (ifu_rresp                   )
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
    .o_awvalid                (lsu_awvalid                 ),
    .i_awready                (lsu_awready                 ),
    .o_awaddr                 (lsu_awaddr                  ),
    .o_awprot                 (lsu_awprot                  ), // define the access permission for write accesses.

    // Write data channel
    .o_wvalid                 (lsu_wvalid                  ),
    .i_wready                 (lsu_wready                  ),
    .o_wdata                  (lsu_wdata                   ),
    .o_wstrb                  (lsu_wstrb                   ),

    // Write response channel
    .i_bvalid                 (lsu_bvalid                  ),
    .o_bready                 (lsu_bready                  ),
    .i_bresp                  (lsu_bresp                   ),

    // Read address channel
    .o_arvalid                (lsu_arvalid                 ),
    .i_arready                (lsu_arready                 ),
    .o_araddr                 (lsu_araddr                  ),
    .o_arprot                 (lsu_arprot                  ),

    // Read data channel
    .i_rvalid                 (lsu_rvalid                  ),
    .o_rready                 (lsu_rready                  ),
    .i_rdata                  (lsu_rdata                   ),
    .i_rresp                  (lsu_rresp                   )
  );

  ysyx_22050710_axil_arbiter_2x1 u_axil_arbiter (
    .i_aclk                   (i_aclk                       ),
    .i_arsetn                 (i_arsetn                     ),

    // -------------------------------------------------------
    // A
    // Wirte address channel
    .i_a_awvalid              (ifu_awvalid                  ),
    .o_a_awready              (ifu_awready                  ),
    .i_a_awaddr               (ifu_awaddr                   ),
    .i_a_awprot               (ifu_awprot                   ), // define the access permission for write accesses.

    // a_Write data channel
    .i_a_wvalid               (ifu_wvalid                   ),
    .o_a_wready               (ifu_wready                   ),
    .i_a_wdata                (ifu_wdata                    ),
    .i_a_wstrb                (ifu_wstrb                    ),

    // a_Write response channel
    .o_a_bvalid               (ifu_bvalid                   ),
    .i_a_bready               (ifu_bready                   ),
    .o_a_bresp                (ifu_bresp                    ),

    // a_Read address channel
    .i_a_arvalid              (ifu_arvalid                  ),
    .o_a_arready              (ifu_arready                  ),
    .i_a_araddr               (ifu_araddr                   ),
    .i_a_arprot               (ifu_arprot                   ),

    // a_Read data channel
    .o_a_rvalid               (ifu_rvalid                   ),
    .i_a_rready               (ifu_rready                   ),
    .o_a_rdata                (ifu_rdata                    ),
    .o_a_rresp                (ifu_rresp                    ),

    // -------------------------------------------------------
    // B
    // Wirte address channel
    .i_b_awvalid              (lsu_awvalid                  ),
    .o_b_awready              (lsu_awready                  ),
    .i_b_awaddr               (lsu_awaddr                   ),
    .i_b_awprot               (lsu_awprot                   ), // define the access permission for write accesses.

    // Write data channel
    .i_b_wvalid               (lsu_wvalid                   ),
    .o_b_wready               (lsu_wready                   ),
    .i_b_wdata                (lsu_wdata                    ),
    .i_b_wstrb                (lsu_wstrb                    ),

    // Write response channel
    .o_b_bvalid               (lsu_bvalid                   ),
    .i_b_bready               (lsu_bready                   ),
    .o_b_bresp                (lsu_bresp                    ),

    // Read address channel
    .i_b_arvalid              (lsu_arvalid                  ),
    .o_b_arready              (lsu_arready                  ),
    .i_b_araddr               (lsu_araddr                   ),
    .i_b_arprot               (lsu_arprot                   ),

    // Read data channel
    .o_b_rvalid               (lsu_rvalid                   ),
    .i_b_rready               (lsu_rready                   ),
    .o_b_rdata                (lsu_rdata                    ),
    .o_b_rresp                (lsu_rresp                    ),

    // -------------------------------------------------------
    // Wirte address channel
    .o_awvalid                (o_awvalid                    ),
    .i_awready                (i_awready                    ),
    .o_awaddr                 (o_awaddr                     ),
    .o_awprot                 (o_awprot                     ), // define the access permission for write accesses.

    // Write data channel
    .o_wvalid                 (o_wvalid                     ),
    .i_wready                 (i_wready                     ),
    .o_wdata                  (o_wdata                      ),
    .o_wstrb                  (o_wstrb                      ),

    // Write response channel
    .i_bvalid                 (i_bvalid                     ),
    .o_bready                 (o_bready                     ),
    .i_bresp                  (i_bresp                      ),

    // Read address channel
    .o_arvalid                (o_arvalid                    ),
    .i_arready                (i_arready                    ),
    .o_araddr                 (o_araddr                     ),
    .o_arprot                 (o_arprot                     ),

    // Read data channel
    .i_rvalid                 (i_rvalid                     ),
    .o_rready                 (o_rready                     ),
    .i_rdata                  (i_rdata                      ),
    .i_rresp                  (i_rresp                      )
  );

endmodule
