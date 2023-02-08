// ysyx_22050710 Lsu Store unit

module ysyx_22050710_lsu_store #(
  parameter GPR_WD                                           ,
  parameter SRAM_ADDR_WD                                     ,
  parameter SRAM_WMASK_WD                                    ,
  parameter SRAM_DATA_WD
) (
  input  [2:0                ] i_mem_op                      ,
  input  [2:0                ] i_waddr                       ,
  input  [GPR_WD-1:0         ] i_wdata                       , // store rs2data
  output [SRAM_WMASK_WD-1:0  ] o_wmask                       ,
  output [SRAM_DATA_WD-1:0   ] o_wdata
);

  reg  [7:0                  ] wmask                         ;

  always @(*) begin
    wmask = 8'b00000000;
    case (i_mem_op)
      3'b000, 3'b001: begin
        case (i_waddr[2:0])
          3'h0:    wmask = 8'b00000001                       ;
          3'h1:    wmask = 8'b00000010                       ;
          3'h2:    wmask = 8'b00000100                       ;
          3'h3:    wmask = 8'b00001000                       ;
          3'h4:    wmask = 8'b00010000                       ;
          3'h5:    wmask = 8'b00100000                       ;
          3'h6:    wmask = 8'b01000000                       ;
          3'h7:    wmask = 8'b10000000                       ;
          default: wmask = 8'b00000000                       ;
        endcase
      end
      3'b010, 3'b011: begin
        case (i_waddr[2:0])
          3'h0:    wmask = 8'b00000011                       ;
          3'h2:    wmask = 8'b00001100                       ;
          3'h4:    wmask = 8'b00110000                       ;
          3'h6:    wmask = 8'b11000000                       ;
          default: wmask = 8'b00000000                       ;
        endcase
      end
      3'b100, 3'b101: begin
        case (i_waddr[2:0])
          3'h0:    wmask = 8'b00001111                       ;
          3'h4:    wmask = 8'b11110000                       ;
          default: wmask = 8'b00000000                       ;
        endcase
      end
      3'b110: begin
        wmask = 8'b11111111                                  ;
      end
      default: wmask = 8'b00000000                           ;
    endcase
  end

  wire [SRAM_DATA_WD-1:0     ] wdata                         ;

  MuxKey #(.NR_KEY(8), .KEY_LEN(3), .DATA_LEN(WORD_WD)) u_mux1 (
    .out(wdata),
    .key(i_waddr[2:0]),
    .lut({
    3'h0, i_wdata                                            ,
    3'h1, {i_wdata[55:0], { 8{1'b0}}}                        ,
    3'h2, {i_wdata[47:0], {16{1'b0}}}                        ,
    3'h3, {i_wdata[39:0], {24{1'b0}}}                        ,
    3'h4, {i_wdata[31:0], {32{1'b0}}}                        ,
    3'h5, {i_wdata[23:0], {40{1'b0}}}                        ,
    3'h6, {i_wdata[15:0], {48{1'b0}}}                        ,
    3'h7, {i_wdata[ 7:0], {56{1'b0}}}
    })
  );

  assign o_wmask             = wmask                         ;
  assign o_wdata             = wdata                         ;

endmodule
