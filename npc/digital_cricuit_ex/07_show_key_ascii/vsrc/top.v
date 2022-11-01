module top (
    input clk,
    input rst,
    input ps2_clk,
    input ps2_data,
    output [6:0] seg0,
    output [6:0] seg1,
    output [6:0] seg2,
    output [6:0] seg3,
    output [6:0] seg6,
    output [6:0] seg7

);

parameter [7:0] cspace = 32,
  ca = 97, cb = 98, cc = 99, cd = 100,
  ce = 101, cf = 102, cg = 103, ch = 104,
  ci = 105, cj = 106, ck = 107, cl = 108,
  cm = 109, cn = 110, co = 111, cp = 112,
  cq = 113, cr = 114, cs = 115, ct = 116,
  cu = 117, cv = 118, cw = 119, cx = 120,
  cy = 121, cz = 122,
  c0 = 48, c1 = 49, c2 = 50, c3 = 51, c4 = 52,
  c5 = 53, c6 = 54, c7 = 55, c8 = 56, c9 = 57;

parameter [7:0] sspase = 2'h29,
  sa = 2'h1c, sb = 2'h32, sc = 2'h21, sd = 2'h23,
  se = 2'h24, sf = 2'h2b, sg = 2'h34, sh = 2'h33,
  si = 2'h43, sj = 2'h3b, sk = 2'h42, sl = 2'h43,
  sm = 2'h3a, sn = 2'h31, so = 2'h44, sp = 2'h4d,
  sq = 2'h15, sr = 2'h2d, ss = 2'h1b, st = 2'h2c,
  su = 2'h3c, sv = 2'h21, sw = 2'h1d, sx = 2'h22,
  sy = 2'h35, sz = 2'h1a,
  s0 = 2'h0e, s1 = 2'h16, s2 = 2'h1e, s3 = 2'h26, s4 = 2'h25,
  s5 = 2'h2e, s6 = 2'h36, s7 = 2'h3d, s8 = 2'h3e, s9 = 2'h46;

wire [7:0] scancode, ascii, times;

ps2_keyboard my_keyboard(
    .clk(clk),
    .resetn(~rst),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .out (scancode),
    .times (times)
);

seg mu_seg(
    .clk(clk),
    .rst(rst),
    .scancode(scancode),
    .ascii(ascii),
    .times(times),
    .o_seg0(seg0),
    .o_seg1(seg1),
    .o_seg2(seg2),
    .o_seg3(seg3),
    .o_seg6(seg6),
    .o_seg7(seg7)
);

MuxKey #(37, 8, 8) scancode_to_ascii (.out (ascii), .key (scancode), .lux ({
  sa, ca,
  sb, cb,
  sc, cc,
  sd, cd,
  se, ce,
  sf, cf,
  sg, cg,
  sh, ch,
  si, ci,
  sj, cj,
  sk, ck,
  sl, cl,
  sm, cm,
  sn, cn,
  so, co,
  sp, cp,
  sq, cq,
  sr, cr,
  ss, cs,
  st, ct,
  su, cu,
  sv, cv,
  sw, cw,
  sx, cx,
  sy, cy,
  sz, cz,
  s0, c0,
  s1, c1,
  s2, c2,
  s3, c3,
  s4, c4,
  s5, c5,
  s6, c6,
  s7, c7,
  s8, c8,
  s9, c9,
  sspase, cspace
  }));

endmodule

