// ysyx_22050710 Load and Store Memory Unit

import "DPI-C" function void npc_pmem_read(input longint raddr, output longint rdata);
import "DPI-C" function void npc_pmem_write(input longint waddr, input longint wdata, input byte wmask);

module ysyx_22050710_lsu #(
  parameter WORD_WD
) (
  input                        i_clk                         ,
  input                        i_rst                         ,
  input  [WORD_WD-1:0        ] i_addr                        ,
  input  [WORD_WD-1:0        ] i_wdata                       ,
  input  [WORD_WD-1:0        ] i_alu_result                  ,
  input  [WORD_WD-1:0        ] i_csr_result                  ,
  input  [WORD_WD-1:0        ] i_csrrdata                    ,
  input                        i_mem_ren                     ,
  input                        i_mem_wen                     ,
  input  [2:0                ] i_mem_op                      ,
  input                        i_csr_inst_sel                , // write csrrdata to gpr
  output [WORD_WD-1:0        ] o_gpr_final_result            ,
  output [WORD_WD-1:0        ] o_csr_final_result
);

  wire [WORD_WD-1:0          ] rdata                         ;
  wire [WORD_WD-1:0          ] memrdata                      ;
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

  reg  [WORD_WD-1:0          ] rdata                         ;
  wire [WORD_WD-1:0          ] raddr = i_addr                ;
  wire [WORD_WD-1:0          ] waddr = i_addr                ;
  reg  [7:0                  ] wmask                         ;

  always @(*) begin
    wmask = 8'b00000000;
    case (i_mem_op)
      3'b000, 3'b001: begin
        case (waddr[2:0])
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
        case (waddr[2:0])
          3'h0:    wmask = 8'b00000011                       ;
          3'h2:    wmask = 8'b00001100                       ;
          3'h4:    wmask = 8'b00110000                       ;
          3'h6:    wmask = 8'b11000000                       ;
          default: wmask = 8'b00000000                       ;
        endcase
      end
      3'b100, 3'b101: begin
        case (waddr[2:0])
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

  wire [63:0] wdata;
  MuxKey #(.NR_KEY(8), .KEY_LEN(3), .DATA_LEN(WORD_WD)) u_mux1 (
    .out(wdata),
    .key(waddr[2:0]),
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

  always @(*) begin
    if (!i_rst & i_mem_ren & i_mem_op != 3'b111) begin
      npc_pmem_read(raddr, rdata);
      case (raddr[2:0])
        3'h1: rdata = {{ 8{1'b0}}, rdata[63:8 ]}             ;
        3'h2: rdata = {{16{1'b0}}, rdata[63:16]}             ;
        3'h3: rdata = {{24{1'b0}}, rdata[63:24]}             ;
        3'h4: rdata = {{32{1'b0}}, rdata[63:32]}             ;
        3'h5: rdata = {{40{1'b0}}, rdata[63:40]}             ;
        3'h6: rdata = {{48{1'b0}}, rdata[63:48]}             ;
        3'h7: rdata = {{56{1'b0}}, rdata[63:56]}             ;
        default: rdata = rdata;
      endcase
    end
    else begin
      rdata = 64'b0;
    end
  end

  always @(posedge i_clk) begin
    if (i_mem_wen & i_mem_op != 3'b111) npc_pmem_write(waddr, wdata, wmask);
  end

  assign o_gpr_final_result  = i_mem_ren
                             ? memrdata
                             : (i_csr_inst_sel ? i_csrrdata : i_alu_result);

  assign o_csr_final_result  = i_csr_result                  ;

endmodule
