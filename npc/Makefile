TOPNAME = ysyx_22050710_top
BUILD_DIR = ./build
VERILATOR_OBJ_DIR = $(BUILD_DIR)/obj_dir
BIN = $(BUILD_DIR)/$(TOPNAME)
IMG ?=
NPC_EXEC := $(BIN) $(IMG) $(ELF) $(REF) $(IFRUNBATCH)

ifeq ($(VERILATOR_INC_ROOT),)
VERILATOR_INC_ROOT = /usr/share/verilator
VERILATOR = verilator
else
VERILATOR = $(shell which verilator)
endif
VERILATOR_VERSION = $(shell verilator --version | cut -d ' ' -f 2 | cut -d. -f 1)
VERILATOR_CFLAGS += --compiler $(call remove_quote,$(CONFIG_CC))
VERILATOR_CFLAGS += --build -cc -j $(shell nproc)
VERILATOR_CFLAGS += -Wall -Wno-DECLFILENAME
VERILATOR_CFLAGS += -Wno-UNUSED
VERILATOR_CFLAGS += --trace
VERILATOR_CFLAGS += -Os --x-assign fast --x-initial fast --noassert
VERILATOR_CFLAGS += -I./vsrc -CFLAGS -Os -CFLAGS -march=native -CFLAGS -flto -CFLAGS -ffat-lto-objects

remove_quote = $(patsubst "%",%,$(1))

default: all

$(shell mkdir -p $(BUILD_DIR))
-include $(NPC_HOME)/csrc/include/config/auto.conf
-include $(NPC_HOME)/csrc/include/config/auto.conf.cmd

NAME = sim

# Include all filelist.mk to merge file lists
FILELIST_MK = $(shell find ./csrc -name "filelist.mk")
include $(FILELIST_MK)

# Filter out directories and files in blacklist to obtain the final set of source files
DIRS-BLACKLIST-y += $(DIRS-BLACKLIST)
SRCS-BLACKLIST-y += $(SRCS-BLACKLIST) $(shell find $(DIRS-BLACKLIST-y) -name "*.c")
SRCS-y += $(shell find $(DIRS-y) -name "*.c")
SRCS = $(filter-out $(SRCS-BLACKLIST-y),$(SRCS-y))

# Extract compiler and options from menuconfig
CC = $(call remove_quote,$(CONFIG_CC))
CFLAGS_BUILD += $(call remove_quote,$(CONFIG_CC_OPT))
CFLAGS_BUILD += $(if $(CONFIG_CC_LTO),-flto,)
CFLAGS_BUILD += $(if $(CONFIG_CC_DEBUG),-Og -ggdb3,)
CFLAGS_TRACE += -DITRACE_COND=$(if $(CONFIG_ITRACE_COND),$(call remove_quote,$(CONFIG_ITRACE_COND)),true)
CFLAGS_TRACE += -DIRINGTRACE_COND=$(if $(CONFIG_IRINGTRACE_COND),$(call remove_quote,$(CONFIG_IRINGTRACE_COND)),true)
CFLAGS_TRACE += -DFTRACE_COND=$(if $(CONFIG_FTRACE_COND),$(call remove_quote,$(CONFIG_FTRACE_COND)),true)
CFLAGS  += $(CFLAGS_BUILD) $(CFLAGS_TRACE) -march=native
LDFLAGS += $(CFLAGS_BUILD) -latomic -flto -ldl -lpthread

# Include rules for menuconfig
include $(NPC_HOME)/scripts/config.mk

# Include rules for build
include $(NPC_HOME)/scripts/build.mk

# rules for NVBoard
# include $(NVBOARD_HOME)/scripts/nvboard.mk
# LDFLAGS += -lSDL2 -lSDL2_image

# # project source
VSRCS = $(shell find $(abspath ./vsrc) -name "*.v")
VALL = $(VERILATOR_OBJ_DIR)/Vtop__ALL.a

$(VALL): $(VSRCS)
	$(call git_commit, "build RTL") # DO NOT REMOVE THIS LINE!!!
	@echo "-- VERILATE & BUILD --------"
	$(VERILATOR) $(VERILATOR_CFLAGS) \
		--top-module $(TOPNAME) $^ --prefix Vtop --Mdir $(VERILATOR_OBJ_DIR)
	@$(CXX) -O3 -I. $(INCLUDES) -MMD -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=1 -DVM_TRACE_FST=0 -DVM_TRACE_VCD=1 -faligned-new -fcf-protection=none -Wno-bool-operation -Wno-sign-compare -Wno-uninitialized -Wno-unused-const-variable -std=gnu++17 -c -o $(VERILATOR_OBJ_DIR)/verilated.o $(VERILATOR_INC_ROOT)/include/verilated.cpp
	@$(CXX) -O3 -I. $(INCLUDES) -MMD -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=1 -DVM_TRACE_FST=0 -DVM_TRACE_VCD=1 -faligned-new -fcf-protection=none -Wno-bool-operation -Wno-sign-compare -Wno-uninitialized -Wno-unused-const-variable -std=gnu++17 -c -o $(VERILATOR_OBJ_DIR)/verilated_dpi.o $(VERILATOR_INC_ROOT)/include/verilated_dpi.cpp
	@$(CXX) -O3 -I. $(INCLUDES) -MMD -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=1 -DVM_TRACE_FST=0 -DVM_TRACE_VCD=1 -faligned-new -fcf-protection=none -Wno-bool-operation -Wno-sign-compare -Wno-uninitialized -Wno-unused-const-variable -std=gnu++17 -c -o $(VERILATOR_OBJ_DIR)/verilated_vcd_c.o $(VERILATOR_INC_ROOT)/include/verilated_vcd_c.cpp
	if [ $(VERILATOR_VERSION) -eq 5 ]; then $(CXX) -O3 -I. $(INCLUDES) -MMD -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=1 -DVM_TRACE_FST=0 -DVM_TRACE_VCD=1 -faligned-new -fcf-protection=none -Wno-bool-operation -Wno-sign-compare -Wno-uninitialized -Wno-unused-const-variable -std=gnu++17 -c -o $(VERILATOR_OBJ_DIR)/verilated_threads.o $(VERILATOR_INC_ROOT)/include/verilated_threads.cpp; fi;

VERILATOR_SRC = verilated.cpp verilated_dpi.cpp verilated_vcd_c.cpp
ifeq ($(VERILATOR_VERSION), 5)
VERILATOR_SRC += verilated_threads.cpp
else
	
endif
VERILATOR_OBJ = $(addprefix $(VERILATOR_OBJ_DIR)/, $(VERILATOR_SRC:%.cpp=%.o))

$(BIN): $(VALL) $(VERILATOR_OBJ) $(OBJS) # $(NVBOARD_ARCHIVE)
	@$(LD) -o $@ $(realpath $(OBJS)) $(VERILATOR_OBJ) $(VALL) $(LDFLAGS) $(LIBS)

run-env: $(BIN) $(VSRCS) $(SRCS)

sim: run-env
	$(call git_commit, "sim RTL") # DO NOT REMOVE THIS LINE!!!
	@echo "-- Simulation --------"
	$(NPC_EXEC)

gdbbatch: run-env
	$(call git_commit, "gdb sim RTL")
	gdb -s $(BIN) -x $(NPC_HOME)/gdbinit $(BIN)

gdb: run-env
	$(call git_commit, "gdb sim RTL")
	gdb -s $(BIN) $(BIN) -iex "set args $(IMG) $(ELF) $(REF)"

wave:
	gtkwave $(NPC_HOME)/dump.vcd $(NPC_HOME)/wavegroup.gtkw &

all: run-env

.PHONY: default all run-env sim gdbbatch gdb wave

include ../Makefile
