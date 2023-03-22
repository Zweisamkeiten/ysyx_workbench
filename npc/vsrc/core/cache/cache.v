//// ysyx_22050710 Cache
//
//module ysyx_22050710_cache #(
//  parameter ADDR_WIDTH       = 32                            ,
//  parameter DATA_WIDTH       = 64                            ,
//  parameter STRB_WIDTH       = (DATA_WIDTH/8)                ,
//  parameter CACHE_SIZE       = 4096                          , // cache size in bytes
//  parameter CACHELINE_SIZE   = 16                            , // cache line size in bytes
//  parameter CACHELINE_NUM    = CACHE_SIZE / CACHELINE_SIZE   , // cacheline 数量
//  parameter ASSOC_NUM        = 4                             , // 四路组相连
//  parameter INDEX_NUM        = CACHELINE_NUM / ASSOC_NUM     , // Index 数量
//  parameter WAY_SIZE         = CACHE_SIZE / ASSOC_NUM        , // 路大小
//  parameter OFFSET_WIDTH     = $clog2(CACHELINE_SIZE)        , // Cache 行内偏移
//  parameter INDEX_WIDTH      = $clog2(INDEX_NUM)             , // index width in bits 6bits
//  parameter TAG_WIDTH        = ADDR_WIDTH - $clog2(WAY_SIZE)   // 物理地址宽度 - log2(路大小)
//) (
//  input                        i_clk                         , // 时钟信号
//  input                        i_rst                         , // 复位信号
//
//  // Cache 与 CPU 流水线接口
//  input                        i_valid                       , // 表明请求有效
//  input                        i_op                          , // 1 : WRITE; 0: READ
//  input  [INDEX_WIDTH-1:0    ] i_index                       , // 地址的 index  域 addr[9:4]
//  input  [TAG_WIDTH-1:0      ] i_tag                         , // 地址的 tag    域 addr[31:10]
//  input  [OFFSET_WIDTH-1:0   ] i_offset                      , // 地址的 offset 域 addr[3:0]
//  input  [STRB_WIDTH-1-1:0   ] i_wstrb                       , // 写字节使能信号
//  input  [DATA_WIDTH-1:0     ] i_wdata                       , // 写数据
//  output                       o_addr_ok                     , // 该次请求的地址传输 OK, 读: 地址被接收; 写: 地址和数据被接收
//  output                       o_data_ok                     , // 该次请求的数据传输 OK, 读: 数据返回; 写: 数据写入完成
//  output [DATA_WIDTH-1:0     ] o_rdata                       , // 读 Cache 的结果
//
//  // Cache 与 AXI 总线接口的交互接口
//  output                       o_rd_req                      , // 读请求有效信号, 高电平有效
//  output [2:0                ] o_rd_type                     , // 读请求类型 3'b000: 字节, 3'b001: 半字, 3'b010: 字, 3'b100: Cache 行
//  output [ADDR_WIDTH-1:0     ] o_rd_addr                     , // 读请求起始地址
//  input                        i_rd_rdy                      , // 读请求能否被接收的握手信号. 高电平有效.
//  input                        i_ret_valid                   , // 返回数据有效. 高电平有效.
//  input  [1:0                ] i_ret_last                    , // 返回数据是一次读请求对应的最后一个返回数据
//  input  [DATA_WIDTH-1:0     ] i_ret_data                    , // 读返回数据
//  output                       o_wr_req                      , // 写请求有效信号. 高电平有效
//  output [2:0                ] o_wr_type                     , // 写请求类型 3'b000: 字节, 3'b001: 半字, 3'b010: 字, 3'b100:  Cache 行
//  output [ADDR_WIDTH-1:0     ] o_wr_addr                     , // 写请求起始地址
//  output [OFFSET_WIDTH-1:0   ] o_wr_wstrb                    , // 写操作的字节掩码. 仅在写请求类型为 3'b000, 3'b001, 3'b010的情况下才有意义
//  output [DATA_WIDTH-1:0     ] o_wr_data                     , // 写数据
//  input                        i_wr_rdy                        // 写请求能否被接收的握手信号. 高电平有效. 此处要求 wr_rdy 要先于 wr_req 置器, wr_req 看到 wr_rdy 后才可能置起
//);
//
//  // deal with input
//  parameter Bits             = 128                           ;
//  wire [4-1:0                ] wstrb                         ;
//  wire                         cen                           ;
//  wire                         wen                           ;
//  wire [Bits-1:0             ] bwen                          ;
//  assign wstrb               = ~i_wstrb                      ;
//  assign cen                 = ~i_valid                      ;
//  assign wen                 = ~i_op                         ;
//
//  MuxKey #(
//    .NR_KEY                   (16                           ),
//    .KEY_LEN                  (4                            ),
//    .DATA_LEN                 (128                          )
//  ) u_mux0 (
//    .out                      (bwen                         ),
//    .key                      (wstrb                        ),
//    .lut                      ({
//                                4'd0 , 128'b0                ,
//                                4'd1 , {120'b0, 8'b1        },
//                                4'd2 , {112'b0, 8'b1,   8'b0},
//                                4'd3 , {104'b0, 8'b1,  16'b0},
//                                4'd4 , { 96'b0, 8'b1,  24'b0},
//                                4'd5 , { 88'b0, 8'b1,  32'b0},
//                                4'd6 , { 80'b0, 8'b1,  40'b0},
//                                4'd7 , { 72'b0, 8'b1,  48'b0},
//                                4'd8 , { 64'b0, 8'b1,  56'b0},
//                                4'd9 , { 56'b0, 8'b1,  64'b0},
//                                4'd10, { 48'b0, 8'b1,  72'b0},
//                                4'd11, { 40'b0, 8'b1,  80'b0},
//                                4'd12, { 32'b0, 8'b1,  88'b0},
//                                4'd13, { 24'b0, 8'b1,  96'b0},
//                                4'd14, { 16'b0, 8'b1, 104'b0},
//                                4'd15, {  8'b0, 8'b1, 112'b0}
//                              })
//  );
//
//  // ---------------------------------------------------------
//  // Organize manager
//  // tag array
//  reg [TAG_WIDTH-1:0] tag   [INDEX_WIDTH-1:0][ASSOC_NUM-1:0] ;
//  reg [ASSOC_NUM-1:0] valid [INDEX_WIDTH-1:0]                ;
//  reg [ASSOC_NUM-1:0] dirty [INDEX_WIDTH-1:0]                ;
//
//  wire [CACHELINE_SIZE-1:0] cacheline_way [ASSOC_NUM-1]      ;
//
//  // ---------------------------------------------------------
//  // data array
//  ysyx_22050710_S011HD1P_X32Y2D128_BW u_way0 (
//    .Q                        (cacheline_way[0]             ), // 读数据
//    .CLK                      (i_clk                        ), // 时钟
//    .CEN                      (cen                          ), // 使能信号, 低电平有效
//    .WEN                      (wen                          ), // 写使能信号, 低电平有效
//    .BWEN                     (bwen                         ), // 写掩码信号, 掩码粒度为 1bit, 低电平有效
//    .A                        (i_index                      ), // 读写地址
//    .D                        ()  // 写数据
//  );
//
//  ysyx_22050710_S011HD1P_X32Y2D128_BW u_way1 (
//    .Q                        (cacheline_way[1]             ), // 读数据
//    .CLK                      (i_clk                        ), // 时钟
//    .CEN                      (cen                          ), // 使能信号, 低电平有效
//    .WEN                      (wen                          ), // 写使能信号, 低电平有效
//    .BWEN                     (bwen                         ), // 写掩码信号, 掩码粒度为 1bit, 低电平有效
//    .A                        (i_index                      ), // 读写地址
//    .D                        ()  // 写数据
//  );
//  
//  ysyx_22050710_S011HD1P_X32Y2D128_BW u_way2 (
//    .Q                        (cacheline_way[2]             ), // 读数据
//    .CLK                      (i_clk                        ), // 时钟
//    .CEN                      (cen                          ), // 使能信号, 低电平有效
//    .WEN                      (wen                          ), // 写使能信号, 低电平有效
//    .BWEN                     (bwen                         ), // 写掩码信号, 掩码粒度为 1bit, 低电平有效
//    .A                        (i_index                      ), // 读写地址
//    .D                        ()  // 写数据
//  );
//
//  ysyx_22050710_S011HD1P_X32Y2D128_BW u_way3 (
//    .Q                        (cacheline_way[3]             ), // 读数据
//    .CLK                      (i_clk                        ), // 时钟
//    .CEN                      (cen                          ), // 使能信号, 低电平有效
//    .WEN                      (wen                          ), // 写使能信号, 低电平有效
//    .BWEN                     (bwen                         ), // 写掩码信号, 掩码粒度为 1bit, 低电平有效
//    .A                        (i_index                      ), // 读写地址
//    .D                        ()  // 写数据
//  );
//
//  // ----------------------------------------------------------
//  // Request Buffer
//  wire [1+INDEX_WIDTH+TAG_WIDTH+OFFSET_WIDTH+STRB_WIDTH-1:0] request_buffer;
//  Reg #(
//    .WIDTH                    (1+INDEX_WIDTH+TAG_WIDTH+OFFSET_WIDTH+STRB_WIDTH),
//    .RESET_VAL                (0                            )
//  ) u_request_buffer_r (
//    .clk                      (i_clk                        ),
//    .rst                      (i_rst                        ),
//    .din                      ({i_op, i_index, i_tag, i_offset, i_wstrb}),
//    .dout                     (request_buffer               ),
//    .wen                      (i_valid                      )
//  );
//  wire                         lookup_op                     ;
//  wire [INDEX_WIDTH-1:0      ] lookup_index                  ;
//  wire [TAG_WIDTH-1:0        ] lookup_tag                    ;
//  wire [OFFSET_WIDTH-1:0     ] lookup_offset                 ;
//  wire [STRB_WIDTH-1:0       ] lookup_wstrb                  ;
//
//  assign {lookup_op                                          ,
//          lookup_index                                       ,
//          lookup_tag                                         ,
//          lookup_offset                                      ,
//          lookup_wstrb
//         }                   = request_buffer                ;
//
//  // ----------------------------------------------------------
//  // Tag Compare
//  wire way0_v                = valid[i_index][0]             ;
//  wire way1_v                = valid[i_index][1]             ;
//  wire way2_v                = valid[i_index][2]             ;
//  wire way3_v                = valid[i_index][3]             ;
//
//  wire way0_tag              = tag[i_index][0]               ;
//  wire way1_tag              = tag[i_index][1]               ;
//  wire way2_tag              = tag[i_index][2]               ;
//  wire way3_tag              = tag[i_index][3]               ;
//
//  wire way0_d                = dirty[i_index][0]             ;
//  wire way1_d                = dirty[i_index][1]             ;
//  wire way2_d                = dirty[i_index][2]             ;
//  wire way3_d                = dirty[i_index][3]             ;
//
//  wire way0_hit              = way0_v && (way0_tag == i_tag);
//  wire way1_hit              = way1_v && (way1_tag == i_tag);
//  wire way2_hit              = way2_v && (way2_tag == i_tag);
//  wire way3_hit              = way3_v && (way3_tag == i_tag);
//
//  wire cache_hit             = way0_hit || way1_hit || way2_hit || way3_hit;
//
//  // ---------------------------------------------------------
//  // Write Buffer
//  wire [DATA_WIDTH-1:0       ] write_buffer                  ;
//  Reg #(
//    .WIDTH                    (DATA_WIDTH                   ),
//    .RESET_VAL                (0                            )
//  ) u_write_buffer_reg (
//    .clk                      (i_clk                        ),
//    .rst                      (i_rst                        ),
//    .din                      (i_wdata                      ),
//    .dout                     (write_buffer                 ),
//    .wen                      (i_valid & wen                )
//  );
//
//  // ---------------------------------------------------------
//  // Data Select
//  wire [DATA_WIDTH-1:0]        way0_load_word                ;
//  wire [DATA_WIDTH-1:0]        way1_load_word                ;
//  wire [DATA_WIDTH-1:0]        way2_load_word                ;
//  wire [DATA_WIDTH-1:0]        way3_load_word                ;
//  wire [DATA_WIDTH-1:0]        load_result                   ;
//  wire [DATA_WIDTH-1:0]        replace_data                  ;
//  wire                         addr_align                    ; // 根据 addr[3] 来选择 128bit(16字节) 中的前8字节还是后8字节
//  assign way0_load_word      = addr_align ? cacheline_way[0][CACHELINE_SIZE-1:DATA_WIDTH] : cacheline_way[0][DATA_WIDTH-1:0];
//  assign way1_load_word      = addr_align ? cacheline_way[1][CACHELINE_SIZE-1:DATA_WIDTH] : cacheline_way[1][DATA_WIDTH-1:0];
//  assign way2_load_word      = addr_align ? cacheline_way[2][CACHELINE_SIZE-1:DATA_WIDTH] : cacheline_way[2][DATA_WIDTH-1:0];
//  assign way3_load_word      = addr_align ? cacheline_way[3][CACHELINE_SIZE-1:DATA_WIDTH] : cacheline_way[3][DATA_WIDTH-1:0];
//
//  assign load_result         = {DATA_WIDTH{way0_hit}} & way0_load_word
//                             | {DATA_WIDTH{way1_hit}} & way1_load_word
//                             | {DATA_WIDTH{way2_hit}} & way2_load_word
//                             | {DATA_WIDTH{way3_hit}} & way3_load_word; // 如果考虑 Miss, 应该是五选一逻辑
//  integer assoc;
//  integer idx;
//  always @(posedge i_clk) begin
//    if (i_rst) begin
//      for (assoc = 0; assoc < ASSOC_NUM; assoc = assoc + 1) begin
//        for (idx = 0; idx < INDEX_NUM; idx = idx + 1) begin
//            tag[idx][assoc] <= 0;
//          valid[idx][assoc] <= 0;
//          dirty[idx][assoc] <= 0;
//        end
//      end
//    end
//    else begin
//      /* TODO */
//    end
//  end
//  localparam [2:0]
//    CACHE_IDLE               = 3'd0                          ,
//    CACHE_LOOKUP             = 3'd1                          ,
//    CACHE_MISS               = 3'd2                          ,
//    CACHE_REPLACE            = 3'd3                          ,
//    CACHE_REFILL             = 3'd2                          ;
//
//  localparam [0:0]
//    W_BURF_IDLE              = 1'd0                          ,
//    W_BURF_WRITE             = 1'd1                          ;
//
//  reg [2:0] cache_state_reg        = CACHE_IDLE              ;
//  reg [0:0] write_buffer_state_reg = W_BURF_IDLE             ;
//
//  /* ---------------------------------------------------------
//   * State Machine
//   * --------------------------------------------------------- */
//
//  wire c_state_idle    = cache_state_reg == CACHE_IDLE       ;
//  wire c_state_lookup  = cache_state_reg == CACHE_LOOKUP     ;
//  wire c_state_miss    = cache_state_reg == CACHE_MISS       ;
//  wire c_state_replace = cache_state_reg == CACHE_REPLACE    ;
//  wire c_state_refill  = cache_state_reg == CACHE_REFILL     ;
//
//  wire wb_state_idle   = write_buffer_state_reg == W_BURF_IDLE ;
//  wire wb_state_write  = write_buffer_state_reg == W_BURF_WRITE;
//
//  always @(posedge i_clk) begin
//    if (i_rst) begin
//      cache_state_reg <= CACHE_IDLE;
//    end
//    else begin
//      case (cache_state_reg)
//        CACHE_IDLE: begin
//          if (i_valid) begin
//            cache_state_reg <= CACHE_LOOKUP;
//          end
//        end
//        CACHE_LOOKUP: begin
//          if (cache_hit) begin
//            cache_state_reg <= CACHE_IDLE;
//          end
//          else begin
//            cache_state_reg <= CACHE_MISS;
//          end
//        end
//        CACHE_MISS: begin
//          if (i_wr_rdy) begin
//            cache_state_reg <= CACHE_REPLACE;
//          end
//        end
//        CACHE_REPLACE: begin
//          if (i_rd_rdy) begin
//            cache_state_reg <= CACHE_REFILL;
//          end
//        end
//        CACHE_REFILL: begin
//        end
//        default: cache_state_reg <= CACHE_IDLE;
//      endcase
//    end
//  end
//
//  always @(posedge i_clk) begin
//    if (i_rst) begin
//      write_buffer_state_reg <= W_BURF_IDLE;
//    end
//    else begin
//      case (write_buffer_state_reg)
//        W_BURF_IDLE: begin
//          if (c_state_lookup && cache_hit) begin
//            write_buffer_state_reg <= W_BURF_WRITE;
//          end
//        end
//        W_BURF_WRITE: begin
//        end
//        default: write_buffer_state_reg <= W_BURF_IDLE;
//      endcase
//    end
//  end
//
//  assign o_addr_ok           = c_state_idle                  ; // 1. Cache 主状态机出于 IDLE
//  assign o_data_ok           = c_state_lookup & cache_hit    ; // 1. Cache 当前 LOOKUP 且 Cache 命中
//  assign o_rdata             = {DATA_WIDTH{o_data_ok}} & load_result;
//
//endmodule
