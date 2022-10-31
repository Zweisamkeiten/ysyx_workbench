module alu (a, b, opt, out, of, cf, zf, sf);
  input [3:0] a; // 4 位带符号位补码
  input [3:0] b;
  input [2:0] opt; // 功能选择端
  output reg [3:0] out; // 结果
  output reg of, cf, zf, sf; // 溢出, 进位, 零标志, 符号标志

  reg iszero, overflow;

  MuxKey #(2, 1, 1) i0 (zf, iszero, {
    1'b0, 1'b0,
    1'b1, 1'b1
    });

  reg [3:0] t_no_Cin = {4{1'b1}}^b;

  always @ (a or b or opt, cf) begin
    case (opt)
      3'b000: begin // 加法
                {cf, out} = a + b;
              end
      3'b001: begin // 减法
                {cf, out} = a + t_no_Cin + 1;
              end
      3'b010: begin // 取反
                {cf, out} = {1'b0, ~a};
              end
      3'b011: begin // 与
                {cf, out} = {1'b0, a & b};
              end
      3'b100: begin // 或
                {cf, out} = {1'b0, a & b};
              end
      3'b101: begin // 异或
                {cf, out} = {1'b0, a ^ b};
              end
      3'b110: begin // 比较大小
                if (a < b) out = 4'b0001;
                else out = 4'b0000;
              end
      3'b111: begin // 判断相等
                if (a == b) out = 4'b0001;
                else out = 4'b0000;
              end
      default: {cf, out} = 5'b00000;
    endcase
    overflow = (a[3] == t_no_Cin[3]) && (out[3] != a[3]);
    sf = out[3];
  end
endmodule
