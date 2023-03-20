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
  output [3:0                ] o_awid                        ,  // 写请求 ID 号 固定为 1
  output [SRAM_ADDR_WD-1:0   ] o_awaddr                      ,  // 写请求地址
  output [7:0                ] o_awlen                       ,  // 写请求控制信号, 请求传输的长度(数据传输拍数) 固定为0(without cache)
  output [1:0                ] o_awsize                      ,  // 写请求控制信号, 请求传输的大小(数据传输每拍的字节数)
  output [1:0                ] o_awburst                     ,  // 写请求控制信号, 传输类型 固定为0b01(without cache)
  output [1:0                ] o_awlock                      ,  // 写请求控制信号, 原子锁 固定为0
  output [3:0                ] o_awcache                     ,  // 写请求控制信号, Cache 属性 固定为 0
  output [2:0                ] o_awprot                      ,  // 写请求控制信号, 保护属性 写权限
  output                       o_awvalid                     ,  // 写请求地址握手信号, 写请求地址有效
  input                        i_awready                     ,  // 写请求地址握手信号, slave 端准备好接收地址传输

  // Write data channel
  output [3:0                ] o_wid                         ,  // 写请求的 ID 号 固定为 1
  output [SRAM_DATA_WD-1:0   ] o_wdata                       ,  // 写请求的写数据
  output [STRB_WIDTH-1:0     ] o_wstrb                       ,  // 写请求控制信号, 字节选通位
  output                       o_wlast                       ,  // 写请求控制信号, 本次写请求的最后一拍数据的指示信号
  output                       o_wvalid                      ,  // 写请求数据握手信号, 写请求数据有效
  input                        i_wready                      ,  // 写请求数据握手信号, slave 端准备好将接收数据传输

  // Write response channel
  input  [3:0                ] i_bid                         ,  // 写请求的 ID 号, 同一请求的 bid, wid 和 awid 应一致, 可忽略
  input  [1:0                ] i_bresp                       ,  // 写请求控制信号, 本次写请求是否成功完成
  input                        i_bvalid                      ,  // 写请求响应握手信号, 写请求响应有效
  output                       o_bready                      ,  // 写请求响应握手信号, master 端准备好接收写响应

  // Read address channel
  output [3:0                ] o_arid                        ,  // 读请求的 ID 号, 取指 0; 取数 1;
  output [SRAM_ADDR_WD-1:0   ] o_araddr                      ,  // 读请求的地址
  output [7:0                ] o_arlen                       ,  // 读请求控制信号, 请求传输的长度(数据传输拍数) 固定为0
  output [1:0                ] o_arsize                      ,  // 读请求控制信号, 请求传输的大小(数据传输每拍的字节数)
  output [1:0                ] o_arburst                     ,  // 读请求控制信号, 传输类型 固定为 0b01(without cache)
  output [1:0                ] o_arlock                      ,  // 读请求控制信号, 原子锁 固定为 0
  output [3:0                ] o_arcache                     ,  // 读请求控制信号, Cache 属性 固定为 0
  output [2:0                ] o_arprot                      ,  // 读请求控制信号, 保护属性 固定为 0
  output                       o_arvalid                     ,  // 读请求地址握手信号, 读请求地址有效
  input                        i_arready                     ,  // 读请求地址握手信号, slave 端准备好接收地址传输

  // Read data channel
  input  [3:0                ] i_rid                         ,  // 读请求的 ID 号, 取指 0; 取数 1;
  input  [SRAM_DATA_WD-1:0   ] i_rdata                       ,  // 读请求的读回数据
  input  [1:0                ] i_rresp                       ,  // 读请求控制信号, 本次读请求是否成功完成 可忽略
  input                        i_rlast                       ,  // 读请求控制信号, 本次读请求的最后一拍数据的知识信号 可忽略
  input                        i_rvalid                      ,  // 读请求数据握手信号, 读请求数据有效
  output                       o_rready                         // 读请求数据握手信号, master 端准备好接收数据传输
);
  // cpu inst sram
  wire                         cpu_inst_req                  ; // 请求信号, 为 1 时有读写请求, 为 0 时无读写请求
  wire                         cpu_inst_wr                   ; // 为 1 表示该次是写请求, 为 0 表示该次是读请求
  wire [1:0                  ] cpu_inst_size                 ; // 该次请求传输的字节数, 0: 1byte; 1: 2bytes; 2: 4bytes; 3: 8bytes
  wire [SRAM_ADDR_WD-1:0     ] cpu_inst_addr                 ; // 该次请求的地址
  wire [SRAM_WMASK_WD-1:0    ] cpu_inst_wstrb                ; // 该次请求的写字节使能
  wire [SRAM_DATA_WD-1:0     ] cpu_inst_wdata                ; // 该次写请求的写数据
  wire                         cpu_inst_addr_ok              ; // 该次请求的地址传输 OK, 读: 地址被接收; 写: 地址和数据被接收
  wire                         cpu_inst_data_ok              ; // 该次请求的数据传输 OK, 读: 数据返回  ; 写: 数据写入完成
  wire [SRAM_DATA_WD-1:0     ] cpu_inst_rdata                ; // 该次请求返回的读数据

  // cpu data sram
  wire                         cpu_data_req                  ; // 请求信号, 为 1 时有读写请求, 为 0 时无读写请求
  wire                         cpu_data_wr                   ; // 为 1 表示该次是写请求, 为 0 表示该次是读请求
  wire [1:0                  ] cpu_data_size                 ; // 该次请求传输的字节数, 0: 1byte; 1: 2bytes; 2: 4bytes; 3: 8bytes
  wire [SRAM_ADDR_WD-1:0     ] cpu_data_addr                 ; // 该次请求的地址
  wire [SRAM_WMASK_WD-1:0    ] cpu_data_wstrb                ; // 该次请求的写字节使能
  wire [SRAM_DATA_WD-1:0     ] cpu_data_wdata                ; // 该次写请求的写数据
  wire                         cpu_data_addr_ok              ; // 该次请求的地址传输 OK, 读: 地址被接收; 写: 地址和数据被接收
  wire                         cpu_data_data_ok              ; // 该次请求的数据传输 OK, 读: 数据返回  ; 写: 数据写入完成
  wire [SRAM_DATA_WD-1:0     ] cpu_data_rdata                ; // 该次请求返回的读数据

  // Wirte address channel
  wire [SRAM_ADDR_WD-1:0     ] ifu_awaddr                    ;
  wire [2:0                  ] ifu_awprot                    ; // define the access permission for write accesses.
  wire [7:0                  ] ifu_awlen                     ;
  wire [1:0                  ] ifu_awsize                    ;
  wire [1:0                  ] ifu_awburst                   ;
  wire [1:0                  ] ifu_awlock                    ;
  wire [3:0                  ] ifu_awcache                   ;
  wire                         ifu_awvalid                   ;
  wire                         ifu_awready                   ;

  // Write data channel
  wire [SRAM_DATA_WD-1:0     ] ifu_wdata                     ;
  wire [STRB_WIDTH-1:0       ] ifu_wstrb                     ;
  wire                         ifu_wlast                     ;
  wire                         ifu_wvalid                    ;
  wire                         ifu_wready                    ;

  // Write response channel
  wire [1:0                  ] ifu_bresp                     ;
  wire                         ifu_bvalid                    ;
  wire                         ifu_bready                    ;

  // Read address channel
  wire [SRAM_ADDR_WD-1:0     ] ifu_araddr                    ;
  wire [7:0                  ] ifu_arlen                     ;
  wire [1:0                  ] ifu_arsize                    ;
  wire [1:0                  ] ifu_arburst                   ;
  wire [1:0                  ] ifu_arlock                    ;
  wire [3:0                  ] ifu_arcache                   ;
  wire [2:0                  ] ifu_arprot                    ;
  wire                         ifu_arvalid                   ;
  wire                         ifu_arready                   ;

  // Read data channel
  wire [SRAM_DATA_WD-1:0     ] ifu_rdata                     ;
  wire [1:0                  ] ifu_rresp                     ;
  wire                         ifu_rlast                     ;
  wire                         ifu_rvalid                    ;
  wire                         ifu_rready                    ;

  // Wirte address channel
  wire [SRAM_ADDR_WD-1:0     ] lsu_awaddr                    ;
  wire [2:0                  ] lsu_awprot                    ; // define the access permission for write accesses.
  wire [7:0                  ] lsu_awlen                     ;
  wire [1:0                  ] lsu_awsize                    ;
  wire [1:0                  ] lsu_awburst                   ;
  wire [1:0                  ] lsu_awlock                    ;
  wire [3:0                  ] lsu_awcache                   ;
  wire                         lsu_awvalid                   ;
  wire                         lsu_awready                   ;

  // Write data channel
  wire [SRAM_DATA_WD-1:0     ] lsu_wdata                     ;
  wire [STRB_WIDTH-1:0       ] lsu_wstrb                     ;
  wire                         lsu_wlast                     ;
  wire                         lsu_wvalid                    ;
  wire                         lsu_wready                    ;

  // Write response channel
  wire [1:0                  ] lsu_bresp                     ;
  wire                         lsu_bvalid                    ;
  wire                         lsu_bready                    ;

  // Read address channel
  wire [SRAM_ADDR_WD-1:0     ] lsu_araddr                    ;
  wire [7:0                  ] lsu_arlen                     ;
  wire [1:0                  ] lsu_arsize                    ;
  wire [1:0                  ] lsu_arburst                   ;
  wire [1:0                  ] lsu_arlock                    ;
  wire [3:0                  ] lsu_arcache                   ;
  wire [2:0                  ] lsu_arprot                    ;
  wire                         lsu_arvalid                   ;
  wire                         lsu_arready                   ;

  // Read data channel
  wire [SRAM_DATA_WD-1:0     ] lsu_rdata                     ;
  wire [1:0                  ] lsu_rresp                     ;
  wire                         lsu_rlast                     ;
  wire                         lsu_rvalid                    ;
  wire                         lsu_rready                    ;

  ysyx_22050710_core #( 
    .WORD_WD                  (WORD_WD                      ),
    .PC_RESETVAL              (PC_RESETVAL                  ),
    .PC_WD                    (PC_WD                        ),
    .GPR_WD                   (GPR_WD                       ),
    .GPR_ADDR_WD              (GPR_ADDR_WD                  ),
    .IMM_WD                   (IMM_WD                       ),
    .CSR_WD                   (CSR_WD                       ),
    .CSR_ADDR_WD              (CSR_ADDR_WD                  ),
    .INST_WD                  (INST_WD                      ),
    .SRAM_ADDR_WD             (SRAM_ADDR_WD                 ),
    .SRAM_WMASK_WD            (SRAM_WMASK_WD                ),
    .SRAM_DATA_WD             (SRAM_DATA_WD                 )
  ) u_core (
    .i_clk                    (i_aclk                       ),
    .i_rst                    (~i_arsetn                    ),

    // inst sram interface
    .o_inst_sram_req          (cpu_inst_req                 ),
    .o_inst_sram_wr           (cpu_inst_wr                  ),
    .o_inst_sram_size         (cpu_inst_size                ),
    .o_inst_sram_addr         (cpu_inst_addr                ),
    .o_inst_sram_wstrb        (cpu_inst_wstrb               ),
    .o_inst_sram_wdata        (cpu_inst_wdata               ),
    .i_inst_sram_addr_ok      (cpu_inst_addr_ok             ),
    .i_inst_sram_data_ok      (cpu_inst_data_ok             ),
    .i_inst_sram_rdata        (cpu_inst_rdata               ),

    // data sram interface
    .o_data_sram_req          (cpu_data_req                 ),
    .o_data_sram_wr           (cpu_data_wr                  ),
    .o_data_sram_size         (cpu_data_size                ),
    .o_data_sram_addr         (cpu_data_addr                ),
    .o_data_sram_wstrb        (cpu_data_wstrb               ),
    .o_data_sram_wdata        (cpu_data_wdata               ),
    .i_data_sram_addr_ok      (cpu_data_addr_ok             ),
    .i_data_sram_data_ok      (cpu_data_data_ok             ),
    .i_data_sram_rdata        (cpu_data_rdata               )
  );

  ysyx_22050710_axi4full_master_wrap u_ifu_axi_wrap (
    .i_rw_req                 (cpu_inst_req                 ),  //IF&MEM输入信号
    .i_rw_wr                  (cpu_inst_wr                  ),  //IF&MEM输入信号
    .i_rw_size                (cpu_inst_size                ),  //IF&MEM输入信号
    .i_rw_addr                (cpu_inst_addr                ),  //IF&MEM输入信号
    .i_rw_wstrb               (cpu_inst_wstrb               ),  //IF&MEM输入信号
    .i_rw_wdata               (cpu_inst_wdata               ),  //IF&MEM输入信号
    .o_rw_addr_ok             (cpu_inst_addr_ok             ),  //IF&MEM输入信号
    .o_rw_data_ok             (cpu_inst_data_ok             ),  //IF&MEM输入信号
    .o_rw_rdata               (cpu_inst_rdata               ),  //IF&MEM输入信号

    .i_aclk                   (i_aclk                       ),
    .i_arsetn                 (i_arsetn                     ),

    // Wirte address channel
    .o_awaddr                 (ifu_awaddr                   ),
    .o_awlen                  (ifu_awlen                    ),
    .o_awsize                 (ifu_awsize                   ),
    .o_awburst                (ifu_awburst                  ),
    .o_awlock                 (ifu_awlock                   ),
    .o_awcache                (ifu_awcache                  ),
    .o_awprot                 (ifu_awprot                   ), // define the access permission for write accesses.
    .o_awvalid                (ifu_awvalid                  ),
    .i_awready                (ifu_awready                  ),

    // Write data channel
    .o_wdata                  (ifu_wdata                    ),
    .o_wstrb                  (ifu_wstrb                    ),
    .o_wlast                  (ifu_wlast                    ),
    .o_wvalid                 (ifu_wvalid                   ),
    .i_wready                 (ifu_wready                   ),

    // Write response channel
    .i_bresp                  (ifu_bresp                    ),
    .i_bvalid                 (ifu_bvalid                   ),
    .o_bready                 (ifu_bready                   ),

    // Read address channel
    .o_araddr                 (ifu_araddr                   ),
    .o_arlen                  (ifu_arlen                    ),
    .o_arsize                 (ifu_arsize                   ),
    .o_arburst                (ifu_arburst                  ),
    .o_arlock                 (ifu_arlock                   ),
    .o_arcache                (ifu_arcache                  ),
    .o_arprot                 (ifu_arprot                   ),
    .o_arvalid                (ifu_arvalid                  ),
    .i_arready                (ifu_arready                  ),

    // Read data channel
    .i_rdata                  (ifu_rdata                    ),
    .i_rresp                  (ifu_rresp                    ),
    .i_rlast                  (ifu_rlast                    ),
    .i_rvalid                 (ifu_rvalid                   ),
    .o_rready                 (ifu_rready                   )
  );

  ysyx_22050710_axi4full_master_wrap u_lsu_axi_wrap (
    .i_rw_req                 (cpu_data_req                 ),  //IF&MEM输入信号
    .i_rw_wr                  (cpu_data_wr                  ),  //IF&MEM输入信号
    .i_rw_size                (cpu_data_size                ),  //IF&MEM输入信号
    .i_rw_addr                (cpu_data_addr                ),  //IF&MEM输入信号
    .i_rw_wstrb               (cpu_data_wstrb               ),  //IF&MEM输入信号
    .i_rw_wdata               (cpu_data_wdata               ),  //IF&MEM输入信号
    .o_rw_addr_ok             (cpu_data_addr_ok             ),  //IF&MEM输入信号
    .o_rw_data_ok             (cpu_data_data_ok             ),  //IF&MEM输入信号
    .o_rw_rdata               (cpu_data_rdata               ),  //IF&MEM输入信号

    .i_aclk                   (i_aclk                       ),
    .i_arsetn                 (i_arsetn                     ),

    // Wirte address channel
    .o_awaddr                 (lsu_awaddr                   ),
    .o_awlen                  (lsu_awlen                    ),
    .o_awsize                 (lsu_awsize                   ),
    .o_awburst                (lsu_awburst                  ),
    .o_awlock                 (lsu_awlock                   ),
    .o_awcache                (lsu_awcache                  ),
    .o_awprot                 (lsu_awprot                   ), // define the access permission for write accesses.
    .o_awvalid                (lsu_awvalid                  ),
    .i_awready                (lsu_awready                  ),

    // Write data channel
    .o_wdata                  (lsu_wdata                    ),
    .o_wstrb                  (lsu_wstrb                    ),
    .o_wlast                  (lsu_wlast                    ),
    .o_wvalid                 (lsu_wvalid                   ),
    .i_wready                 (lsu_wready                   ),

    // Write response channel
    .i_bresp                  (lsu_bresp                    ),
    .i_bvalid                 (lsu_bvalid                   ),
    .o_bready                 (lsu_bready                   ),

    // Read address channel
    .o_araddr                 (lsu_araddr                   ),
    .o_arlen                  (lsu_arlen                    ),
    .o_arsize                 (lsu_arsize                   ),
    .o_arburst                (lsu_arburst                  ),
    .o_arlock                 (lsu_arlock                   ),
    .o_arcache                (lsu_arcache                  ),
    .o_arprot                 (lsu_arprot                   ),
    .o_arvalid                (lsu_arvalid                  ),
    .i_arready                (lsu_arready                  ),

    // Read data channel
    .i_rdata                  (lsu_rdata                    ),
    .i_rresp                  (lsu_rresp                    ),
    .i_rlast                  (lsu_rlast                    ),
    .i_rvalid                 (lsu_rvalid                   ),
    .o_rready                 (lsu_rready                   )
  );

  ysyx_22050710_axi4full_arbiter_2x1 u_axi_arbiter (
    .i_aclk                   (i_aclk                        ),
    .i_arsetn                 (i_arsetn                      ),

    // -------------------------------------------------------
    // A
    // Wirte address channel
    .i_a_awaddr               (ifu_awaddr                   ),
    .i_a_awlen                (ifu_awlen                    ),
    .i_a_awsize               (ifu_awsize                   ),
    .i_a_awburst              (ifu_awburst                  ),
    .i_a_awlock               (ifu_awlock                   ),
    .i_a_awcache              (ifu_awcache                  ),
    .i_a_awprot               (ifu_awprot                   ), // define the access permission for write accesses.
    .i_a_awvalid              (ifu_awvalid                  ),
    .o_a_awready              (ifu_awready                  ),

    // A Write data channel
    .i_a_wdata                (ifu_wdata                    ),
    .i_a_wstrb                (ifu_wstrb                    ),
    .i_a_wlast                (ifu_wlast                    ),
    .i_a_wvalid               (ifu_wvalid                   ),
    .o_a_wready               (ifu_wready                   ),

    // A Write response channel
    .o_a_bresp                (ifu_bresp                    ),
    .o_a_bvalid               (ifu_bvalid                   ),
    .i_a_bready               (ifu_bready                   ),

    // A Read address channel
    .i_a_araddr               (ifu_araddr                   ),
    .i_a_arlen                (ifu_arlen                    ),
    .i_a_arsize               (ifu_arsize                   ),
    .i_a_arburst              (ifu_arburst                  ),
    .i_a_arlock               (ifu_arlock                   ),
    .i_a_arcache              (ifu_arcache                  ),
    .i_a_arprot               (ifu_arprot                   ),
    .i_a_arvalid              (ifu_arvalid                  ),
    .o_a_arready              (ifu_arready                  ),

    // A Read data channel
    .o_a_rdata                (ifu_rdata                    ),
    .o_a_rresp                (ifu_rresp                    ),
    .o_a_rlast                (ifu_rlast                    ),
    .o_a_rvalid               (ifu_rvalid                   ),
    .i_a_rready               (ifu_rready                   ),

    // -------------------------------------------------------
    // B
    // Wirte address channel
    .i_b_awaddr               (lsu_awaddr                   ),
    .i_b_awlen                (lsu_awlen                    ),
    .i_b_awsize               (lsu_awsize                   ),
    .i_b_awburst              (lsu_awburst                  ),
    .i_b_awlock               (lsu_awlock                   ),
    .i_b_awcache              (lsu_awcache                  ),
    .i_b_awprot               (lsu_awprot                   ), // define the access permission for write accesses.
    .i_b_awvalid              (lsu_awvalid                  ),
    .o_b_awready              (lsu_awready                  ),

    // B Write data channel
    .i_b_wdata                (lsu_wdata                    ),
    .i_b_wstrb                (lsu_wstrb                    ),
    .i_b_wlast                (lsu_wlast                    ),
    .i_b_wvalid               (lsu_wvalid                   ),
    .o_b_wready               (lsu_wready                   ),

    // B Write response channel
    .o_b_bresp                (lsu_bresp                    ),
    .o_b_bvalid               (lsu_bvalid                   ),
    .i_b_bready               (lsu_bready                   ),

    // B Read address channel
    .i_b_araddr               (lsu_araddr                   ),
    .i_b_arlen                (lsu_arlen                    ),
    .i_b_arsize               (lsu_arsize                   ),
    .i_b_arburst              (lsu_arburst                  ),
    .i_b_arlock               (lsu_arlock                   ),
    .i_b_arcache              (lsu_arcache                  ),
    .i_b_arprot               (lsu_arprot                   ),
    .i_b_arvalid              (lsu_arvalid                  ),
    .o_b_arready              (lsu_arready                  ),

    // B Read data channel
    .o_b_rdata                (lsu_rdata                    ),
    .o_b_rresp                (lsu_rresp                    ),
    .o_b_rlast                (lsu_rlast                    ),
    .o_b_rvalid               (lsu_rvalid                   ),
    .i_b_rready               (lsu_rready                   ),

    // ---------------------------------------------------- ---
    // Wirte address channel
    .o_awid                   (o_awid                       ),
    .o_awaddr                 (o_awaddr                     ),
    .o_awlen                  (o_awlen                      ),
    .o_awsize                 (o_awsize                     ),
    .o_awburst                (o_awburst                    ),
    .o_awlock                 (o_awlock                     ),
    .o_awcache                (o_awcache                    ),
    .o_awprot                 (o_awprot                     ), // define the access permission for write accesses.
    .o_awvalid                (o_awvalid                    ),
    .i_awready                (i_awready                    ),

    // Write data channel
    .o_wid                    (o_wid                        ),
    .o_wdata                  (o_wdata                      ),
    .o_wstrb                  (o_wstrb                      ),
    .o_wlast                  (o_wlast                      ),
    .o_wvalid                 (o_wvalid                     ),
    .i_wready                 (i_wready                     ),

    // Write response channel
    .i_bid                    (i_bid                        ),
    .i_bresp                  (i_bresp                      ),
    .i_bvalid                 (i_bvalid                     ),
    .o_bready                 (o_bready                     ),

    // Read address channel
    .o_arid                   (o_arid                       ),
    .o_araddr                 (o_araddr                     ),
    .o_arlen                  (o_arlen                      ),
    .o_arsize                 (o_arsize                     ),
    .o_arburst                (o_arburst                    ),
    .o_arlock                 (o_arlock                     ),
    .o_arcache                (o_arcache                    ),
    .o_arprot                 (o_arprot                     ),
    .o_arvalid                (o_arvalid                    ),
    .i_arready                (i_arready                    ),

    // Read data channel
    .i_rid                    (i_rid                        ),
    .i_rdata                  (i_rdata                      ),
    .i_rresp                  (i_rresp                      ),
    .i_rlast                  (i_rlast                      ),
    .i_rvalid                 (i_rvalid                     ),
    .o_rready                 (o_rready                     )
  );

endmodule
