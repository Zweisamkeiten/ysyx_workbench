CXXSRCS += csrc/src/sim_init.cc
CXXFLAGS += -faligned-new
DIRS-y += csrc/src/cpu csrc/src/utils csrc/src/engine
DIRS-y += csrc/src/memory
INC_PATH += /usr/share/verilator/include
INC_PATH += /usr/share/verilator/include/vltstd
