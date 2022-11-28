// ysyx_22050710
import "DPI-C" function void set_inst_ptr(input logic [31:0] a[]);
import "DPI-C" function void set_pc_ptr(input logic [63:0] a[]);
module ysyx_22050710_npc (
);
  initial begin
    set_inst_ptr(inst);
    set_pc_ptr(inst);
  end

  wire [31:0] inst;
  wire [63:0] pc;
  ysyx_22050710_ifu u_ifu (
    .i_pc(pc),
    .o_inst(inst)
  );

endmodule
