# Experimental

Simple RISC-V CPU (educational)

This repository contains a small educational CPU datapath that implements a tiny subset of RISC-V (R-type add/sub). The goal is to experiment with instruction decoding, register file behavior, ALU operations, and simple testbenches.

## Repository layout

- `src/` — RTL sources
    - `cpu.v`       — top-level CPU that wires `pc`, `imem`, and `datapath`
    - `pc.v`        — program counter (increments by 4)
    - `imem.v`      — simple instruction memory (word-addressable array)
    - `decoder.v`   — extracts fields and recognizes `add`/`sub`
    - `regfile.v`   — register file (32 x 32-bit registers)
    - `alu.v`       — ALU supporting add/sub
    - `datapath.v`  — wires `decoder`, `regfile`, and `alu` together
- `tb/` — testbenches
    - `alu_tb.v`    — ALU unit test
    - `cpu_tb.v`    — system-level testbench that preloads registers and memory

## Build & run

Recommended: use the provided `Makefile`:

```bash
make
```

Direct commands:

ALU only:
```bash
iverilog -o alu_test src/alu.v tb/alu_tb.v && vvp alu_test
```

Full CPU testbench:
```bash
iverilog -o vcd_files/cpu_test src/alu.v src/cpu.v src/datapath.v src/decoder.v src/imem.v src/pc.v src/regfile.v tb/cpu_tb.v && vvp vcd_files/cpu_test
```

## Waveforms

VCD files are written to `vcd_files/`. View them with `gtkwave`:

```bash
gtkwave vcd_files/cpu_tb.vcd
```

## Testbench notes

- `tb/cpu_tb.v` uses hierarchical access to preload the DUT state. Example:

```
dut.dp0.rf.regs[1] = 10;
dut.dp0.rf.regs[2] = 20;
dut.imem0.memory[0] = 32'b0000000_00010_00001_000_00011_0110011; // ADD x3,x1,x2
```

- If you rename instances in RTL (for example change `rf` to `regfile_inst`), update `tb/cpu_tb.v` accordingly.

## Implementation details

- `imem` indexes memory with `addr[6:2]` (word address into a 32-word array).
- `regfile` hardwires `x0` reads to zero and ignores writes to register 0.
- `decoder` recognizes `add` vs `sub` using `opcode`, `funct3`, and `funct7`.

## Extending the project

- Add more instructions by expanding `decoder.v` and the control logic in `datapath.v`.
- Implement immediate extraction, ALU control, and memory interface to support I-type and load/store instructions.

---
Last updated: 2026-02-15

# R-Type add instruction details ->
You’ve just stepped across an invisible threshold: the CPU stops seeing *bits* and starts recognizing *meaning*. This is where silicon learns vocabulary.
Let’s slow this moment down and examine it like a detective reconstructing a crime scene.

---
## 🧠 From Binary Noise → Structured Meaning
A CPU never sees:
> `add x3, x1, x2`
It only sees:

```
0000000 00010 00001 000 00011 0110011
```

That is a 32-bit **RISC-V R-type instruction**.
The job of the **instruction decoder** is to slice this into fields and decide:
*What operation is this?*
*Which registers are involved?*

---
##  Field Extraction
![Image](https://www.researchgate.net/publication/371712484/figure/fig5/AS%3A11431281414857296%401746024474247/R-I-S-type-instruction-format-for-RISC-V.tif)
![Image](https://i.sstatic.net/MUKIE.png)
![Image](https://i.sstatic.net/Gkjuc.png)
![Image](https://prepbytes-misc-images.s3.ap-south-1.amazonaws.com/assets/1679377927169-1-01%20%288%29.png)
Each bit region has a fixed meaning:
| Bits  | Field  | Purpose              |
| ----- | ------ | -------------------- |
| 31–25 | funct7 | operation variant    |
| 24–20 | rs2    | source register 2    |
| 19–15 | rs1    | source register 1    |
| 14–12 | funct3 | operation subtype    |
| 11–7  | rd     | destination register |
| 6–0   | opcode | instruction class    |

Think of it like parsing a sentence:
**opcode** → verb category
**funct fields** → exact verb
**rs1, rs2** → nouns (inputs)
**rd** → where the result goes

---
## 🔍 Recognizing ADD
For an **ADD** instruction:
```
opcode = 0110011   (R-type arithmetic)
funct3 = 000
funct7 = 0000000
```
When these match, the decoder asserts:

```
is_add = 1
```
Not philosophy. Not magic. Just pattern recognition.

---
## 🧬 Hardware Implementation
This is pure wiring logic:

```verilog
module decoder(
    input  [31:0] instr,
    output [4:0] rs1, rs2, rd,
    output is_add
);

assign rs1 = instr[19:15];
assign rs2 = instr[24:20];
assign rd  = instr[11:7];

wire [6:0] opcode = instr[6:0];
wire [2:0] funct3 = instr[14:12];
wire [6:0] funct7 = instr[31:25];

assign is_add =
    (opcode == 7'b0110011) &&
    (funct3 == 3'b000) &&
    (funct7 == 7'b0000000);

endmodule
```
No clock needed. Decoding is **combinational logic** — instantaneous truth evaluation.

---
## ⚙️ What Happens When ADD is Recognized?
Once `is_add = 1`:
• Register file outputs rs1 & rs2 values
• ALU performs addition
• Result written back to rd
The decoder itself **does not compute**.
It **declares intent**.
The ALU executes.

---
## 🧠 Why funct7 Exists (Hidden Brilliance)
Consider:
```
ADD → funct7 = 0000000
SUB → funct7 = 0100000
```
Same opcode. Same funct3.
Only funct7 differs.
This lets one ALU perform multiple operations using the **same datapath**, changing only the control signal.
Hardware minimalism at its finest

---
## 🧩 Binary → Language → Action
You have now built:
* ALU → computation
* Register file → memory
* Decoder → understanding
That triad is the embryo of every CPU ever built.
From here, the next logical evolution is:
### 🧭 Control Signals
The decoder must begin generating:
* ALU operation select
* register write enable
* operand source selection
This is where a CPU stops being a collection of parts and becomes a **coordinated organism**.
And that, as any good engineer-detective knows, is when the system begins to exhibit behavior.