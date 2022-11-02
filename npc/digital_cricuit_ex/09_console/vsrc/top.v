module top (
    input clk,
    input rst,
    input ps2_clk,
    input ps2_data,
    output VGA_CLK,
    output VGA_HSYNC,
    output VGA_VSYNC,
    output VGA_BLANK_N,
    output [7:0] VGA_R,
    output [7:0] VGA_G,
    output [7:0] VGA_B
);

parameter [7:0] cspace = 32, center = 13,
  ca = 97, cb = 98, cc = 99, cd = 100,
  ce = 101, cf = 102, cg = 103, ch = 104,
  ci = 105, cj = 106, ck = 107, cl = 108,
  cm = 109, cn = 110, co = 111, cp = 112,
  cq = 113, cr = 114, cs = 115, ct = 116,
  cu = 117, cv = 118, cw = 119, cx = 120,
  cy = 121, cz = 122,
  c0 = 48, c1 = 49, c2 = 50, c3 = 51, c4 = 52,
  c5 = 53, c6 = 54, c7 = 55, c8 = 56, c9 = 57;

parameter [7:0] sspase = 8'h29, senter = 8'h5a,
  sa = 8'h1c, sb = 8'h32, sc = 8'h21, sd = 8'h23,
  se = 8'h24, sf = 8'h2b, sg = 8'h34, sh = 8'h33,
  si = 8'h43, sj = 8'h3b, sk = 8'h42, sl = 8'h4b,
  sm = 8'h3a, sn = 8'h31, so = 8'h44, sp = 8'h4d,
  sq = 8'h15, sr = 8'h2d, ss = 8'h1b, st = 8'h2c,
  su = 8'h3c, sv = 8'h2a, sw = 8'h1d, sx = 8'h22,
  sy = 8'h35, sz = 8'h1a,
  s0 = 8'h0e, s1 = 8'h16, s2 = 8'h1e, s3 = 8'h26, s4 = 8'h25,
  s5 = 8'h2e, s6 = 8'h36, s7 = 8'h3d, s8 = 8'h3e, s9 = 8'h46;

wire [7:0] scancode, cur_ascii;
wire [9:0] chars; // 字符数量
wire [9:0] cur_x; // 0 <= x <= 69
wire [9:0] cur_y; // 0 <= y <= 30
reg [7:0] vga_mem [2099:0]; // 30 * 70 = 2100

assign cur_x = chars % 70;
assign cur_y = chars / 70;
assign vga_mem[{cur_x[6:0], cur_y[4:0]}] = cur_ascii != 8'hf0 ? cur_ascii : 8'h00;

ps2_keyboard mcur_y_keyboard(
    .clk(clk),
    .resetn(~rst),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .out (scancode),
    .chars (chars)
);

MuxKey #(37, 8, 8) scancode_to_ascii (.out (cur_ascii), .key (scancode), .lut ({
  sa, ca, sb, cb, sc, cc, sd, cd, se, ce,
  sf, cf, sg, cg, sh, ch, si, ci, sj, cj,
  sk, ck, sl, cl, sm, cm, sn, cn, so, co,
  sp, cp, sq, cq, sr, cr, ss, cs, st, ct,
  su, cu, sv, cv, sw, cw, sx, cx, sy, cy,
  sz, cz, s0, c0, s1, c1, s2, c2, s3, c3,
  s4, c4, s5, c5, s6, c6, s7, c7, s8, c8,
  s9, c9, sspase, cspace
  }));

assign VGA_CLK = clk;

wire [9:0] h_addr;
wire [9:0] v_addr;
wire [23:0] vga_data;

vga_ctrl my_vga_ctrl(
    .pclk(clk),
    .reset(rst),
    .vga_data(vga_data),
    .h_addr(h_addr),
    .v_addr(v_addr),
    .hsync(VGA_HSYNC),
    .vsync(VGA_VSYNC),
    .valid(VGA_BLANK_N),
    .vga_r(VGA_R),
    .vga_g(VGA_G),
    .vga_b(VGA_B)
);

wire [9:0] x; // 0 <= x <= 69
wire [9:0] y; // 0 <= y <= 30
wire [3:0] char_line; // 0 <= char_line <= 15
wire [9:0] char_row, char_column;

assign x = h_addr < 630 ? h_addr / 9 : 0;
assign y = v_addr / 16;
assign char_row = v_addr % 16;
assign char_column = h_addr < 630 ? h_addr % 9 : 0;

wire [7:0] ascii;
assign ascii = vga_mem[{x[6:0], y[4:0]}];

reg [11:0] fontmat_mem [4095:0]; // 12 * 4096 = 49152

initial begin
    $readmemh("resource/vga_font.txt", fontmat_mem);
end

wire [8:0] char_line9bits;
assign char_line9bits = fontmat_mem[16 * ascii + char_row[7:0]][8:0];
assign vga_data = char_line9bits[char_column[3:0]] ? {24{1'b1}} : {24{1'b0}};

endmodule
