`ifndef YSYX_22050710_MYCPU_AXI_H
  `define YSYX_22050710_MYCPU_AXI_H
  // Access permissions
  `define YSYX_22050710_AXI_PROT_UNPRIVILEGED_ACCESS                        3'b000
  `define YSYX_22050710_AXI_PROT_PRIVILEGED_ACCESS                          3'b001
  `define YSYX_22050710_AXI_PROT_SECURE_ACCESS                              3'b000
  `define YSYX_22050710_AXI_PROT_NON_SECURE_ACCESS                          3'b010
  `define YSYX_22050710_AXI_PROT_DATA_ACCESS                                3'b000
  `define YSYX_22050710_AXI_PROT_INSTRUCTION_ACCESS                         3'b100
`endif

