# ===== Directories =====
SRC_DIR = src
TB_DIR  = tb
OUT_DIR = vcd_files

# ===== Tools =====
IVERILOG = iverilog
VVP      = vvp

# ===== Automatically include all RTL =====
SRC = $(wildcard $(SRC_DIR)/*.v)

# ===== Default target =====
all: cpu

# ===== cpu Test =====
cpu:
	mkdir -p $(OUT_DIR)
	$(IVERILOG) -o $(OUT_DIR)/cpu_test $(SRC) $(TB_DIR)/cpu_tb.v
	$(VVP) $(OUT_DIR)/cpu_test

# ===== Open waveform =====
wave:
	gtkwave $(OUT_DIR)/cpu_tb.vcd

# ===== Clean outputs =====
clean:
	rm -rf $(OUT_DIR)/*
