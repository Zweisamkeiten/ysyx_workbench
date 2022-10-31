module prior_encode83(x, en, y, ins, dig);
  input [7:0] x;
  input en;
  output reg [2:0] y;
  output reg ins;
  output reg [6:0] dig;
  
  integer i;
  always @(x or en) begin

    if (x != 8'b00000000) ins = 1;
    else ins = 0;

    if (en) begin
      y = 0;
      for ( i = 0; i <= 7; i = i + 1)
      begin
        if (x[i] == 1) begin
          y = i[2:0];
          decodeDig seg0(y, dig);
        end
      end
    end
    else y = 0;

  end
endmodule

module decodeDig(x, out);
  input [2:0] x;
  output [6:0] out;

  always @(x) begin
    case (x)
      3'b000 : out = 7'b0000001; // 0
      3'b001 : out = 7'b1111001; // 1
      3'b010 : out = 7'b1100100; // 2
      3'b011 : out = 7'b0110000; // 3
      3'b100 : out = 7'b0011001; // 4
      3'b101 : out = 7'b0010010; // 5
      3'b110 : out = 7'b0000010; // 6
      3'b111 : out = 7'b1111000; // 7
    endcase
  end
endmodule
