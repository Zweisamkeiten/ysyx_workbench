// ysyx_22050710 Load and Store Memory Unit

import "DPI-C" function void npc_pmem_read(input longint raddr, output longint rdata);
import "DPI-C" function void npc_pmem_write(input longint waddr, input longint wdata, input byte wmask);

module ysyx_22050710_lsu (
  input   i_clk, i_rst,
  input   [63:0] i_addr,
  input   [63:0] i_data,
  input   [2:0] i_MemOP,
  input   i_MemtoReg,
  input   i_WrEn, i_ReEn,
  input   i_sel_csr,
  output  [63:0] o_w_rf_data
);

  wire [63:0] rdata;
  wire [63:0] memrdata;
  assign o_GPRbusW = i_MemtoReg ? rdata : (i_sel_csr ? i_csrrdata : o_ALUresult);
  MuxKey #(.NR_KEY(7), .KEY_LEN(3), .DATA_LEN(64)) u_mux0 (
    .out(memrdata),
    .key(i_MemOP),
    .lut({
      3'b000, {{56{rdata[7]}}, rdata[7:0]},
      3'b001, {{56{1'b0}}, rdata[7:0]},
      3'b010, {{48{rdata[15]}}, rdata[15:0]},
      3'b011, {{48{1'b0}}, rdata[15:0]},
      3'b100, {{32{rdata[31]}}, rdata[31:0]},
      3'b101, {{32{1'b0}}, rdata[31:0]},
      3'b110, rdata
    })
  );

  reg [63:0] rdata;
  assign o_w_rf_data = memrdata;
  wire [63:0] raddr = i_addr;
  wire [63:0] waddr = i_addr;
  reg [7:0] wmask;

  always @(*) begin
    wmask = 8'b00000000;
    case (i_MemOP)
      3'b000, 3'b001: begin
        case (waddr[2:0])
          3'h0:    wmask = 8'b00000001;
          3'h1:    wmask = 8'b00000010;
          3'h2:    wmask = 8'b00000100;
          3'h3:    wmask = 8'b00001000;
          3'h4:    wmask = 8'b00010000;
          3'h5:    wmask = 8'b00100000;
          3'h6:    wmask = 8'b01000000;
          3'h7:    wmask = 8'b10000000;
          default: wmask = 8'b00000000;
        endcase
      end
      3'b010, 3'b011: begin
        case (waddr[2:0])
          3'h0:    wmask = 8'b00000011;
          3'h2:    wmask = 8'b00001100;
          3'h4:    wmask = 8'b00110000;
          3'h6:    wmask = 8'b11000000;
          default: wmask = 8'b00000000;
        endcase
      end
      3'b100, 3'b101: begin
        case (waddr[2:0])
          3'h0:    wmask = 8'b00001111;
          3'h4:    wmask = 8'b11110000;
          default: wmask = 8'b00000000;
        endcase
      end
      3'b110: begin
        wmask = 8'b11111111;
      end
      default: wmask = 8'b00000000;
    endcase
  end

  wire [63:0] wdata;
  MuxKey #(.NR_KEY(8), .KEY_LEN(3), .DATA_LEN(64)) u_mux2 (
    .out(wdata),
    .key(waddr[2:0]),
    .lut({
    3'h0, i_data,
    3'h1, {i_data[55:0], { 8{1'b0}}},
    3'h2, {i_data[47:0], {16{1'b0}}},
    3'h3, {i_data[39:0], {24{1'b0}}},
    3'h4, {i_data[31:0], {32{1'b0}}},
    3'h5, {i_data[23:0], {40{1'b0}}},
    3'h6, {i_data[15:0], {48{1'b0}}},
    3'h7, {i_data[ 7:0], {56{1'b0}}}
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
    else begin
      rdata = 64'b0;
    end
  end

  always @(posedge i_clk) begin
    if (i_WrEn & i_MemOP != 3'b111) npc_pmem_write(waddr, wdata, wmask);
  end

endmodule
