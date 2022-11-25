TOPNAME = ysyx_22050710_npc
BUILD_DIR = ./build
VERILATOR_OBJ_DIR = $(BUILD_DIR)/obj_dir
BIN = $(BUILD_DIR)/$(TOPNAME)
IIMG ?=
NPC_EXEC := $(BIN) $(IMG)

ifeq ($(VERILATOR_ROOT),)
VERILATOR = verilator
else
export VERILATOR_ROOT
VERILATOR = $(VERILATOR_ROOT)/bin/verilator
endif
VERILATOR_CFLAGS += --build -cc -j $(shell nproc) -Wall -Wno-DECLFILENAME

default: $(BIN)

$(shell mkdir -p $(BUILD_DIR))

# project source
VSRCS = $(shell find $(abspath ./vsrc) -name "*.v")
CSRCS = $(shell find $(abspath ./csrc) -name "*.c" -or -name "*.cc" -or -name "*.cpp")
# CSRCS = $(shell realpath --relative-to $(abspath ./) $(shell find $(abspath ./csrc) -name "*.c" -or -name "*.cc" -or -name "*.cpp"))
# OBJS      = $(addprefix $(OBJ_DIR)/, $(addsuffix .o, $(basename $(filter-out csrc/main.cpp, $(CSRCS)))))
SRCS += $(shell find ./csrc -name "*.c")
CXXSRCS += $(shell find ./csrc -name "*.cc")
CPPSRCS += $(shell find ./csrc -name "*.cpp")
NAME = sim

# rules for NVBoard
include $(NVBOARD_HOME)/scripts/nvboard.mk

# rules for verilator
INC_PATH := $(NPC_HOME)/csrc/include
INC_PATH += $(NPC_HOME)/csrc/src/isa/include
INC_PATH += /usr/share/verilator/include
INC_PATH += /usr/share/verilator/include/vltstd
INCFLAGS = $(addprefix -I, $(INC_PATH))
CFLAGS += $(INCFLAGS) -Og -ggdb3
LDFLAGS += -lSDL2 -lSDL2_image -lreadline

# Include all filelist.mk to merge file lists
FILELIST_MK = $(shell find ./csrc -name "filelist.mk")
include $(FILELIST_MK)

-include $(NPC_HOME)/csrc/include/config/auto.conf
-include $(NPC_HOME)/csrc/include/config/auto.conf.cmd

CFLAGS_TRACE += -DITRACE_COND=$(if $(CONFIG_ITRACE_COND),$(call remove_quote,$(CONFIG_ITRACE_COND)),true)
CFLAGS_TRACE += -DIRINGTRACE_COND=$(if $(CONFIG_IRINGTRACE_COND),$(call remove_quote,$(CONFIG_IRINGTRACE_COND)),true)
CFLAGS_TRACE += -DFTRACE_COND=$(if $(CONFIG_FTRACE_COND),$(call remove_quote,$(CONFIG_FTRACE_COND)),true)
CFLAGS  += $(CFLAGS_TRACE)

# Include rules for menuconfig
include $(NPC_HOME)/scripts/config.mk

# Include rules for build
include $(NPC_HOME)/scripts/build.mk

build-csrc: $(OBJS)
	@echo "Write this Makefile by your self."

build-vsrc: $(VSRCS)
	$(call git_commit, "build RTL") # DO NOT REMOVE THIS LINE!!!
	@echo "-- VERILATE & BUILD --------"
	$(VERILATOR) $(VERILATOR_CFLAGS) \
		--top-module $(TOPNAME) $^ --prefix Vtop --trace --Mdir $(VERILATOR_OBJ_DIR)

sim: $(BIN)
	$(call git_commit, "sim RTL") # DO NOT REMOVE THIS LINE!!!
	@echo "-- Simulation --------"
	$(NPC_EXEC)

.PHONY: default all run build

include ../Makefile
