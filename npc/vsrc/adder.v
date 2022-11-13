module ysyx_22050710_adder #(WIDTH = 1) (
  input [WIDTH-1:0] i_x,
  input [WIDTH-1:0] i_y,
  output [WIDTH-1:0] o_result
);
  assign o_result = i_x + i_y;
endmodule
