// ysyx_22050710 Cache

module ysyx_22050710_icache #(
  parameter ADDR_WIDTH       = 32                            ,
  parameter DATA_WIDTH       = 64                            ,
  parameter STRB_WIDTH       = (DATA_WIDTH/8)                , // 8
  parameter CACHE_SIZE       = 4096                          , // cache size in bytes 4096 bytes = 4k
  parameter CACHELINE_SIZE   = 32                            , // cache line size in bytes 32bytes
  parameter CACHELINE_BITS   = CACHELINE_SIZE * 8            , // cache line size in bits 32 * 8 = 256
  parameter CACHELINE_NUM    = CACHE_SIZE / CACHELINE_SIZE   , // cacheline 数量 128
  parameter ASSOC_NUM        = 2                             , // 二路组相连 2
  parameter INDEX_NUM        = CACHELINE_NUM / ASSOC_NUM     , // Index 数量 64
  parameter WAY_SIZE         = CACHE_SIZE / ASSOC_NUM        , // 路大小 2048
  parameter OFFSET_WIDTH     = $clog2(CACHELINE_SIZE)        , // Cache 行内偏移 5
  parameter INDEX_WIDTH      = $clog2(INDEX_NUM)             , // index width in bits 6bits
  parameter TAG_WIDTH        = ADDR_WIDTH - $clog2(WAY_SIZE)   // 物理地址宽度 - log2(路大小) 32 - 11 = 21
) (
  input                        i_clk                         , // 时钟信号
  input                        i_rst                         , // 复位信号

  // Cache 与 CPU 流水线接口
  input                        i_valid                       , // 表明请求有效
  input  [1:0                ] i_rw_size                     , // IF&MEM输入信号
  input                        i_op                          , // 1 : WRITE; 0: READ
  input  [INDEX_WIDTH-1:0    ] i_index                       , // 地址的 index  域 addr[10:5]
  input  [TAG_WIDTH-1:0      ] i_tag                         , // 地址的 tag    域 addr[31:11]
  input  [OFFSET_WIDTH-1:0   ] i_offset                      , // 地址的 offset 域 addr[4:0]
  input  [STRB_WIDTH-1:0     ] i_wstrb                       , // 写字节使能信号
  input  [DATA_WIDTH-1:0     ] i_wdata                       , // 写数据
  output                       o_addr_ok                     , // 该次请求的地址传输 OK, 读: 地址被接收; 写: 地址和数据被接收
  output                       o_data_ok                     , // 该次请求的数据传输 OK, 读: 数据返回; 写: 数据写入完成
  output [DATA_WIDTH-1:0     ] o_rdata                       , // 读 Cache 的结果

  // Cache 与 AXI 总线接口的交互接口
  output                       o_rd_req                      , // 读请求有效信号, 高电平有效
  output [2:0                ] o_rd_type                     , // 读请求类型 3'b001: 字节, 3'b010: 半字, 3'b100: 字, 3'b111: Cache 行
  output [ADDR_WIDTH-1:0     ] o_rd_addr                     , // 读请求起始地址
  input                        i_rd_rdy                      , // 读请求能否被接收的握手信号. 高电平有效.
  input                        i_ret_valid                   , // 返回数据有效. 高电平有效.
  input                        i_ret_last                    , // 返回数据是一次读请求对应的最后一个返回数据
  input  [DATA_WIDTH-1:0     ] i_ret_data                    , // 读返回数据
  output                       o_wr_req                      , // 写请求有效信号. 高电平有效
  output [2:0                ] o_wr_type                     , // 写请求类型 4'b001: b, 3'b010: 半字, 3'b100: 字, 3'b100:  Cache 行
  output [ADDR_WIDTH-1:0     ] o_wr_addr                     , // 写请求起始地址
  output [STRB_WIDTH-1:0     ] o_wr_wstrb                    , // 写操作的字节掩码. 仅在写请求类型为 3'b000, 3'b001, 3'b010的情况下才有意义
  output [CACHELINE_BITS-1:0 ] o_wr_data                     , // 写数据 256bit
  input                        i_wr_rdy                        // 写请求能否被接收的握手信号. 高电平有效. 此处要求 wr_rdy 要先于 wr_req 置起, wr_req 看到 wr_rdy 后才可能置起
);

  // deal with input
  parameter BITS             = 128                           ;
  wire [ASSOC_NUM-1:0        ] cen                           ;
  wire [ASSOC_NUM-1:0        ] wen                           ;
  wire [DATA_WIDTH-1:0       ] word_wen                      ; // 写字长 写使能掩码位
  wire [DATA_WIDTH-1:0       ] w_data                        ;
  wire [CACHELINE_BITS-1:0   ] wdata                         ;
  wire [CACHELINE_BITS-1:0   ] bwen                          ;
  wire [OFFSET_WIDTH-1:0     ] offset                        ;
  wire [STRB_WIDTH-1:0       ] wstrb                         ;

  wire cen_sel               = i_valid;
  assign cen                 = (c_state_miss | c_state_refill)
                             ? (replace_way ? 2'b01 : 2'b10)   // 低电平有效
                             : cen_sel ? 2'b00 : 2'b11       ; // 低电平有效

  wire wen_sel               = c_state_refill;
  assign wen                 = wen_sel ? (replace_way ? 2'b01 : 2'b10) : 2'b11       ; // 低电平有效

  // Store 操作在 Look Up 时发现命中 Cache
  wire hit_write             = c_state_lookup && cache_hit && ~request_wen;

  assign wstrb               = {8{1'b1}}                     ;
  assign word_wen            = 64'b0                         ;

  MuxKey #(
    .NR_KEY                   (4                            ),
    .KEY_LEN                  (2                            ),
    .DATA_LEN                 (CACHELINE_BITS               )
  ) u_mux0 (
    .out                      (bwen                         ),
    .key                      (mb_num_haveret[1:0]),
    .lut                      ({
                                2'b00, {{192{1'b1}}, word_wen       },
                                2'b01, {{128{1'b1}}, word_wen, {64{1'b1}}},
                                2'b10, {{64{1'b1}}, word_wen,{128{1'b1}}},
                                2'b11, {word_wen, {192{1'b1}}       }
                              })
  );

  MuxKey #(
    .NR_KEY                   (4                            ),
    .KEY_LEN                  (2                            ),
    .DATA_LEN                 (CACHELINE_BITS               )
  ) u_mux1 (
    .out                      (wdata                        ),
    .key                      (mb_num_haveret[1:0]),
    .lut                      ({
                                2'b00, {192'b0, i_ret_data       },
                                2'b01, {128'b0, i_ret_data, 64'b0},
                                2'b10, {64'b0 , i_ret_data,128'b0},
                                2'b11, {i_ret_data, 192'b0       }
                              })
  );

  // ---------------------------------------------------------
  // Organize manager
  // tag array
  reg [TAG_WIDTH-1:0] tag   [ASSOC_NUM-1:0][INDEX_NUM-1:0]   ;
  reg                 valid [ASSOC_NUM-1:0][INDEX_NUM-1:0]   ;
  reg                 dirty [ASSOC_NUM-1:0][INDEX_NUM-1:0]   ;

  wire [CACHELINE_BITS-1:0] cacheline_way [ASSOC_NUM-1:0]    ;

  // ---------------------------------------------------------
  // data array
  wire [INDEX_WIDTH-1:0      ] addr                          ;
  assign addr                = index                         ;
  ysyx_22050710_S011HD1P_X32Y2D128_BW u_way00 (
    .Q                        (cacheline_way[0][BITS-1:0]   ), // 读数据
    .CLK                      (i_clk                        ), // 时钟
    .CEN                      (cen[0]                       ), // 使能信号, 低电平有效
    .WEN                      (wen[0]                       ), // 写使能信号, 低电平有效
    .BWEN                     (bwen[BITS-1:0]               ), // 写掩码信号, 掩码粒度为 1bit, 低电平有效
    .A                        (addr                         ), // 读写地址
    .D                        (wdata[BITS-1:0]              )  // 写数据
  );

  ysyx_22050710_S011HD1P_X32Y2D128_BW u_way01 (
    .Q                        (cacheline_way[0][CACHELINE_BITS-1:BITS]), // 读数据
    .CLK                      (i_clk                        ), // 时钟
    .CEN                      (cen[0]                       ), // 使能信号, 低电平有效
    .WEN                      (wen[0]                       ), // 写使能信号, 低电平有效
    .BWEN                     (bwen[CACHELINE_BITS-1:BITS]  ), // 写掩码信号, 掩码粒度为 1bit, 低电平有效
    .A                        (addr                         ), // 读写地址
    .D                        (wdata[CACHELINE_BITS-1:BITS] )  // 写数据
  );
  
  ysyx_22050710_S011HD1P_X32Y2D128_BW u_way10 (
    .Q                        (cacheline_way[1][BITS-1:0]   ), // 读数据
    .CLK                      (i_clk                        ), // 时钟
    .CEN                      (cen[1]                       ), // 使能信号, 低电平有效
    .WEN                      (wen[1]                       ), // 写使能信号, 低电平有效
    .BWEN                     (bwen[BITS-1:0]               ), // 写掩码信号, 掩码粒度为 1bit, 低电平有效
    .A                        (addr                         ), // 读写地址
    .D                        (wdata[BITS-1:0]              )  // 写数据
  );

  ysyx_22050710_S011HD1P_X32Y2D128_BW u_way11 (
    .Q                        (cacheline_way[1][CACHELINE_BITS-1:BITS]), // 读数据
    .CLK                      (i_clk                        ), // 时钟
    .CEN                      (cen[1]                       ), // 使能信号, 低电平有效
    .WEN                      (wen[1]                       ), // 写使能信号, 低电平有效
    .BWEN                     (bwen[CACHELINE_BITS-1:BITS]  ), // 写掩码信号, 掩码粒度为 1bit, 低电平有效
    .A                        (addr                         ), // 读写地址
    .D                        (wdata[CACHELINE_BITS-1:BITS] )  // 写数据
  );

  integer assoc;
  integer idx;
  always @(posedge i_clk) begin
    if (i_rst) begin
      for (assoc = 0; assoc < ASSOC_NUM; assoc = assoc + 1) begin
        for (idx = 0; idx < INDEX_NUM; idx = idx + 1) begin
            tag[assoc][idx] <= 0;
          valid[assoc][idx] <= 0;
          dirty[assoc][idx] <= 0;
        end
      end
    end
    else begin
      if (c_state_refill) begin
        valid[replace_way][request_index] <= 1'b1;
        tag[replace_way][request_index] <= request_tag;
        dirty[replace_way][request_index] <= 1'b0;
      end
      /* TODO */
    end
  end

  // ----------------------------------------------------------
  // Request Buffer
  wire [1+INDEX_WIDTH+TAG_WIDTH+OFFSET_WIDTH+STRB_WIDTH+DATA_WIDTH-1:0] request_buffer;
  wire request_buffer_wen    = (c_state_idle && i_valid) | (c_state_lookup && cache_hit);
  Reg #(
    .WIDTH                    (1+INDEX_WIDTH+TAG_WIDTH+OFFSET_WIDTH+STRB_WIDTH+DATA_WIDTH),
    .RESET_VAL                (0                            )
  ) u_request_buffer_r (
    .clk                      (i_clk                        ),
    .rst                      (i_rst                        ),
    .din                      ({~i_op, i_index, i_tag, i_offset, ~i_wstrb, i_wdata}), // i_op 0r 1w, wstrb 低电平有效
    .dout                     (request_buffer               ),
    .wen                      (request_buffer_wen           )
  );

  wire                         request_wen                   ;
  wire [INDEX_WIDTH-1:0      ] request_index                 ;
  wire [TAG_WIDTH-1:0        ] request_tag                   ;
  wire [OFFSET_WIDTH-1:0     ] request_offset                ;
  wire [STRB_WIDTH-1:0       ] request_wstrb                 ;
  wire [DATA_WIDTH-1:0       ] request_wdata                 ;

  assign {request_wen                                        ,
          request_index                                      ,
          request_tag                                        ,
          request_offset                                     ,
          request_wstrb                                      ,
          request_wdata
         }                   = request_buffer                ;

  // ----------------------------------------------------------
  // Tag Compare
  wire [INDEX_WIDTH-1:0]       index                         ;
  wire [INDEX_WIDTH-1:0]       main_index                    ;
  MuxKeyWithDefault #(
    .NR_KEY                   (4                            ),
    .KEY_LEN                  (3                            ),
    .DATA_LEN                 (INDEX_WIDTH                  )
  ) u_mux2 (
    .out                      (main_index                   ),
    .key                      (cache_state_reg              ),
    .default_out              (i_index                      ),
    .lut                      ({
                                CACHE_IDLE   , i_index       ,
                                CACHE_LOOKUP , i_index       ,
                                CACHE_REPLACE, request_index ,
                                CACHE_REFILL , request_index
                              })
  );
  assign index               = main_index                    ;

  wire way0_v                = valid[0][request_index]       ;
  wire way1_v                = valid[1][request_index]       ;

  wire [TAG_WIDTH-1:0        ] way0_tag                      ;
  wire [TAG_WIDTH-1:0        ] way1_tag                      ;
  assign way0_tag            = tag[0][request_index]         ;
  assign way1_tag            = tag[1][request_index]         ;

  wire way0_d                = dirty[0][request_index]       ;
  wire way1_d                = dirty[1][request_index]       ;

  wire way0_hit              = way0_v && (way0_tag == request_tag);
  wire way1_hit              = way1_v && (way1_tag == request_tag);

  wire cache_hit             = way0_hit || way1_hit          ;

  // ---------------------------------------------------------
  // Data Select
  wire [DATA_WIDTH-1:0       ] way0_load_word                ;
  wire [DATA_WIDTH-1:0       ] way1_load_word                ;
  wire [DATA_WIDTH-1:0       ] load_result                   ;
  wire [CACHELINE_BITS-1:0   ] replace_data                  ;
  wire [1:0                  ] addr_align                    ; // 根据锁存下的 addr[4:3] 来选择 256bit(32字节) 中的8字节
  assign addr_align          = request_offset[4:3]           ;
  assign way0_load_word      = cacheline_way[0][addr_align*64 +: 64];
  assign way1_load_word      = cacheline_way[1][addr_align*64 +: 64];

  assign load_result         = {DATA_WIDTH{way0_hit}} & way0_load_word
                             | {DATA_WIDTH{way1_hit}} & way1_load_word; // 如果考虑 Miss, 应该是三选一逻辑

  // ---------------------------------------------------------
  // Miss Buffer

  // 计算伪随机数
  reg lfsr;
  always @(posedge i_clk) begin
    if (i_rst)
      lfsr <= 1'b1;
    else
      lfsr <= lfsr ^ 1'b1;
  end

  wire                         mb_way_to_replace             ;
  wire [3-1:0                ] mb_num_haveret                ;
  Reg #(
    .WIDTH                    (1                            ),
    .RESET_VAL                (0                            )
  ) u_missing_buffer_way_to_replace_reg (
    .clk                      (i_clk                        ),
    .rst                      (i_rst                        ),
    .din                      (lfsr                         ),
    .dout                     (mb_way_to_replace            ),
    .wen                      (c_state_miss && i_wr_rdy == 1)
  );

  Reg #(
    .WIDTH                    (3                            ),
    .RESET_VAL                (0                            )
  ) u_missing_buffer_num_have_ret_reg (
    .clk                      (i_clk                        ),
    .rst                      (i_rst || ~c_state_refill     ),
    .din                      (mb_num_haveret + 3'b1        ),
    .dout                     (mb_num_haveret               ),
    .wen                      (c_state_refill && i_ret_valid)
  );

  // 计算替换索引
  wire replace_way           = mb_way_to_replace             ;
  wire [CACHELINE_BITS-1:0   ] replace_data                  ;
  assign replace_data        = replace_way ? cacheline_way[1] : cacheline_way[0];

  /* ---------------------------------------------------------
   * State Machine
   * --------------------------------------------------------- */
  localparam [2:0]
    CACHE_IDLE               = 3'd0                          ,
    CACHE_LOOKUP             = 3'd1                          ,
    CACHE_MISS               = 3'd2                          ,
    CACHE_REPLACE            = 3'd3                          ,
    CACHE_REFILL             = 3'd4                          ;

  reg [2:0] cache_state_reg        = CACHE_IDLE              ;

  wire c_state_idle    = cache_state_reg == CACHE_IDLE       ;
  wire c_state_lookup  = cache_state_reg == CACHE_LOOKUP     ;
  wire c_state_miss    = cache_state_reg == CACHE_MISS       ;
  wire c_state_replace = cache_state_reg == CACHE_REPLACE    ;
  wire c_state_refill  = cache_state_reg == CACHE_REFILL     ;

  always @(posedge i_clk) begin
    if (i_rst) begin
      cache_state_reg <= CACHE_IDLE;
    end
    else begin
      case (cache_state_reg)
        CACHE_IDLE: begin
          if (i_valid) begin
            cache_state_reg <= CACHE_LOOKUP;
          end
        end
        CACHE_LOOKUP: begin
          if (cache_hit) begin
            if (i_valid) begin // 1. 当前处理 cache 命中, 有 cache 请求, 但与 Hit Write 无冲突
              cache_state_reg <= CACHE_LOOKUP;
            end
            else begin // 1. 当前处理 cache 命中, 没有新的cache访问请求 2. 当前处理 cache 命中, 有 cache 请求, 但与 Hit Write 冲突
              cache_state_reg <= CACHE_IDLE;
            end
          end
          else begin
            cache_state_reg <= CACHE_MISS;
          end
        end
        CACHE_MISS: begin
          if (i_wr_rdy) begin
            cache_state_reg <= CACHE_REPLACE;
          end
        end
        CACHE_REPLACE: begin
          if (i_rd_rdy) begin
            cache_state_reg <= CACHE_REFILL;
          end
        end
        CACHE_REFILL: begin
          if (i_ret_valid && i_ret_last) begin
            cache_state_reg <= CACHE_IDLE;
          end
        end
        default: cache_state_reg <= CACHE_IDLE;
      endcase
    end
  end

  assign o_addr_ok           = c_state_idle                                                      // 1. Cache 主状态机处于 IDLE
                             ||(c_state_lookup && cache_hit && i_valid);  // 2. Cache 主状态机处于 LOOKUP 并将进行 LOOKUP->LOOKUP 的转变
  assign o_data_ok           = (c_state_lookup && cache_hit  )  // 1. Cache 当前 LOOKUP 且 Cache 命中
                             ||(c_state_refill && i_ret_valid && mb_num_haveret == {1'b0, addr_align}); // 3. Cache 当前状态为 REFILL 且 ret_valid = 1, 同时 Miss Buffer 返回的字个数与 缺失地址 request_offset[4:3] 相等
  assign o_rdata             = (c_state_lookup && cache_hit)
                             ? load_result
                             : i_ret_data                    ;
  assign o_wr_data           = {CACHELINE_BITS{c_state_replace}} & replace_data;

  assign o_rd_req            = c_state_replace               ;
  assign o_rd_type           = {3{c_state_replace}} & 3'b100 ; // 缺失 读一整个 cache line
  assign o_rd_addr           = {request_tag, request_index, {OFFSET_WIDTH{1'b0}}};
  assign o_wr_type           = {3{c_state_replace}} & 3'b100 ; // 缺失 写一整个 cache line
  wire                         wr_req                        ;
  Reg #(
    .WIDTH                    (1                            ),
    .RESET_VAL                (0                            )
  ) u_wr_req_r (
    .clk                      (i_clk                        ),
    .rst                      (i_rst || o_wr_req            ),
    .din                      (1'b1                         ),
    .dout                     (wr_req                       ),
    .wen                      (c_state_miss && i_wr_rdy     )
  );
  assign o_wr_req            = wr_req & dirty[replace_way][request_index];

  assign o_wr_wstrb          = wstrb                          ;
  assign o_wr_addr           = {ADDR_WIDTH{c_state_replace}} & {tag[replace_way][request_index], request_index, {OFFSET_WIDTH{1'b0}}};

endmodule
