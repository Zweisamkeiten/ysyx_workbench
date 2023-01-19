// ysyx_22050710 Data Memory

import "DPI-C" function void npc_pmem_read(input longint raddr, output longint rdata);
import "DPI-C" function void npc_pmem_write(input longint waddr, input longint wdata, input byte wmask);

module ysyx_22050710_datamem (
  input   i_clk, i_rst,
  input   [63:0] i_addr,
  input   [63:0] i_data,
  input   [2:0] i_MemOP,
  input   i_WrEn, i_ReEn,
  output  [63:0] o_data
);

  reg [63:0] rdata;
  assign o_data = rdata;
  wire [63:0] wdata = i_data;
  wire [63:0] raddr = i_addr;
  wire [63:0] waddr = i_addr;
  wire [7:0] wmask;

  MuxKey #(.NR_KEY(7), .KEY_LEN(3), .DATA_LEN(8)) u_mux1 (
    .out(wmask),
    .key(i_MemOP),
    .lut({
      3'b000, 8'b00000001,
      3'b001, 8'b00000001,
      3'b010, 8'b00000011,
      3'b011, 8'b00000011,
      3'b100, 8'b00001111,
      3'b101, 8'b00001111,
      3'b110, 8'b11111111
    })
  );

  always @(*) begin
    if (!i_rst & i_ReEn & i_MemOP != 3'b111) begin
      npc_pmem_read(raddr, rdata);
      case (raddr[2:0])
        3'h1: rdata = {{ 8{1'b0}}, rdata[63:8 ]};
        3'h2: rdata = {{16{1'b0}}, rdata[63:16]};
        3'h3: rdata = {{24{1'b0}}, rdata[63:24]};
        3'h4: rdata = {{32{1'b0}}, rdata[63:32]};
        3'h5: rdata = {{40{1'b0}}, rdata[63:40]};
        3'h6: rdata = {{48{1'b0}}, rdata[63:48]};
        3'h7: rdata = {{56{1'b0}}, rdata[63:56]};
        default: rdata = rdata;
      endcase
    end
    else rdata = 64'b0;
  end

  always @(posedge i_clk) begin
    case (waddr[2:0])
      3'h1: wdata = {{ 8{1'b0}}, wdata[63:8 ]};
      3'h2: wdata = {{16{1'b0}}, wdata[63:16]};
      3'h3: wdata = {{24{1'b0}}, wdata[63:24]};
      3'h4: wdata = {{32{1'b0}}, wdata[63:32]};
      3'h5: wdata = {{40{1'b0}}, wdata[63:40]};
      3'h6: wdata = {{48{1'b0}}, wdata[63:48]};
      3'h7: wdata = {{56{1'b0}}, wdata[63:56]};
      default: wdata = wdata;
    endcase
    if (i_WrEn & i_MemOP != 3'b111) npc_pmem_write(waddr, wdata, wmask);
  end
  
endmodule
