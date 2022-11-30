// ysyx_22050710 Instruction Decode Unit

module ysyx_22050710_idu (
  input   [31:0] i_inst,
  output  [63:0] o_imm,
  output  [4:0] o_ra, o_rb, o_rd,
  output  [2:0] o_Branch,
  output  o_ALUAsrc, output [1:0] o_ALUBsrc, output [3:0] o_ALUctr,
  output  o_word_cut,
  output  o_RegWr, o_MemtoReg, o_MemWr, output [2:0] o_MemOP
);

  wire [6:0] opcode;
  wire [2:0] funct3; wire [6:0] funct7;

  assign  opcode  = i_inst[6:0];
  assign  o_ra    = i_inst[19:15];
  assign  o_rb    = i_inst[24:20];
  assign  o_rd    = i_inst[11:7];
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
  wire inst_beq    = (opcode[6:0] == 7'b1100011) & (funct3[2:0] == 3'b000);
  wire inst_bne    = (opcode[6:0] == 7'b1100011) & (funct3[2:0] == 3'b001);
  wire inst_bltu   = (opcode[6:0] == 7'b1100011) & (funct3[2:0] == 3'b100);
  wire inst_bgeu   = (opcode[6:0] == 7'b1100011) & (funct3[2:0] == 3'b100);
  wire inst_lw     = (opcode[6:0] == 7'b0000011) & (funct3[2:0] == 3'b010);
  wire inst_sw     = (opcode[6:0] == 7'b0100011) & (funct3[2:0] == 3'b010);
  wire inst_addi   = (opcode[6:0] == 7'b0010011) & (funct3[2:0] == 3'b000);
  wire inst_sltiu  = (opcode[6:0] == 7'b0010011) & (funct3[2:0] == 3'b011);
  wire inst_add    = (opcode[6:0] == 7'b0110011) & (funct3[2:0] == 3'b000) & (funct7[6:0] == 7'b0000000);
  wire inst_sub    = (opcode[6:0] == 7'b0110011) & (funct3[2:0] == 3'b000) & (funct7[6:0] == 7'b0100000);
  wire inst_ebreak = (opcode[6:0] == 7'b1110011) & (funct3[2:0] == 3'b000);

  // RV64I
  wire inst_ld     = (opcode[6:0] == 7'b0000011) & (funct3[2:0] == 3'b011);
  wire inst_sd     = (opcode[6:0] == 7'b0100011) & (funct3[2:0] == 3'b011);
  wire inst_slli   = (opcode[6:0] == 7'b0010011) & (funct3[2:0] == 3'b001) & (funct7[6:1] == 00000);
  wire inst_addiw  = (opcode[6:0] == 7'b0011011) & (funct3[2:0] == 3'b000);
  wire inst_addw   = (opcode[6:0] == 7'b0111011) & (funct3[2:0] == 3'b000) & (funct7[6:0] == 7'b0000000);

  // RV64M
  wire inst_remw   = (opcode[6:0] == 7'b0111011) & (funct3[2:0] == 3'b110) & (funct7[6:0] == 7'b0000001);

  wire inst_type_r = |{inst_add, inst_sub, inst_addw, inst_remw};
  wire inst_type_i = |{inst_jalr, inst_lw, inst_addi, inst_sltiu, inst_addiw, inst_ld, inst_slli, inst_ebreak};
  wire inst_type_u = |{inst_lui, inst_auipc};
  wire inst_type_s = |{inst_sw, inst_sd};
  wire inst_type_b = |{inst_beq, inst_bne, inst_bltu, inst_bgeu};
  wire inst_type_j = |{inst_jal};

  wire [2:0] extop;
  wire [5:0] inst_type = {inst_type_r, inst_type_i, inst_type_u, inst_type_s, inst_type_b, inst_type_j};

  // Load类指令
  wire inst_load  = |{inst_lw, inst_ld};
  // Store类指令
  wire inst_store = |{inst_sw, inst_sd};

  // 是否需要对操作数进行32位截断
  assign o_word_cut = |{inst_addiw, inst_addw, inst_remw};

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

  assign o_RegWr    = |{inst_type_r, inst_type_i, inst_type_u, inst_type_j};
  /* 宽度为1bit,选择ALU输入端A的来源 */
  /* 为0时选择rs1, */
  /* 为1时选择PC */
  assign o_ALUAsrc  = |{inst_type_j, inst_auipc, inst_jalr} == 1 ? 1'b1 : 1'b0; // '1' when inst about pc
  /* 宽度为2bit,选择ALU输入端B的来源. */
  /* 为00时选择rs2. */
  /* 为01时选择imm 当是立即数移位指令时，只有低5位有效, */
  /* 为10时选择常数4 用于跳转时计算返回地址PC+4 */
  assign o_ALUBsrc  = {|{inst_jal, inst_jalr}, |inst_type[4:2] & !inst_jalr};

  assign o_MemtoReg = |{inst_lw, inst_ld};
  assign o_MemWr    = inst_type_s;

  wire signed_byte        = |{1'b0};
  wire signed_halfword    = |{1'b0};
  wire signed_word        = |{inst_lw, inst_sw};
  wire signed_doubleword  = |{inst_ld, inst_sd};
  wire unsigned_byte      = |{1'b0};
  wire unsigned_halfword  = |{1'b0};
  wire unsigned_word      = |{1'b0};
 
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


  wire alu_copyimm      = |{inst_lui};
  wire alu_plus         = |{inst_auipc, inst_jal,   inst_jalr,  inst_addi, inst_add,
                            inst_load,  inst_store, inst_addiw, inst_addw
                            };
  wire alu_sub          = |{inst_type_b, inst_sub};
  wire alu_sltu         = |{inst_sltiu};
  wire alu_sll          = |{inst_slli};
  wire alu_singed_rem   = |{inst_remw};
  wire alu_ebreak       = inst_ebreak;

  MuxKeyWithDefault #(.NR_KEY(7), .KEY_LEN(7), .DATA_LEN(4)) u_mux3 (
    .out(o_ALUctr),
    .key({alu_copyimm, alu_plus, alu_sub, alu_sltu, alu_sll, alu_singed_rem, alu_ebreak}),
    .default_out(4'b1111),
    .lut({
      7'b1000000, 4'b0011,
      7'b0100000, 4'b0000,
      7'b0010000, 4'b1000,
      7'b0001000, 4'b1010,
      7'b0000100, 4'b1100,
      7'b0000010, 4'b1101,
      7'b0000001, 4'b1110
    })
  );

  MuxKeyWithDefault #(.NR_KEY(6), .KEY_LEN(6), .DATA_LEN(3)) u_mux4 (
    .out(o_Branch),
    .key({inst_jal, inst_jalr, inst_beq, inst_bne, inst_bltu, inst_bgeu}),
    .default_out(3'b000),
    .lut({
      6'b100000, 3'b001,
      6'b010000, 3'b010,
      6'b001000, 3'b100,
      6'b000100, 3'b101,
      6'b000010, 3'b110,
      6'b000001, 3'b111
    })
  );

endmodule
