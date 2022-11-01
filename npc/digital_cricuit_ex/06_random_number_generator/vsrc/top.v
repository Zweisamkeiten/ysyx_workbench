module shift_register_8bit (init, clk, out, seg0, seg1);
  input [7:0] init;
  input clk;
  output reg [7:0] out;
  output [6:0] seg0, seg1;

  decodeDig seg0 (.x (out[3:0]), .out (seg0));
  decodeDig seg1 (.x (out[7:4]), .out (seg1));

  reg [7:0] count;
  always @(posedge clk) begin
    if (count == 0) out <= 
  end
endmodule

module decodeDig(x, out);
  input [3:0] x;
  output reg [6:0] out;

  always @(x) begin
    case (x)
      4'b0000 : out = 7'b1000000; // 0
      4'b0001 : out = 7'b1111001; // 1
      4'b0010 : out = 7'b0100100; // 2
      4'b0011 : out = 7'b0110000; // 3
      4'b0100 : out = 7'b0011001; // 4
      4'b0101 : out = 7'b0010010; // 5
      4'b0110 : out = 7'b0000010; // 6
      4'b0111 : out = 7'b1111000; // 7
      4'b1000 : out = 7'b0000000; // 8
      4'b1001 : out = 7'b0010000; // 9
      4'b1010 : out = 7'b0001000; // a
      4'b1011 : out = 7'b0000011; // b
      4'b1100 : out = 7'b1000110; // c
      4'b1101 : out = 7'b0100001; // d
      4'b1110 : out = 7'b0000110; // e
      4'b1111 : out = 7'b0001110; // f
      default: out = 7'b0000001; // 0
    endcase
  end
endmodule
