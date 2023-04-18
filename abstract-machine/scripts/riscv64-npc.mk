include $(AM_HOME)/scripts/isa/riscv64.mk

AM_SRCS := riscv/npc/start.S \
           riscv/npc/trm.c \
           riscv/npc/ioe.c \
           riscv/npc/gpu.c \
           riscv/npc/audio.c \
           riscv/npc/timer.c \
           riscv/npc/input.c \
           riscv/npc/cte.c \
           riscv/npc/trap.S \
           platform/dummy/vme.c \
           platform/dummy/mpe.c

CFLAGS    += -fdata-sections -ffunction-sections
CFLAGS  	+= -DISA_H=\"riscv/riscv.h\"
CFLAGS 		+= -I$(AM_HOME)/am/src/platform/dummy/include
LDFLAGS   += -T $(AM_HOME)/scripts/linker.ld --defsym=_pmem_start=0x80000000 --defsym=_entry_offset=0x0
LDFLAGS   += --gc-sections -e _start
CFLAGS += -DMAINARGS=\"$(mainargs)\"
.PHONY: $(AM_HOME)/am/src/riscv/npc/trm.c

image: $(IMAGE).elf
	@$(OBJDUMP) -d $(IMAGE).elf > $(IMAGE).txt
	@$(OBJDUMP) -d $(IMAGE).elf --disassembler-options=no-aliases > $(IMAGE)-no-aliases.txt
	@echo + OBJCOPY "->" $(IMAGE_REL).bin
	@$(OBJCOPY) -S --set-section-flags .bss=alloc,contents -O binary $(IMAGE).elf $(IMAGE).bin

run: image
	$(MAKE) -C $(NPC_HOME) sim IMG=$(IMAGE).bin ELF=$(IMAGE).elf REF=$(NEMU_HOME)/riscv64-nemu-interpreter-so

runbatch: image
	$(MAKE) -C $(NPC_HOME) sim IMG=$(IMAGE).bin ELF=$(IMAGE).elf REF=$(NEMU_HOME)/riscv64-nemu-interpreter-so IFRUNBATCH="1"

gdb: image
	$(MAKE) -C $(NPC_HOME) gdb IMG=$(IMAGE).bin ELF=$(IMAGE).elf REF=$(NEMU_HOME)/riscv64-nemu-interpreter-so
