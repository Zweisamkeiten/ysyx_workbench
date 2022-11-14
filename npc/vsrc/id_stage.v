// ysyx_22050710 Instruction Decode Unit
module ysyx_22050710_idu (
  input [31:0] i_inst,
  output [63:0] o_imm,
  output [4:0] o_ra, o_rb, o_rd,
  output o_wen, o_ALUAsrc,
  output [1:0] o_ALUBsrc,
  output [3:0] o_ALUctr,
);

  wire [11:0] immI, [19:0] immU, [10:0] immS, [6:0] opcode;
  wire [2:0] funct3, [6:0] funct7,

  assign  opcode  = i_inst[6:0];
  assign  o_ra = i_inst[19:15];
  assign  o_rb = i_inst[24:20];
  assign  o_rd  = i_inst[11:7];
  assign  funct3  = i_inst[14:12];
  assign  funct7  = i_inst[31:25];

  // imm gen
  assign immI = {{52{i_inst[31]}}, i_inst[31:20]};
  assign immU = {{32{i_inst{31}}}, i_inst[31:12], 12'b0};
  assign immS = {{52{i_inst[31]}}, i_inst[31:25], i_inst[11:7]};
  assign immB = {{52{i_inst[31]}}, i_inst[7], i_inst[30:25], i_inst[11:8], 1'b0};
  assign immJ = {{44{i_inst[31]}}, i_inst[19:12], i_inst[20], i_inst[30:21], 1'b0};
  
  wire inst_addi   = |(opcode[6:0] ~^ 7'b0010011) & |(funct3[2:0] ~^ 3'b000);
  wire inst_ebreak = |(opcode[6:0] ~^ 7'b1110011) & |(funct3[2:0] ~^ 3'b000);

  wire inst_type_r = 1'b0;
  wire inst_type_i = |{inst_addi, inst_ebreak};
  wire inst_type_u = 1'b0;
  wire inst_type_s = 1'b0;
  wire inst_type_b = 1'b0;
  wire inst_type_j = 1'b0;

  wire [2:0] extop;
  wire [6:0] inst_type = {inst_type_r, inst_type_i, inst_type_u, inst_type_s, inst_type_b, inst_type_j};

  MuxKey #(.NR_KEY(6), .KEY_LEN(6), .DATA_LEN(3)) (
    .out(extop),
    .key(inst_type),
    .lut({
      6'b100000, 111,
      6'b010000, 000,
      6'b001000, 001,
      6'b000100, 010,
      6'b000010, 011,
      6'b000001, 100
    })
  );

  MuxKey #(.NR_KEY(5), .KEY_LEN(3), .DATA_LEN(64)) (
    .out(o_imm),
    .key(extop),
    .lut({
      3'b000, immI,
      3'b001, immU,
      3'b010, immS,
      3'b011, immB,
      3'b100, immJ
    })
  );

  assign o_wen = |{inst_type_r, inst_type_i, inst_type_u, inst_type_j};
  assign o_ALUAsrc = |{1'b0} == 1 ? 1'b1 : 1'b0; // '1' when inst about pc
  assign o_ALUBsrc = {o_ALUAsrc, |inst_type[5:0]};

  assign alu_plus = |{inst_addi};
  assign alu_ebreak = inst_ebreak;

  MuxKey #(.NR_KEY(2), .KEY_LEN(2), .DATA_LEN(4)) (
    .out(o_ALUctr),
    .key({alu_plus, alu_ebreak}),
    .lut({
      2'b10, 4'b0000,
      2'b01, 4'b1111
    })
  );
endmodule
