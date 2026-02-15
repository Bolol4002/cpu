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
all: regfile

# ===== regfile Test =====
regfile:
	mkdir -p $(OUT_DIR)
	$(IVERILOG) -o $(OUT_DIR)/regfile_test $(SRC) $(TB_DIR)/regfile_tb.v
	$(VVP) $(OUT_DIR)/regfile_test

# ===== Open waveform =====
wave:
	gtkwave $(OUT_DIR)/regfile_tb.vcd

# ===== Clean outputs =====
clean:
	rm -rf $(OUT_DIR)/*
