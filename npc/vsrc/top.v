module top (
  input a,
  input b,
  output f
);

  assign f = a ^ b;
  initial begin
    $dumpfile("logs/vlt_dump.vcd");
    $dumpvars();
  end
endmodule
