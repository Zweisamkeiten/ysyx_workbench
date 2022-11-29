// ysyx_22050710 Instruction Decode Unit
module ysyx_22050710_idu (
  input [31:0] i_inst,
  output [63:0] o_imm,
  output [4:0] o_ra, o_rb, o_rd,
  output o_RegWr, o_ALUAsrc,
  output [1:0] o_ALUBsrc,
  output [3:0] o_ALUctr,
  output o_PCAsrc, o_PCBsrc,
  output o_MemtoReg, o_MemWr,
  output [2:0] o_MemOP
);

  wire [6:0] opcode;
  wire [2:0] funct3; wire [6:0] funct7;

  assign  opcode  = i_inst[6:0];
  assign  o_ra = i_inst[19:15];
  assign  o_rb = i_inst[24:20];
  assign  o_rd  = i_inst[11:7];
  assign  funct3  = i_inst[14:12];
  assign  funct7  = i_inst[31:25];

  // imm gen
  wire [63:0] immI, immU, immS, immB, immJ;
  assign immI = {{52{i_inst[31]}}, i_inst[31:20]};
  assign immU = {{32{i_inst[31]}}, i_inst[31:12], 12'b0};
  assign immS = {{52{i_inst[31]}}, i_inst[31:25], i_inst[11:7]};
  assign immB = {{52{i_inst[31]}}, i_inst[7], i_inst[30:25], i_inst[11:8], 1'b0};
  assign immJ = {{44{i_inst[31]}}, i_inst[19:12], i_inst[20], i_inst[30:21], 1'b0};
  
  // RV32I and RV64I
  wire inst_lui    = (opcode[6:0] == 7'b0110111);
  wire inst_auipc  = (opcode[6:0] == 7'b0010111);
  wire inst_jal    = (opcode[6:0] == 7'b1101111);
  wire inst_jalr   = (opcode[6:0] == 7'b1100111) & (funct3[2:0] == 3'b000);
  wire inst_lw     = (opcode[6:0] == 7'b0000011) & (funct3[2:0] == 3'b010);
  wire inst_sw     = (opcode[6:0] == 7'b0100011) & (funct3[2:0] == 3'b010);
  wire inst_addi   = (opcode[6:0] == 7'b0010011) & (funct3[2:0] == 3'b000);
  wire inst_ebreak = (opcode[6:0] == 7'b1110011) & (funct3[2:0] == 3'b000);

  // RV64I
  wire inst_sd     = (opcode[6:0] == 7'b0100011) & (funct3[2:0] == 3'b011);
  wire inst_addiw  = (opcode[6:0] == 7'b0011011) & (funct3[2:0] == 3'b000);
  wire inst_addw   = (opcode[6:0] == 7'b0111011) & (funct3[2:0] == 3'b000) & (funct7[6:0] == 7'b0000000);

  wire inst_type_r = |{inst_addw};
  wire inst_type_i = |{inst_lw, inst_addi, inst_ebreak, inst_jalr};
  wire inst_type_u = |{inst_lui, inst_auipc};
  wire inst_type_s = |{inst_sw, inst_sd};
  wire inst_type_b = 1'b0;
  wire inst_type_j = |{inst_jal};

  wire [2:0] extop;
  wire [5:0] inst_type = {inst_type_r, inst_type_i, inst_type_u, inst_type_s, inst_type_b, inst_type_j};

  MuxKey #(.NR_KEY(6), .KEY_LEN(6), .DATA_LEN(3)) u_mux0 (
    .out(extop),
    .key(inst_type),
    .lut({
      6'b100000, 3'b111,
      6'b010000, 3'b000,
      6'b001000, 3'b001,
      6'b000100, 3'b010,
      6'b000010, 3'b011,
      6'b000001, 3'b100
    })
  );

  MuxKey #(.NR_KEY(5), .KEY_LEN(3), .DATA_LEN(64)) u_mux1 (
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

  assign o_RegWr = |{inst_type_r, inst_type_i, inst_type_u, inst_type_j};
  /* 宽度为1bit,选择ALU输入端A的来源 */
  /* 为0时选择rs1, */
  /* 为1时选择PC */
  assign o_ALUAsrc = |{inst_type_j, inst_auipc, inst_jalr} == 1 ? 1'b1 : 1'b0; // '1' when inst about pc
  /* 宽度为2bit,选择ALU输入端B的来源. */
  /* 为00时选择rs2. */
  /* 为01时选择imm 当是立即数移位指令时，只有低5位有效, */
  /* 为10时选择常数4 用于跳转时计算返回地址PC+4 */
  assign o_ALUBsrc = {|{inst_jal, inst_jalr}, |inst_type[4:1] & !inst_jalr};

  assign o_PCAsrc = |{inst_jal, inst_jalr};
  assign o_PCBsrc = inst_jalr;

  assign o_MemtoReg = |{inst_lw};
  assign o_MemWr = inst_type_s;

  wire signed_byte, signed_halfword, signed_word, signed_doubleword;
  wire unsigned_byte, unsigned_halfword, unsigned_word;
  assign signed_byte = |{1'b0};
  assign signed_halfword = |{1'b0};
  assign signed_word = |{inst_lw, inst_sw};
  assign signed_doubleword = |{inst_sd};
  assign unsigned_byte = |{1'b0};
  assign unsigned_halfword = |{1'b0};
  assign unsigned_word = |{1'b0};
 
  MuxKeyWithDefault #(.NR_KEY(7), .KEY_LEN(7), .DATA_LEN(3)) u_mux2 (
    .out(o_MemOP),
    .key({signed_byte, unsigned_byte, signed_halfword, unsigned_halfword, signed_word, unsigned_word, signed_doubleword}),
    .default_out(3'b111),
    .lut({
      7'b1000000, 3'b000,
      7'b0100000, 3'b001,
      7'b0010000, 3'b010,
      7'b0001000, 3'b011,
      7'b0000100, 3'b100,
      7'b0000010, 3'b101,
      7'b0000001, 3'b110
    })
  );


  wire alu_copyimm, alu_plus, alu_plus_and_signedext, alu_ebreak;
  assign alu_copyimm = |{inst_lui};
  assign alu_plus = |{inst_auipc, inst_jal, inst_jalr, inst_lw, inst_sw, inst_addi, inst_sd};
  assign alu_plus_and_signedext = |{inst_addw};
  assign alu_ebreak = inst_ebreak;

  MuxKeyWithDefault #(.NR_KEY(4), .KEY_LEN(4), .DATA_LEN(4)) u_mux3 (
    .out(o_ALUctr),
    .key({alu_copyimm, alu_plus, alu_plus_and_signedext, alu_ebreak}),
    .default_out(4'b1111),
    .lut({
      4'b1000, 4'b0011,
      4'b0100, 4'b0000,
      4'b0010, 4'b1001,
      4'b0001, 4'b1110
    })
  );
endmodule
