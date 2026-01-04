


### 1. Program Counter (PC)
- **Inputs:**
	- **clk (1 bit):** Clock signal. The program counter updates its value on each rising edge of this signal.
	- **reset (1 bit):** Reset signal. When high (1), the program counter resets its value to zero.
	- **load (1 bit):** Load signal. When high (1), the program counter loads a new value from `data_in` instead of incrementing.
	- **data_in [7:0] (8 bits):** An 8-bit input value. When `load` is high, this value is loaded into the program counter.
- **Outputs:**
	- **addr_out [7:0] (8 bits):** The current value of the program counter (an 8-bit address). This is the address of the next instruction.
- **How it works:**
	- On every rising edge of the clock (`clk`), or if the reset (`reset`) is activated:
		- If `reset` is high, the counter resets to `0`.
		- Else, if `load` is high, the counter takes the value from `data_in`.
		- Else, the counter increments by 1 (moves to the next instruction address).
- **Example Scenarios:**
	- **Resetting:** Set `reset` high for one clock cycle to start from the beginning.
	- **Jumping:** Set `load` high and provide the target address on `data_in` to jump to a specific instruction.
	- **Normal Operation:** If neither `reset` nor `load` are high, the counter just increases by 1 each clock, moving to the next instruction.

---



### 2. Instruction Register (IR)
- **Inputs:**
	- **clk (1 bit):** Clock signal. The register updates on the rising edge of this signal.
	- **reset (1 bit):** Reset signal. When high, clears the register to zero.
	- **load (1 bit):** Load signal. When high, loads a new instruction from `data_in`.
	- **data_in [7:0] (8 bits):** The instruction to be loaded into the register.
- **Outputs:**
	- **instr_out [7:0] (8 bits):** The current instruction stored in the register.
- **How it works:**
	- On each clock edge, if `reset` is high, the register is cleared.
	- If `load` is high, the value from `data_in` is stored as the current instruction.
	- Otherwise, the register holds its previous value.
- **Purpose:** Temporarily stores the instruction fetched from memory so it can be decoded and executed.

---



### 3. Register File (4 registers, 8 bits each)
- **Inputs:**
	- **clk (1 bit):** Clock signal. Writing to registers happens on the rising edge.
	- **reset (1 bit):** Reset signal. When high, clears all registers to zero.
	- **read_addr1 [1:0] (2 bits):** Selects which register to output on `read_data1`.
	- **read_addr2 [1:0] (2 bits):** Selects which register to output on `read_data2`.
	- **write_addr [1:0] (2 bits):** Selects which register to write to.
	- **write_data [7:0] (8 bits):** Data to write into the selected register.
	- **write_enable (1 bit):** When high, writes `write_data` to the register selected by `write_addr`.
- **Outputs:**
	- **read_data1 [7:0] (8 bits):** Data from the register selected by `read_addr1`.
	- **read_data2 [7:0] (8 bits):** Data from the register selected by `read_addr2`.
- **How it works:**
	- On reset, all registers are cleared.
	- On each clock edge, if `write_enable` is high, `write_data` is stored in the register selected by `write_addr`.
	- At any time, the values of the registers selected by `read_addr1` and `read_addr2` are available on `read_data1` and `read_data2`.
- **Purpose:** Provides fast storage and access to small amounts of data for the CPU to use during operations.

---



### 4. Arithmetic Logic Unit (ALU)
- **Inputs:**
	- **operand_a [7:0] (8 bits):** First operand for the operation.
	- **operand_b [7:0] (8 bits):** Second operand for the operation.
	- **alu_op [2:0] (3 bits):** Operation code (e.g., add, subtract, AND, OR, etc.).
- **Outputs:**
	- **result [7:0] (8 bits):** The result of the operation.
	- **zero_flag (1 bit):** High if the result is zero.
	- **carry_flag (1 bit):** High if there was a carry out (for addition/subtraction).
- **How it works:**
	- Based on `alu_op`, the ALU performs the selected operation on `operand_a` and `operand_b`.
	- The result is output on `result`.
	- `zero_flag` and `carry_flag` indicate special conditions after the operation.
- **Purpose:** Executes all arithmetic and logic operations required by the CPU.

---



### 5. Control Unit (FSM)
- **Inputs:**
	- **clk (1 bit):** Clock signal. The control unit updates its state on each clock edge.
	- **reset (1 bit):** Reset signal. When high, returns the control unit to its initial state.
	- **instr_in [7:0] (8 bits):** The current instruction to decode.
	- **zero_flag (1 bit):** Indicates if the last ALU result was zero.
	- **carry_flag (1 bit):** Indicates if the last ALU operation produced a carry.
- **Outputs:**
	- **control_signals:** Various signals (e.g., reg_write, mem_read, alu_op, etc.) that control the operation of the CPU's other modules.
- **How it works:**
	- Decodes the instruction in `instr_in` and, based on the current state and flags, generates the appropriate control signals to coordinate the CPU's operation.
- **Purpose:** Acts as the "brain" of the CPU, telling each part what to do at each step.

---



### 6. Memory Interface (RAM/ROM, 256 bytes)
- **Inputs:**
	- **clk (1 bit):** Clock signal. Memory operations are synchronized to this signal.
	- **addr [7:0] (8 bits):** Address to read from or write to.
	- **data_in [7:0] (8 bits):** Data to write to memory.
	- **write_enable (1 bit):** When high, writes `data_in` to the memory at `addr`.
- **Outputs:**
	- **data_out [7:0] (8 bits):** Data read from the memory at `addr`.
- **How it works:**
	- If `write_enable` is high on a clock edge, `data_in` is stored at the address `addr`.
	- Otherwise, the value at `addr` is output on `data_out`.
- **Purpose:** Stores both the program (instructions) and data for the CPU.

---



### 7. I/O Interface
- **Inputs:**
	- **clk (1 bit):** Clock signal. Synchronizes I/O operations.
	- **reset (1 bit):** Reset signal. Clears or initializes the I/O interface.
	- **io_in [7:0] (8 bits):** Data coming from an external device.
	- **io_addr [7:0] (8 bits):** Address to select which I/O device to communicate with.
	- **io_write_enable (1 bit):** When high, writes `io_in` to the selected I/O device.
- **Outputs:**
	- **io_out [7:0] (8 bits):** Data sent to an external device.
- **How it works:**
	- When `io_write_enable` is high, `io_in` is sent to the device at `io_addr`.
	- The value from the selected device can be read on `io_out`.
- **Purpose:** Allows the CPU to communicate with the outside world (e.g., sensors, displays, other computers).

---