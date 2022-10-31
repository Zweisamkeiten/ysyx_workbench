module prior_encode83(x, en, y, ins);
  input [7:0] x;
  input en;
  output reg [2:0] y;
  output reg ins;
  
  integer i;
  always @(x or en) begin

    if (x != 8'b00000000) ins = 1;
    else ins = 0;

    if (en) begin
      y = 0;
      for ( i = 0; i <= 7; i = i + 1)
        if (x[i] == 1) y = i[2:0];
      end
    else y = 0;

  end
endmodule
