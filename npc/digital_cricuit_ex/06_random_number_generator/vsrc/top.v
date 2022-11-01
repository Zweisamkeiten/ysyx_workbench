module shift_register_8bit (init, clk, rst, out, seg0, seg1);
  input [7:0] init;
  input clk;
  input rst;
  output [7:0] out;
  output [6:0] seg0, seg1;

  reg [7:0] temp;
  assign out = temp;
  decodeDig s0 (.x (temp[3:0]), .out (seg0));
  decodeDig s1 (.x (temp[7:4]), .out (seg1));

  reg [7:0] count;
  always @(posedge clk or posedge rst) begin
    if (rst) begin count <= 0; temp <= {8{1'b0}}; end
    if (count == 0) temp <= init;
    else temp <= {out[4]^out[3]^out[2]^out[0], out[7:1]};
    count <= (count >= 255 ? 8'b0 : count + 1);
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
