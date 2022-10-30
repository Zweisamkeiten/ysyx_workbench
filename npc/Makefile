all:
	@echo "Write this Makefile by your self."

sim:
	$(call git_commit, "sim RTL") # DO NOT REMOVE THIS LINE!!!
	cd ./vsrc && verilator --trace --cc --exe --build -j 0 -Wall sim_main.cpp top.v

include ../Makefile
