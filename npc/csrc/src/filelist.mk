CXXSRCS += csrc/src/sim_init.cc
CXXFLAGS += -faligned-new
DIRS-y += csrc/src/cpu csrc/src/utils csrc/src/engine
DIRS-y += csrc/src/memory
ifeq ("$(VERILATOR_INC_ROOT)","/usr/share/verilator")
INC_PATH += /usr/share/verilator/include
INC_PATH += /usr/share/verilator/include/vltstd
else
INC_PATH += /usr/local/share/verilator/include
INC_PATH += /usr/local/share/verilator/include/vltstd
endif
