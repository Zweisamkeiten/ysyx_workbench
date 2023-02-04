// ysyx_22050710 Write back unit
module ysyx_22050710_wbu #(GPRADDR_WIDTH = 5, DATA_WIDTH = 64) (
  input i_rf_wen,
  input [GPRADDR_WIDTH-1:0] i_rf_waddr,
  input [DATA_WIDTH-1:0] i_rf_wdata,
  output o_rf_wen,
  output [GPRADDR_WIDTH-1:0] o_rf_waddr,
  output [DATA_WIDTH-1:0] o_rf_wdata
);


  assign o_rf_wen = i_rf_wen;
  assign o_rf_waddr = i_rf_waddr;
  assign o_rf_wdata = i_rf_wdata;

endmodule
