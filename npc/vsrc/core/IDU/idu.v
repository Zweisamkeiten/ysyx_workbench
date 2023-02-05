// ysyx_22050710 Instruction Decode Unit

module ysyx_22050710_idu (
  input   i_clk,
  input   [63:0] i_pc,
  input   [31:0] i_inst,
  input   [63:0] i_GPRbusW,
  input   [63:0] i_CSRbusW,
  input   i_ws_rf_wen,
  input   [4:0] i_ws_rf_waddr,
  output  [4:0] o_rd,
  output  [63:0] o_rs1data, o_rs2data,
  output  [63:0] o_imm,
  output  o_bren,
  output  [2:0] o_brfunc,
  output  o_ALUAsrc, output [1:0] o_ALUBsrc, output [4:0] o_ALUctr,
  output  o_word_cut,
  output  o_RegWr, o_MemtoReg, o_MemWr, o_MemRe, output [2:0] o_MemOP,
  output  [3:0] o_EXctr,
  output  o_is_invalid_inst,
  output  o_sel_csr, o_sel_zimm, /* o_CsrWr, */
  output  [63:0] o_zimm,
  output  [63:0] o_csrrdata,
  output  [63:0] o_sysctr_pc,
  output  o_sys_change_pc
);

  assign o_rd = rd;
  wire [6:0] opcode  = i_inst[6:0];
  wire [4:0] rs1     = i_inst[19:15];
  wire [4:0] rs2     = i_inst[24:20];
  wire [4:0] rd      = i_inst[11:7];
  wire [2:0] funct3  = i_inst[14:12];
  wire [6:0] funct7  = i_inst[31:25];

  // imm gen
  wire [63:0] immI, immU, immS, immB, immJ;
  assign immI = {{52{i_inst[31]}}, i_inst[31:20]};
  assign immU = {{32{i_inst[31]}}, i_inst[31:12], 12'b0};
  assign immS = {{52{i_inst[31]}}, i_inst[31:25], i_inst[11:7]};
  assign immB = {{52{i_inst[31]}}, i_inst[7], i_inst[30:25], i_inst[11:8], 1'b0};
  assign immJ = {{44{i_inst[31]}}, i_inst[19:12], i_inst[20], i_inst[30:21], 1'b0};
  assign o_zimm = {{59{1'b0}}, i_inst[19:15]};
  
  // RV32I and RV64I
  wire inst_lui    = (opcode[6:0] == 7'b0110111);
  wire inst_auipc  = (opcode[6:0] == 7'b0010111);
  wire inst_jal    = (opcode[6:0] == 7'b1101111);
  wire inst_jalr   = (opcode[6:0] == 7'b1100111) & (funct3[2:0] == 3'b000);
  wire inst_beq    = (opcode[6:0] == 7'b1100011) & (funct3[2:0] == 3'b000);
  wire inst_bne    = (opcode[6:0] == 7'b1100011) & (funct3[2:0] == 3'b001);
  wire inst_blt    = (opcode[6:0] == 7'b1100011) & (funct3[2:0] == 3'b100);
  wire inst_bge    = (opcode[6:0] == 7'b1100011) & (funct3[2:0] == 3'b101);
  wire inst_bltu   = (opcode[6:0] == 7'b1100011) & (funct3[2:0] == 3'b110);
  wire inst_bgeu   = (opcode[6:0] == 7'b1100011) & (funct3[2:0] == 3'b111);
  wire inst_lb     = (opcode[6:0] == 7'b0000011) & (funct3[2:0] == 3'b000);
  wire inst_lh     = (opcode[6:0] == 7'b0000011) & (funct3[2:0] == 3'b001);
  wire inst_lw     = (opcode[6:0] == 7'b0000011) & (funct3[2:0] == 3'b010);
  wire inst_lbu    = (opcode[6:0] == 7'b0000011) & (funct3[2:0] == 3'b100);
  wire inst_lhu    = (opcode[6:0] == 7'b0000011) & (funct3[2:0] == 3'b101);
  wire inst_sb     = (opcode[6:0] == 7'b0100011) & (funct3[2:0] == 3'b000);
  wire inst_sh     = (opcode[6:0] == 7'b0100011) & (funct3[2:0] == 3'b001);
  wire inst_sw     = (opcode[6:0] == 7'b0100011) & (funct3[2:0] == 3'b010);
  wire inst_addi   = (opcode[6:0] == 7'b0010011) & (funct3[2:0] == 3'b000);
  wire inst_slti   = (opcode[6:0] == 7'b0010011) & (funct3[2:0] == 3'b010);
  wire inst_sltiu  = (opcode[6:0] == 7'b0010011) & (funct3[2:0] == 3'b011);
  wire inst_xori   = (opcode[6:0] == 7'b0010011) & (funct3[2:0] == 3'b100);
  wire inst_ori    = (opcode[6:0] == 7'b0010011) & (funct3[2:0] == 3'b110);
  wire inst_andi   = (opcode[6:0] == 7'b0010011) & (funct3[2:0] == 3'b111);
  wire inst_add    = (opcode[6:0] == 7'b0110011) & (funct3[2:0] == 3'b000) & (funct7[6:0] == 7'b0000000);
  wire inst_sub    = (opcode[6:0] == 7'b0110011) & (funct3[2:0] == 3'b000) & (funct7[6:0] == 7'b0100000);
  wire inst_sll    = (opcode[6:0] == 7'b0110011) & (funct3[2:0] == 3'b001) & (funct7[6:0] == 7'b0000000);
  wire inst_slt    = (opcode[6:0] == 7'b0110011) & (funct3[2:0] == 3'b010) & (funct7[6:0] == 7'b0000000);
  wire inst_sltu   = (opcode[6:0] == 7'b0110011) & (funct3[2:0] == 3'b011) & (funct7[6:0] == 7'b0000000);
  wire inst_xor    = (opcode[6:0] == 7'b0110011) & (funct3[2:0] == 3'b100) & (funct7[6:0] == 7'b0000000);
  wire inst_srl    = (opcode[6:0] == 7'b0110011) & (funct3[2:0] == 3'b101) & (funct7[6:0] == 7'b0000000);
  wire inst_or     = (opcode[6:0] == 7'b0110011) & (funct3[2:0] == 3'b110) & (funct7[6:0] == 7'b0000000);
  wire inst_and    = (opcode[6:0] == 7'b0110011) & (funct3[2:0] == 3'b111) & (funct7[6:0] == 7'b0000000);
  wire inst_ebreak = (opcode[6:0] == 7'b1110011) & (funct3[2:0] == 3'b000) & (i_inst[31:20] == 12'b000000000001);
  wire inst_ecall  = (opcode[6:0] == 7'b1110011) & (funct3[2:0] == 3'b000) & (i_inst[31:20] == 12'b000000000000);

  // RV64I
  wire inst_lwu    = (opcode[6:0] == 7'b0000011) & (funct3[2:0] == 3'b110);
  wire inst_ld     = (opcode[6:0] == 7'b0000011) & (funct3[2:0] == 3'b011);
  wire inst_sd     = (opcode[6:0] == 7'b0100011) & (funct3[2:0] == 3'b011);
  wire inst_slli   = (opcode[6:0] == 7'b0010011) & (funct3[2:0] == 3'b001) & (funct7[6:1] == 6'b000000);
  wire inst_srli   = (opcode[6:0] == 7'b0010011) & (funct3[2:0] == 3'b101) & (funct7[6:1] == 6'b000000);
  wire inst_srai   = (opcode[6:0] == 7'b0010011) & (funct3[2:0] == 3'b101) & (funct7[6:1] == 6'b010000);
  wire inst_addiw  = (opcode[6:0] == 7'b0011011) & (funct3[2:0] == 3'b000);
  wire inst_slliw  = (opcode[6:0] == 7'b0011011) & (funct3[2:0] == 3'b001) & (funct7[6:0] == 7'b0000000);
  wire inst_srliw  = (opcode[6:0] == 7'b0011011) & (funct3[2:0] == 3'b101) & (funct7[6:0] == 7'b0000000);
  wire inst_sraiw  = (opcode[6:0] == 7'b0011011) & (funct3[2:0] == 3'b101) & (funct7[6:0] == 7'b0100000);
  wire inst_addw   = (opcode[6:0] == 7'b0111011) & (funct3[2:0] == 3'b000) & (funct7[6:0] == 7'b0000000);
  wire inst_subw   = (opcode[6:0] == 7'b0111011) & (funct3[2:0] == 3'b000) & (funct7[6:0] == 7'b0100000);
  wire inst_sllw   = (opcode[6:0] == 7'b0111011) & (funct3[2:0] == 3'b001) & (funct7[6:0] == 7'b0000000);
  wire inst_srlw   = (opcode[6:0] == 7'b0111011) & (funct3[2:0] == 3'b101) & (funct7[6:0] == 7'b0000000);
  wire inst_sraw   = (opcode[6:0] == 7'b0111011) & (funct3[2:0] == 3'b101) & (funct7[6:0] == 7'b0100000);

  // RV32/RV64 Zicsr
  wire inst_csrrw  = (opcode[6:0] == 7'b1110011) & (funct3[2:0] == 3'b001);
  wire inst_csrrs  = (opcode[6:0] == 7'b1110011) & (funct3[2:0] == 3'b010);
  wire inst_csrrwi = (opcode[6:0] == 7'b1110011) & (funct3[2:0] == 3'b101);

  // RV32M
  wire inst_mul    = (opcode[6:0] == 7'b0110011) & (funct3[2:0] == 3'b000) & (funct7[6:0] == 7'b0000001);
  wire inst_mulh   = (opcode[6:0] == 7'b0110011) & (funct3[2:0] == 3'b001) & (funct7[6:0] == 7'b0000001);
  wire inst_mulhsu = (opcode[6:0] == 7'b0110011) & (funct3[2:0] == 3'b010) & (funct7[6:0] == 7'b0000001);
  wire inst_mulhu  = (opcode[6:0] == 7'b0110011) & (funct3[2:0] == 3'b011) & (funct7[6:0] == 7'b0000001);
  wire inst_div    = (opcode[6:0] == 7'b0110011) & (funct3[2:0] == 3'b100) & (funct7[6:0] == 7'b0000001);
  wire inst_divu   = (opcode[6:0] == 7'b0110011) & (funct3[2:0] == 3'b101) & (funct7[6:0] == 7'b0000001);
  wire inst_rem    = (opcode[6:0] == 7'b0110011) & (funct3[2:0] == 3'b110) & (funct7[6:0] == 7'b0000001);
  wire inst_remu   = (opcode[6:0] == 7'b0110011) & (funct3[2:0] == 3'b111) & (funct7[6:0] == 7'b0000001);

  // RV64M
  wire inst_mulw   = (opcode[6:0] == 7'b0111011) & (funct3[2:0] == 3'b000) & (funct7[6:0] == 7'b0000001);
  wire inst_divw   = (opcode[6:0] == 7'b0111011) & (funct3[2:0] == 3'b100) & (funct7[6:0] == 7'b0000001);
  wire inst_divuw  = (opcode[6:0] == 7'b0111011) & (funct3[2:0] == 3'b101) & (funct7[6:0] == 7'b0000001);
  wire inst_remw   = (opcode[6:0] == 7'b0111011) & (funct3[2:0] == 3'b110) & (funct7[6:0] == 7'b0000001);
  wire inst_remuw  = (opcode[6:0] == 7'b0111011) & (funct3[2:0] == 3'b111) & (funct7[6:0] == 7'b0000001);

  // mret
  wire inst_mret   = i_inst == 32'b00110000001000000000000001110011;

  wire inst_type_r = |{ // RV32I
                       inst_add,    inst_sub,   inst_sll,   inst_slt,   inst_sltu,
                       inst_xor,    inst_srl,   inst_or,    inst_and,
                       // RV64I
                       inst_addw,   inst_subw,  inst_sllw,  inst_srlw,  inst_sraw,
                       // RV32M
                       inst_mul,    inst_mulh,  inst_mulhsu,inst_mulhu, inst_div,
                       inst_divu,   inst_rem,   inst_remu,
                       // RV64M
                       inst_mulw,   inst_divw,  inst_divuw, inst_remw,  inst_remuw,
                       // machine
                       inst_mret
                       };
  wire inst_type_i = |{ // RV32I
                       inst_jalr,   inst_lb,    inst_lh,    inst_lw,    inst_lbu,
                       inst_lhu,    inst_addi,  inst_slti,  inst_sltiu, inst_xori,
                       inst_ori,    inst_andi,  inst_slli,  inst_srli,  inst_srai,
                       inst_ecall,  inst_ebreak,
                       // RV64I
                       inst_lwu,    inst_ld,    inst_addiw, inst_slliw, inst_srliw,
                       inst_sraiw,
                       // RV32/RV64 Zicsr
                       inst_csrrw,  inst_csrrs
                       };
  wire inst_type_u = |{inst_lui,    inst_auipc};
  wire inst_type_s = |{inst_sb,     inst_sh,    inst_sw,    inst_sd};
  wire inst_type_b = |{inst_beq, inst_bne, inst_blt, inst_bge, inst_bltu, inst_bgeu};
  wire inst_type_j = |{inst_jal};

  wire [2:0] extop;
  wire [5:0] inst_type = {inst_type_r, inst_type_i, inst_type_u, inst_type_s, inst_type_b, inst_type_j};

  // Load类指令
  wire inst_load  = |{inst_lb, inst_lh, inst_lhu, inst_lw, inst_lbu, inst_lwu, inst_ld};
  // Store类指令
  wire inst_store = |{inst_sb, inst_sh, inst_sw, inst_sd};

  // 是否需要对操作数进行32位截断
  assign o_word_cut = |{inst_addiw, inst_slliw, inst_srliw, inst_sraiw, inst_addw, inst_subw,
                        inst_sllw,  inst_srlw,  inst_sraw,  inst_mulw,  inst_divw, inst_divuw,
                        inst_remw,  inst_remuw
                        };

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

  assign o_RegWr    = |{inst_type_r, inst_type_i, inst_type_u, inst_type_j} & !inst_csrrwi;
  /* 宽度为1bit,选择ALU输入端A的来源 */
  /* 为0时选择rs1, */
  /* 为1时选择PC */
  assign o_ALUAsrc  = |{inst_type_j, inst_auipc, inst_jalr} == 1 ? 1'b1 : 1'b0; // '1' when inst about pc
  /* 宽度为2bit,选择ALU输入端B的来源. */
  /* 为00时选择rs2. */
  /* 为01时选择imm 当是立即数移位指令时，只有低5位有效, */
  /* 为10时选择常数4 用于跳转时计算返回地址PC+4 */
  assign o_ALUBsrc  = {|{inst_jal, inst_jalr}, |inst_type[4:2] & !inst_jalr};

  assign o_MemtoReg = |{inst_load};
  assign o_MemWr    = inst_type_s;
  assign o_MemRe    = inst_load;

  // 写时可以不用注意符号拓展, 都放在带符号中''
  wire signed_byte        = |{inst_lb, inst_sb};
  wire signed_halfword    = |{inst_sh, inst_lh};
  wire signed_word        = |{inst_lw, inst_sw};
  wire signed_doubleword  = |{inst_ld, inst_sd};
  wire unsigned_byte      = |{inst_lbu};
  wire unsigned_halfword  = |{inst_lhu};
  wire unsigned_word      = |{inst_lwu};
 
  MuxKeyWithDefault #(.NR_KEY(7), .KEY_LEN(7), .DATA_LEN(3)) u_mux2 (
    .out(o_MemOP),
    .key({signed_byte, unsigned_byte, signed_halfword, unsigned_halfword, signed_word, unsigned_word, signed_doubleword}),
    .default_out(3'b111),
    .lut({
      7'b1000000, 3'b000, // signed_byte
      7'b0100000, 3'b001, // unsigned_byte
      7'b0010000, 3'b010, // signed_halfword
      7'b0001000, 3'b011, // unsigned_halfword
      7'b0000100, 3'b100, // signed_word
      7'b0000010, 3'b101, // unsigned_word
      7'b0000001, 3'b110  // signed_doubleword
    })
  );

  wire alu_copyimm      = |{inst_lui};
  wire alu_plus         = |{inst_auipc, inst_addi,  inst_add,   inst_jal,  inst_jalr,
                            inst_load,  inst_store, inst_addiw, inst_addw
                            };
  wire alu_sub          = |{inst_sub,   inst_subw};
  wire alu_signed_less  = |{inst_slt,   inst_slti}; // slt rs1, rs2
  wire alu_unsigned_less= |{inst_sltiu, inst_sltu}; // sltu rs1, rs2
  wire alu_xor          = |{inst_xori,  inst_xor};
  wire alu_and          = |{inst_andi,  inst_and};
  wire alu_or           = |{inst_ori,   inst_or};
  wire alu_sll          = |{inst_sll,   inst_slli,  inst_slliw, inst_sllw};
  wire alu_srl          = |{inst_srl,   inst_srli,  inst_srliw, inst_srlw};
  wire alu_sra          = |{inst_srai,  inst_sraiw, inst_sraw};
  wire alu_signed_mul   = |{inst_mul,   inst_mulw};
  wire alu_signed_mulh  = |{inst_mulh};
  wire alu_su_mulh      = |{inst_mulhsu};
  wire alu_unsigned_mulh= |{inst_mulhu};
  wire alu_signed_div   = |{inst_div,   inst_divw};
  wire alu_unsigned_div = |{inst_divu,  inst_divuw};
  wire alu_signed_rem   = |{inst_rem,   inst_remw};
  wire alu_unsigned_rem = |{inst_remu,  inst_remuw};

  MuxKeyWithDefault #(.NR_KEY(19), .KEY_LEN(19), .DATA_LEN(5)) u_mux3 (
    .out(o_ALUctr),
    .key({alu_copyimm,    alu_plus,       alu_sub,     alu_signed_less,   alu_unsigned_less,
          alu_xor,        alu_and,        alu_or,      alu_sll,           alu_srl,           alu_sra,
          alu_signed_mul, alu_signed_mulh,alu_su_mulh, alu_unsigned_mulh, alu_signed_div,    alu_unsigned_div,
          alu_signed_rem, alu_unsigned_rem
          }),
    .default_out(5'b11111), // invalid
    .lut({
      19'b1000000000000000000, 5'b01111,  // copy imm
      19'b0100000000000000000, 5'b00000,  // add a + b
      19'b0010000000000000000, 5'b00001,  // sub a - b
      19'b0001000000000000000, 5'b00010,  // slt  a <s b
      19'b0000100000000000000, 5'b00011,  // sltu a <u b
      19'b0000010000000000000, 5'b00100,  // xor a ^ b
      19'b0000001000000000000, 5'b00101,  // and a & b
      19'b0000000100000000000, 5'b00110,  // or a | b
      19'b0000000010000000000, 5'b00111,  // sll <<
      19'b0000000001000000000, 5'b01000,  // srl >>
      19'b0000000000100000000, 5'b01001,  // sra >>>
      19'b0000000000010000000, 5'b01010,  // signed mul *
      19'b0000000000001000000, 5'b11001,  // signed mulh *
      19'b0000000000000100000, 5'b11010,  // su mulh *
      19'b0000000000000010000, 5'b11011,  // unsigned mulh *
      19'b0000000000000001000, 5'b01011,  // signed   div /
      19'b0000000000000000100, 5'b01100,  // unsigned div /
      19'b0000000000000000010, 5'b01101,  // signed   rem %
      19'b0000000000000000001, 5'b01110   // unsigned rem %
    })
  );

  assign o_bren = |{inst_type_b, inst_jal, inst_jalr};
  MuxKey #(.NR_KEY(8), .KEY_LEN(8), .DATA_LEN(3)) u_mux4 (
    .out(o_brfunc),
    .key({inst_jal, inst_jalr, inst_beq, inst_bne, inst_blt, inst_bge, inst_bltu, inst_bgeu}),
    .lut({
      8'b10000000, 3'b000,
      8'b01000000, 3'b001,
      8'b00100000, 3'b010,
      8'b00010000, 3'b011,
      8'b00001000, 3'b100,
      8'b00000100, 3'b101,
      8'b00000010, 3'b110,
      8'b00000001, 3'b111
    })
  );

  assign o_sel_csr      = |{inst_csrrw, inst_csrrs, inst_csrrwi, inst_ecall, inst_mret};
  assign o_sel_zimm     = |{inst_csrrwi};
  wire   CsrWr          = o_sel_csr ? (|{inst_csrrs} == 1 ? (|rs1 == 0 ? 0 : 1) : 1) : 0;
  wire   CsrRe          = o_sel_csr ? (|{inst_csrrw} == 1 ? (|rd == 0 ? 0 : 1) : 1) : 0;
  wire   raise_intr     = inst_ecall;
  wire   intr_ret       = inst_mret;

  MuxKeyWithDefault #(.NR_KEY(5), .KEY_LEN(6), .DATA_LEN(4)) u_mux5 (
    .out(o_EXctr),
    .key({(o_ALUctr == 5'b11111), inst_ebreak, inst_ecall, inst_mret, |{inst_csrrw, inst_csrrwi}, |{inst_csrrs}}),
    .default_out(4'b1111),
    .lut({
      6'b110000, 4'b1110,   // ebreak
      6'b101000, 4'b1101,   // ecall
      6'b100100, 4'b1100,   // mret
      6'b100010, 4'b0000,   // control and status register read and write
      6'b100001, 4'b0001    // control and status register read and set
    })
  );

  assign o_is_invalid_inst = (|inst_type == 1'b0) && (i_inst != 32'b0);

  ysyx_22050710_gpr #(.ADDR_WIDTH(5), .DATA_WIDTH(64)) u_gprs (
    .i_clk(i_clk),
    .i_raddr1(rs1), .i_raddr2(rs2), .i_waddr(i_ws_rf_waddr),
    .i_wdata(i_GPRbusW), .i_wen(i_ws_rf_wen),
    .o_rdata1(o_rs1data), .o_rdata2(o_rs2data)
  );

  wire [11:0] csr = i_inst[31:20];
  ysyx_22050710_csr #(.ADDR_WIDTH(12), .DATA_WIDTH(64)) u_csrs (
    .i_clk(i_clk),
    .i_raddr(csr), .i_waddr(csr), .i_wdata(i_CSRbusW),
    .i_epc(i_pc),
    .i_ren(CsrRe), .i_wen(CsrWr),
    .i_raise_intr(raise_intr), .i_intr_ret(intr_ret),
    .o_bus(o_csrrdata),
    .o_nextpc(o_sysctr_pc), .o_sys_change_pc(o_sys_change_pc)
  );

endmodule
