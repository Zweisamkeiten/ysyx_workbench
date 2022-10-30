module top (
  input a,
  input b,
  output f
);

  assign f = a ^ b;
  initial begin
    $dumpfile("build/logs/vlt_dump.vcd");
    $dumpvars();
  end
endmodule
