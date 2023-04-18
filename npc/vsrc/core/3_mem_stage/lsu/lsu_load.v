// ysyx_22050710 lsu load unit

module ysyx_22050710_lsu_load #(
  parameter WORD_WD                                          ,
  parameter SRAM_DATA_WD
) (
  input  [2:0                ] i_raddr_align                 , // 地址的低三位 因为对齐访存
  input  [SRAM_DATA_WD-1:0   ] i_data_sram_rdata             ,
  input                        i_mem_ren                     ,
  input  [2:0                ] i_mem_op                      ,
  output [WORD_WD-1:0        ] o_rdata
);

  reg  [WORD_WD-1:0          ] rdata                         ;
  wire [WORD_WD-1:0          ] memrdata                      ;

  always @(*) begin
    if (i_mem_ren) begin
      case (i_raddr_align)
        3'h1: rdata = {{ 8{1'b0}}, i_data_sram_rdata[63:8 ]};
        3'h2: rdata = {{16{1'b0}}, i_data_sram_rdata[63:16]};
        3'h3: rdata = {{24{1'b0}}, i_data_sram_rdata[63:24]};
        3'h4: rdata = {{32{1'b0}}, i_data_sram_rdata[63:32]};
        3'h5: rdata = {{40{1'b0}}, i_data_sram_rdata[63:40]};
        3'h6: rdata = {{48{1'b0}}, i_data_sram_rdata[63:48]};
        3'h7: rdata = {{56{1'b0}}, i_data_sram_rdata[63:56]};
        default: rdata = i_data_sram_rdata;
      endcase
    end
    else begin
      rdata = 64'b0;
    end
  end

  // for load inst
  MuxKey #(.NR_KEY(7), .KEY_LEN(3), .DATA_LEN(WORD_WD)) u_mux0 (
    .out(memrdata),
    .key(i_mem_op),
    .lut({
      3'b000, {{56{rdata[7]}}, rdata[7:0]}                   ,
      3'b001, {{56{1'b0}}, rdata[7:0]}                       ,
      3'b010, {{48{rdata[15]}}, rdata[15:0]}                 ,
      3'b011, {{48{1'b0}}, rdata[15:0]}                      ,
      3'b100, {{32{rdata[31]}}, rdata[31:0]}                 ,
      3'b101, {{32{1'b0}}, rdata[31:0]}                      ,
      3'b110, rdata
    })
  );

  assign o_rdata             = memrdata                      ;

endmodule
