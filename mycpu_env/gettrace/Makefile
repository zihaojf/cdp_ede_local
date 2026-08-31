SIM_RUN_DIR := $(CURDIR)/gettrace.sim/sim_1/behav/iverilog
VERILOG_SOURCES := $(wildcard src/*.v src/*/*.v)

IVERILOG_BIN := $(SIM_RUN_DIR)/gettrace
VERILATOR_MDIR ?= $(CURDIR)/gettrace.sim/sim_1/behav/verilator
VERILATOR_BIN := $(VERILATOR_MDIR)/gettrace

.PHONY: iverilog verilator verilator-build verilator-run clean

iverilog: $(IVERILOG_BIN)
	cd "$(SIM_RUN_DIR)" && vvp ./gettrace

$(IVERILOG_BIN): $(VERILOG_SOURCES)
	mkdir -p "$(SIM_RUN_DIR)"
	iverilog -Wall -o "$@" $(VERILOG_SOURCES)

verilator: $(VERILATOR_BIN)
	mkdir -p "$(SIM_RUN_DIR)"
	cd "$(SIM_RUN_DIR)" && "$(VERILATOR_BIN)"

verilator-build: $(VERILATOR_BIN)

verilator-run:
	test -x "$(VERILATOR_BIN)"
	mkdir -p "$(SIM_RUN_DIR)"
	cd "$(SIM_RUN_DIR)" && "$(VERILATOR_BIN)"

$(VERILATOR_BIN): $(VERILOG_SOURCES)
	mkdir -p "$(VERILATOR_MDIR)"
	verilator \
		--binary \
		--timing \
		-Wall \
		-Wno-fatal \
		--top-module tb_top \
		--Mdir "$(VERILATOR_MDIR)" \
		-o gettrace \
		$(VERILOG_SOURCES)

clean:
	rm -rf gettrace.sim
	rm -f golden_trace.txt
