module alu (a, b, opt, out, of, cf, zf, sf);
  input [3:0] a; // 4 位带符号位补码
  input [3:0] b;
  input [2:0] opt; // 功能选择端
  output [3:0] out; // 结果
  output of, zf, sf; // 溢出, 零标志, 符号标志
  output reg cf; // 进位标志

  reg [3:0] temp;
  assign out = temp;

  wire iszero, overflow;

  assign iszero = |temp;
  MuxKey #(2, 1, 1) i0 (zf, iszero, {
    1'b0, 1'b0,
    1'b1, 1'b1
    });

  wire [3:0] t_no_Cin;
  assign t_no_Cin = {4{1'b1}}^b;
  assign overflow = (a[3] == t_no_Cin[3]) && (temp[3] != a[3]);

  assign sf = temp[3];

  always @ (a or b or opt) begin
    case (opt)
      3'b000: begin // 加法
                {cf, temp} = a + b;
              end
      3'b001: begin // 减法
                {cf, temp} = a + t_no_Cin + 1;
              end
      3'b010: begin // 取反
                {cf, temp} = {1'b0, ~a};
              end
      3'b011: begin // 与
                {cf, temp} = {1'b0, a & b};
              end
      3'b100: begin // 或
                {cf, temp} = {1'b0, a & b};
              end
      3'b101: begin // 异或
                {cf, temp} = {1'b0, a ^ b};
              end
      3'b110: begin // 比较大小
                {cf, temp} = a + t_no_Cin + 1;
                if (sf ^ overflow) temp = 4'b0001;
                else temp = 4'b0000;
              end
      3'b111: begin // 判断相等
                {cf, temp} = a + t_no_Cin + 1;
                if (zf == 0) temp = 4'b0001;
                else temp = 4'b0000;
              end
      default: {cf, temp} = 5'b00000;
    endcase
  end
endmodule
