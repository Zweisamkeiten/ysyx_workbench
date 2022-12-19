module alu (a, b, opt, out, of, cf, zf, sf);
  input [3:0] a; // 4 位带符号位补码
  input [3:0] b;
  input [2:0] opt; // 功能选择端
  output reg [3:0] out; // 结果
  output of, zf, sf; // 溢出, 零标志, 符号标志
  output reg cf; // 进位标志

  reg [3:0] tmp;
  assign out = tmp;
  assign sf = tmp[3];
  assign zf = |tmp ? 1'b0 : 1'b1;

  /* wire [3:0] t_no_Cin; */
  /* assign t_no_Cin = {4{1'b1}}^b + 1; */
  wire of_add, of_sub;
  assign of_add = (a[3] == b[3]) && (tmp[3] != a[3]);
  assign of_sub = (a[3] == {{4{1'b1}}^b + 1}[3]) && (tmp[3] != a[3]);
  MuxKey #(2, 3, 1) i0 (
    .out (of),
    .key (opt),
    .lut ({
        3'b000, of_add,
        3'b001, of_sub
    })
  );

  always @ (a or b or opt) begin
    cf = 0;
    case (opt)
      3'b000: begin // 加法
                {cf, tmp} = a + b;
              end
      3'b001: begin // 减法
                {cf, tmp} = a - b;
              end
      3'b010: begin // 取反
                {cf, tmp} = {1'b0, ~a};
              end
      3'b011: begin // 与
                {cf, tmp} = {1'b0, a & b};
              end
      3'b100: begin // 或
                {cf, tmp} = {1'b0, a | b};
              end
      3'b101: begin // 异或
                {cf, tmp} = {1'b0, a ^ b};
              end
      3'b110: begin // 比较大小
                if (a > b) tmp = 4'b0001;
                else tmp = 4'b0000;
              end
      3'b111: begin // 判断相等
                if (a == b) tmp = 4'b0001;
                else tmp = 4'b0000;
              end
      default: {cf, tmp} = 5'b00000;
    endcase
  end
endmodule
