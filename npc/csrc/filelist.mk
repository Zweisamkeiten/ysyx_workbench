CPPSRCS += csrc/main.cpp
CXXFLAGS += $(shell llvm-config --cxxflags) -fPIE
