// ysyx_22050710 TOP

module ysyx_22050710_top (
  input i_clk,
  input i_rst
);

  ysyx_22050710_core u_core (
    .i_clk(i_clk),
    .i_rst(i_rst)
  );

endmodule
