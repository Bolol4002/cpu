# Step 2 & 3: CPU Requirements and Architecture Design

This document details the planning for defining CPU requirements and designing the architecture for your VLSI-focused simple CPU.

---

## Step 2: Define CPU Requirements

### 1. Instruction Set Architecture (ISA)
- **Minimal Instructions:**
  - `LOAD R, addr`   : Load value from memory address into register R
  - `STORE R, addr`  : Store value from register R into memory address
  - `ADD R1, R2`     : Add values in R1 and R2, store result in R1
  - `SUB R1, R2`     : Subtract R2 from R1, store result in R1
  - `JMP addr`       : Jump to memory address
  - `JZ addr`        : Jump if zero flag is set
  - `IN R`           : Read input into register R
  - `OUT R`          : Output value from register R

### 2. Registers
- General Purpose Registers: 4 or 8 (e.g., R0–R3 or R0–R7)
- Program Counter (PC)
- Instruction Register (IR)
- Status Register (Zero, Carry flags)

### 3. Memory
- RAM: 256 bytes (expandable)
- ROM: For program storage (optional)

### 4. I/O
- Simple input (buttons, switches)
- Simple output (LEDs, display, serial)

### 5. Clock
- Single clock for synchronous operation

---

## Step 3: Design the CPU Architecture

### 1. Block Diagram
- [ ] Draw a block diagram with the following components:
  - Program Counter (PC)
  - Instruction Register (IR)
  - General Purpose Registers
  - Arithmetic Logic Unit (ALU)
  - Control Unit (FSM)
  - Memory Interface (RAM/ROM)
  - I/O Interface

### 2. Datapath Design
- **Data Flow:**
  - PC fetches instruction from memory
  - IR decodes instruction
  - Registers and ALU execute operations
  - Results written back to registers or memory

### 3. Control Unit Design
- **Finite State Machine (FSM):**
  - States: Fetch, Decode, Execute, Memory Access, Write Back
  - Generates control signals for datapath

### 4. ALU Design
- Supports ADD, SUB, AND, OR, NOT, etc.
- Sets status flags (Zero, Carry)

### 5. Memory and I/O
- Address bus and data bus for memory access
- Simple I/O mapped to memory addresses

---

## Resources
- [Simple CPU Design - Ben Eater (YouTube)](https://www.youtube.com/watch?v=FcH7Rj6gK4c)
- [Instruction Set Design - nand2tetris](https://www.nand2tetris.org/project03)
- [CPU Datapath and Control - Digital Design Book](https://www.amazon.com/Digital-Design-6th-M-Morris/dp/0134549899)

---

**Next Steps:**
- Finalize your instruction set and register count
- Draw your CPU block diagram (use pen/paper or digital tools)
- Start writing HDL modules for each block
