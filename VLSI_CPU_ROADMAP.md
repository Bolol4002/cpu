

### 1. Program Counter (PC)
- **Inputs:**
	- clk (1 bit)
	- reset (1 bit)
	- load (1 bit)
	- data_in [7:0] (8 bits, new address)
- **Outputs:**
	- addr_out [7:0] (8 bits, current address)
- **Function:** Holds and updates the instruction address.

---


### 2. Instruction Register (IR)
- **Inputs:**
	- clk (1 bit)
	- reset (1 bit)
	- load (1 bit)
	- data_in [7:0] (8 bits, instruction)
- **Outputs:**
	- instr_out [7:0] (8 bits, current instruction)
- **Function:** Stores the fetched instruction.

---


### 3. Register File (4 registers, 8 bits each)
- **Inputs:**
	- clk (1 bit)
	- reset (1 bit)
	- read_addr1 [1:0] (2 bits, selects 1 of 4 registers)
	- read_addr2 [1:0] (2 bits)
	- write_addr [1:0] (2 bits)
	- write_data [7:0] (8 bits)
	- write_enable (1 bit)
- **Outputs:**
	- read_data1 [7:0] (8 bits)
	- read_data2 [7:0] (8 bits)
- **Function:** Stores and provides access to general-purpose registers.

---


### 4. Arithmetic Logic Unit (ALU)
- **Inputs:**
	- operand_a [7:0] (8 bits)
	- operand_b [7:0] (8 bits)
	- alu_op [2:0] (3 bits, operation code)
- **Outputs:**
	- result [7:0] (8 bits)
	- zero_flag (1 bit)
	- carry_flag (1 bit)
- **Function:** Performs arithmetic and logic operations.

---


### 5. Control Unit (FSM)
- **Inputs:**
	- clk (1 bit)
	- reset (1 bit)
	- instr_in [7:0] (8 bits)
	- zero_flag (1 bit)
	- carry_flag (1 bit)
- **Outputs:**
	- control_signals (various, typically 1 bit each; e.g., reg_write, mem_read, alu_op [2:0], etc.)
- **Function:** Decodes instructions and generates control signals.

---


### 6. Memory Interface (RAM/ROM, 256 bytes)
- **Inputs:**
	- clk (1 bit)
	- addr [7:0] (8 bits)
	- data_in [7:0] (8 bits)
	- write_enable (1 bit)
- **Outputs:**
	- data_out [7:0] (8 bits)
- **Function:** Stores instructions and data.

---


### 7. I/O Interface
- **Inputs:**
	- clk (1 bit)
	- reset (1 bit)
	- io_in [7:0] (8 bits, external input)
	- io_addr [7:0] (8 bits)
	- io_write_enable (1 bit)
- **Outputs:**
	- io_out [7:0] (8 bits, external output)
- **Function:** Handles communication with external devices.

---