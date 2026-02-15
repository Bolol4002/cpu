# Experimental

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