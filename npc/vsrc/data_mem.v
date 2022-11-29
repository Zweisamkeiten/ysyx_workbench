// ysyx_22050710

import "DPI-C" function void npc_pmem_read(input longint raddr, output longint rdata);
import "DPI-C" function void npc_pmem_write(input longint waddr, input longint wdata, input byte wmask);

module ysyx_22050710_datamem (
  input i_clk, i_rst,
  input [63:0] i_addr,
  input [63:0] i_data,
  input [2:0] i_MemOP,
  input i_WrEn,
  output [63:0] o_data
);

  wire [63:0] rdata, wdata;
  wire [63:0] raddr, waddr;
  wire [63:0] data_temp;
  assign wdata = i_data;
  assign raddr = i_addr;
  assign waddr = i_addr;
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

  assign o_data = data_temp;
  MuxKey #(.NR_KEY(7), .KEY_LEN(3), .DATA_LEN(64)) u_mux2 (
    .out(data_temp),
    .key(i_MemOP),
    .lut({
      3'b000, {{56{rdata[7]}}, rdata[7:0]},
      3'b001, {{56{1'b0}}, rdata[7:0]},
      3'b010, {{48{rdata[15]}}, rdata[15:0]},
      3'b011, {{48{1'b0}}, rdata[15:0]},
      3'b100, {{32{rdata[31]}}, rdata[31:0]},
      3'b101, {{32{1'b0}}, rdata[31:0]},
      3'b110, rdata[63:0]
    })
  );

  always @(posedge i_clk) begin
    if (!i_rst) begin
      if (i_WrEn) begin
        if (i_MemOP != 3'b111) npc_pmem_write(waddr, wdata, wmask);
      end
      else begin
        if (i_MemOP != 3'b111) npc_pmem_read(raddr, rdata);
        $display(data_temp);
      end
    end
  end
  
endmodule
