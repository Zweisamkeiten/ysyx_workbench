TOPNAME = ysyx_22050710_npc
BUILD_DIR = ./build
OBJ_DIR = $(realpath $(BUILD_DIR)/obj_dir)
BIN = $(BUILD_DIR)/$(TOPNAME)
IIMG ?=
NPC_EXEC := $(BIN) $(IMG)
WARP_SIM_SRC = $(NPC_HOME)/csrc/main.cpp

ifeq ($(VERILATOR_ROOT),)
VERILATOR = verilator
else
export VERILATOR_ROOT
VERILATOR = $(VERILATOR_ROOT)/bin/verilator
endif
VERILATOR_CFLAGS += --build -cc --exe -j $(shell nproc)

default: $(BIN)

$(shell mkdir -p $(BUILD_DIR))

# project source
VSRCS = $(shell find $(abspath ./vsrc) -name "*.v")
CSRCS = $(shell realpath --relative-to $(abspath ./) $(shell find $(abspath ./csrc) -name "*.c" -or -name "*.cc" -or -name "*.cpp"))
OBJS      = $(addprefix $(OBJ_DIR)/, $(addsuffix .o, $(basename $(filter-out csrc/main.cpp, $(CSRCS)))))

# rules for NVBoard
include $(NVBOARD_HOME)/scripts/nvboard.mk

# rules for verilator
INC_PATH := $(NPC_HOME)/csrc/include
INC_PATH += $(OBJ_DIR)
INC_PATH += /usr/share/verilator/include
INC_PATH += /usr/share/verilator/include/vltstd
INCFLAGS = $(addprefix -I, $(INC_PATH))
CFLAGS += $(INCFLAGS) -Wall -Werror
CXXFLAGS := $(CFLAGS)
LDFLAGS += -lSDL2 -lSDL2_image

### Rule (compile): a single `.c` -> `.o` (gcc)
$(OBJ_DIR)/%.o: %.c
	@mkdir -p $(dir $@) && echo + CC $<
	@$(CC) -std=gnu11 $(CFLAGS) -c -o $@ $<

all: $(OBJS)
	@echo "Write this Makefile by your self."

$(BIN): $(VSRCS) $(WARP_SIM_SRC) $(NVBOARD_ARCHIVE) $(OBJS)
	$(call git_commit, "build RTL") # DO NOT REMOVE THIS LINE!!!
	@echo "-- VERILATE & BUILD --------"
	$(VERILATOR) $(VERILATOR_CFLAGS) \
		--top-module $(TOPNAME) $(VSRCS) $(WARP_SIM_SRC) $(NVBOARD_ARCHIVE) $(OBJS) --prefix Vtop --trace $(addprefix -CFLAGS , $(CFLAGS)) $(addprefix -LDFLAGS , $(LDFLAGS)) \
		-I $(INC_PATH) \
		--Mdir $(OBJ_DIR) -o $(abspath $(BIN))

sim: $(BIN)
	$(call git_commit, "sim RTL") # DO NOT REMOVE THIS LINE!!!
	@echo "-- Simulation --------"
	$(NPC_EXEC)

clean:
	rm -rf $(BUILD_DIR)

.PHONY: default all clean run

include ../Makefile
