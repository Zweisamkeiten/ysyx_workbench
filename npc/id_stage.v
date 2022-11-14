// ysyx_22050710
module ysyx_22050710_id (
  input [31:0] i_inst,
);

  wire [11:0] imm;
  wire [4:0] rs1, rs2, rd;
  wire [2:0] funct3;
  wire [6:0] opcode;

  assign imm = i_inst[31:20];
  assign rs1 = i_inst[19:15];
  assign rs2 = i_inst[24:20];
  assign funct3 = i_inst[14:12];
  assign rd = i_inst[11:7];
  assign opcode = i_inst[6:0];
  
  wire inst_addi = |(opcode[6:0] ~^ 7'b0010011) & |(funct3[2:0] ~^ 3'b000);

  reg [7-2+3-1:0] inst_opcode; // opcode 7位 前两位都为1相同, 加funct3 3位

  assign 

endmodule
