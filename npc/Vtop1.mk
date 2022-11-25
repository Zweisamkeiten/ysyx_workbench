# Verilated -*- Makefile -*-
# DESCRIPTION: Verilator output: Makefile for building Verilated archive or executable
#
# Execute this makefile from the object directory:
#    make -f Vtop.mk

default: /home/einsam/p/ysyx-workbench/npc/build/ysyx_22050710_npc

### Constants...
# Perl executable (from $PERL)
PERL = perl
# Path to Verilator kit (from $VERILATOR_ROOT)
VERILATOR_ROOT = /usr/share/verilator
# SystemC include directory with systemc.h (from $SYSTEMC_INCLUDE)
SYSTEMC_INCLUDE ?= 
# SystemC library directory with libsystemc.a (from $SYSTEMC_LIBDIR)
SYSTEMC_LIBDIR ?= 

### Switches...
# C++ code coverage  0/1 (from --prof-c)
VM_PROFC = 0
# SystemC output mode?  0/1 (from --sc)
VM_SC = 0
# Legacy or SystemC output mode?  0/1 (from --sc)
VM_SP_OR_SC = $(VM_SC)
# Deprecated
VM_PCLI = 1
# Deprecated: SystemC architecture to find link library path (from $SYSTEMC_ARCH)
VM_SC_TARGET_ARCH = linux

### Vars...
# Design prefix (from --prefix)
VM_PREFIX = Vtop
# Module prefix (from --prefix)
VM_MODPREFIX = Vtop
# User CFLAGS (from -CFLAGS on Verilator command line)
VM_USER_CFLAGS = \
	-I/home/einsam/p/ysyx-workbench/npc/csrc/include \
	-I/home/einsam/p/ysyx-workbench/npc/csrc/src/isa/include \
	-Wall \
	-Werror \
	-Og \
	-ggdb3 \
	-DITRACE_COND= \
	-DIRINGTRACE_COND= \
	-DFTRACE_COND=true \

# User LDLIBS (from -LDFLAGS on Verilator command line)
VM_USER_LDLIBS = \
	/home/einsam/p/ysyx-workbench/nvboard/build/nvboard.a \
	-lSDL2 \
	-lSDL2_image \
	-lreadline \

# User .cpp files (from .cpp's on Verilator command line)
VM_USER_CLASSES = \
	main \
	cpu-exec \
	engine_init \
	init \
	reg \
	paddr \
	monitor \
	expr \
	sdb \
	watchpoint \
	sim_init \
	elf \
	rand \

# User .cpp directories (from .cpp's on Verilator command line)
VM_USER_DIR = \
	/home/einsam/p/ysyx-workbench/npc/csrc \
	/home/einsam/p/ysyx-workbench/npc/csrc/src \
	/home/einsam/p/ysyx-workbench/npc/csrc/src/cpu \
	/home/einsam/p/ysyx-workbench/npc/csrc/src/engine \
	/home/einsam/p/ysyx-workbench/npc/csrc/src/isa \
	/home/einsam/p/ysyx-workbench/npc/csrc/src/memory \
	/home/einsam/p/ysyx-workbench/npc/csrc/src/monitor \
	/home/einsam/p/ysyx-workbench/npc/csrc/src/monitor/sdb \
	/home/einsam/p/ysyx-workbench/npc/csrc/src/utils \


### Default rules...
# Include list of all generated classes
include Vtop_classes.mk
# Include global rules
include $(VERILATOR_ROOT)/include/verilated.mk

### Executable rules... (from --exe)
VPATH += $(VM_USER_DIR)

main.o: /home/einsam/p/ysyx-workbench/npc/csrc/main.cpp
	$(OBJCACHE) $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(OPT_FAST) -c -o $@ $<
cpu-exec.o: /home/einsam/p/ysyx-workbench/npc/csrc/src/cpu/cpu-exec.c
	$(OBJCACHE) $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(OPT_FAST) -c -o $@ $<
engine_init.o: /home/einsam/p/ysyx-workbench/npc/csrc/src/engine/engine_init.c
	$(OBJCACHE) $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(OPT_FAST) -c -o $@ $<
init.o: /home/einsam/p/ysyx-workbench/npc/csrc/src/isa/init.c
	$(OBJCACHE) $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(OPT_FAST) -c -o $@ $<
reg.o: /home/einsam/p/ysyx-workbench/npc/csrc/src/isa/reg.c
	$(OBJCACHE) $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(OPT_FAST) -c -o $@ $<
paddr.o: /home/einsam/p/ysyx-workbench/npc/csrc/src/memory/paddr.c
	$(OBJCACHE) $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(OPT_FAST) -c -o $@ $<
monitor.o: /home/einsam/p/ysyx-workbench/npc/csrc/src/monitor/monitor.c
	$(OBJCACHE) $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(OPT_FAST) -c -o $@ $<
expr.o: /home/einsam/p/ysyx-workbench/npc/csrc/src/monitor/sdb/expr.c
	$(OBJCACHE) $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(OPT_FAST) -c -o $@ $<
sdb.o: /home/einsam/p/ysyx-workbench/npc/csrc/src/monitor/sdb/sdb.c
	$(OBJCACHE) $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(OPT_FAST) -c -o $@ $<
watchpoint.o: /home/einsam/p/ysyx-workbench/npc/csrc/src/monitor/sdb/watchpoint.c
	$(OBJCACHE) $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(OPT_FAST) -c -o $@ $<
sim_init.o: /home/einsam/p/ysyx-workbench/npc/csrc/src/sim_init.c
	$(OBJCACHE) $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(OPT_FAST) -c -o $@ $<
elf.o: /home/einsam/p/ysyx-workbench/npc/csrc/src/utils/elf.c
	$(OBJCACHE) $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(OPT_FAST) -c -o $@ $<
rand.o: /home/einsam/p/ysyx-workbench/npc/csrc/src/utils/rand.c
	$(OBJCACHE) $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(OPT_FAST) -c -o $@ $<

### Link rules... (from --exe)
/home/einsam/p/ysyx-workbench/npc/build/ysyx_22050710_npc: $(VK_USER_OBJS) $(VK_GLOBAL_OBJS) $(VM_PREFIX)__ALL.a $(VM_HIER_LIBS)
	$(LINK) $(LDFLAGS) $^ $(LOADLIBES) $(LDLIBS) $(LIBS) $(SC_LIBS) -o $@


# Verilated -*- Makefile -*-
