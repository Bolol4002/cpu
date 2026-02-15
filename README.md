# Experimental

## Simple RISC-V CPU (Educational)

This repository contains a small educational CPU that implements a minimal subset of the **RISC-V ISA** (R-type `add` and `sub`).
The project explores instruction decoding, register file behavior, ALU operations, and execution flow using simulation.

The focus is understanding how machine instructions become electrical behavior.

---

## Repository Layout

### `src/` — RTL Sources

* **cpu.v** — top-level CPU wiring `pc`, `imem`, and `datapath`
* **pc.v** — program counter (increments by 4 each cycle)
* **imem.v** — instruction memory (word-addressable ROM)
* **decoder.v** — extracts instruction fields and detects `add` / `sub`
* **regfile.v** — 32 × 32-bit register file (x0 hardwired to zero)
* **alu.v** — ALU supporting add/sub operations
* **datapath.v** — connects decoder, regfile, and ALU

### `tb/` — Testbenches

* **alu_tb.v** — ALU unit test
* **cpu_tb.v** — system-level testbench with instruction execution

### `vcd_files/`

Waveform outputs for GTKWave analysis.

---

## Build & Run

Recommended:

```bash
make
```

### Run ALU Test

```bash
iverilog -o alu_test src/alu.v tb/alu_tb.v
vvp alu_test
```

### Run Full CPU Simulation

```bash
iverilog -o vcd_files/cpu_test \
src/alu.v src/cpu.v src/datapath.v src/decoder.v \
src/imem.v src/pc.v src/regfile.v tb/cpu_tb.v

vvp vcd_files/cpu_test
```

---

## Viewing Waveforms

VCD files are written to `vcd_files/`.

```bash
gtkwave vcd_files/cpu_tb.vcd
```

Observe:

* register reads & writes
* ALU results
* instruction flow
* control signal behavior

---

## Testbench Notes

The CPU testbench preloads state using hierarchical access:

```verilog
dut.dp0.rf.regs[1] = 10;
dut.dp0.rf.regs[2] = 20;

dut.imem0.memory[0] =
  32'b0000000_00010_00001_000_00011_0110011; // ADD x3,x1,x2
```

If module instance names change, update the hierarchical paths.

---

## Implementation Details

* `imem` uses `addr[6:2]` for word indexing.
* `regfile` ignores writes to x0 and always returns 0.
* `decoder` distinguishes ADD vs SUB via `opcode`, `funct3`, and `funct7`.
* ALU operation is selected using control logic derived from decode signals.

---

## Extending the Project

Suggested next steps:

* add **ADDI** (I-type)
* implement **ALU control bus**
* add **branch instructions**
* add **data memory** (load/store)
* execute compiled RISC-V programs

---

# R-Type ADD Instruction Details

A CPU does not see:

```
add x3, x1, x2
```

It sees a 32-bit pattern:

```
0000000 00010 00001 000 00011 0110011
```

This is the **RISC-V R-type format**.

## Field Layout

| Bits  | Field  | Purpose              |
| ----- | ------ | -------------------- |
| 31–25 | funct7 | operation variant    |
| 24–20 | rs2    | source register 2    |
| 19–15 | rs1    | source register 1    |
| 14–12 | funct3 | operation subtype    |
| 11–7  | rd     | destination register |
| 6–0   | opcode | instruction class    |

Think of it like parsing a sentence:

* **opcode** → verb category
* **funct fields** → exact action
* **rs1, rs2** → inputs
* **rd** → destination

---

## Recognizing ADD

ADD is identified by:

```
opcode = 0110011
funct3 = 000
funct7 = 0000000
```

Hardware detection:

```verilog
assign is_add =
  (opcode == 7'b0110011) &&
  (funct3 == 3'b000) &&
  (funct7 == 7'b0000000);
```

Decoding is combinational logic — instant pattern recognition.

---

## Why funct7 Matters

```
ADD → funct7 = 0000000
SUB → funct7 = 0100000
```

Same datapath. Different control signal.

This enables multiple operations using minimal hardware.

---

## Execution Flow

When ADD is decoded:

1. register file outputs rs1 & rs2
2. ALU performs addition
3. result written to rd

The decoder declares intent.
The datapath performs the work.

---

## Architectural Insight

This project implements the foundational CPU triad:

* **ALU** → computation
* **Register file** → storage
* **Decoder** → instruction understanding

Add control and sequencing, and simple circuits become a programmable machine.

---

Last updated: 2026-02-15
