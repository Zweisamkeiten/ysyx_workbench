// ysyx_22050710 branch unit

module ysyx_22050710_bru #(
  parameter WORD_WD                                          ,
  parameter PC_WD                                            ,
  parameter GPR_WD                                           ,
  parameter IMM_WD
) (
  input  [GPR_WD-1:0         ] i_rs1data                     ,
  input  [GPR_WD-1:0         ] i_rs2data                     ,
  input  [PC_WD-1:0          ] i_pc                          ,
  input  [IMM_WD-1:0         ] i_imm                         ,
  // br inst
  input                        i_bren                        ,
  input  [2:0                ] i_brfunc                      ,
  // ecall mret
  input                        i_ep_sel                      ,
  input  [PC_WD-1:0          ] i_epnpc                       ,
  // output br bus
  output                       o_br_sel                      ,
  output [PC_WD-1:0          ] o_br_target
);

  wire [WORD_WD-1:0          ] sub_result                    ;
  wire                         cout                          ;
  wire                         overflow                      ;
  wire                         zero                          ;
  wire                         less                          ;
  wire                         signed_Less, unsigned_Less    ;

  wire                         PCAsrc, PCBsrc                ;

  assign overflow            = ~(i_rs1data[WORD_WD-1] ^ i_rs2data[WORD_WD-1]) ^ ~(i_rs1data[WORD_WD-2] ^ i_rs2data[WORD_WD-2]);
  assign {cout, sub_result}  = {1'b0, i_rs1data} + {1'b0, (({WORD_WD{1'b1}}^(i_rs2data)) + 1)};

  assign signed_Less         = overflow == 0
                             ? (sub_result[WORD_WD-1] == 1 ? 1'b1 : 1'b0)
                             : (sub_result[WORD_WD-1] == 0 ? 1'b1 : 1'b0);
  assign unsigned_Less       = (1'b1 ^ cout) & ~(|i_rs2data == 1'b0); // CF = cin ^ cout

  assign zero                = ~(|sub_result)                ;
  MuxKey #(.NR_KEY(8), .KEY_LEN(3), .DATA_LEN(1)) u_mux0 (
    .out(less),
    .key(i_brfunc),
    .lut({
      3'b000, 1'b0,
      3'b001, 1'b0,
      3'b010, signed_Less,
      3'b011, signed_Less,
      3'b100, signed_Less,
      3'b101, signed_Less,
      3'b110, unsigned_Less,
      3'b111, unsigned_Less
    })
  );

  MuxKey #(.NR_KEY(8), .KEY_LEN(3), .DATA_LEN(1)) u_mux1 (
    .out(PCAsrc),
    .key(i_brfunc),
    .lut({
      3'b000, 1'b1,
      3'b001, 1'b1,
      3'b010, zero == 1 ? 1'b1 : 1'b0,
      3'b011, zero == 1 ? 1'b0 : 1'b1,
      3'b100, less == 1 ? 1'b1 : 1'b0,
      3'b101, less == 1 ? 1'b0 : 1'b1,
      3'b110, less == 1 ? 1'b1 : 1'b0,
      3'b111, less == 1 ? 1'b0 : 1'b1
    })
  );

  MuxKey #(.NR_KEY(8), .KEY_LEN(3), .DATA_LEN(1)) u_mux2 (
    .out(PCBsrc),
    .key(i_brfunc),
    .lut({
      3'b000, 1'b0,
      3'b001, 1'b1,
      3'b010, 1'b0,
      3'b011, 1'b0,
      3'b100, 1'b0,
      3'b101, 1'b0,
      3'b110, 1'b0,
      3'b111, 1'b0
    })
  );

  assign o_br_sel            = i_bren | i_ep_sel             ;
  assign o_br_target         = i_ep_sel
                             ? i_epnpc
                             : (PCBsrc ? i_rs1data : i_pc) + (PCAsrc ? i_imm : 4);

endmodule
