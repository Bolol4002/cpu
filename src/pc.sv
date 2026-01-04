// -----------------------------
// Module: pc (Program Counter)
// Purpose: Keeps track of the address of the next instruction to execute in a CPU.
//
// Inputs:
//   clk      : Clock signal. The counter updates on the rising edge of this signal.
//   rst      : Reset signal. When high (1), the counter resets to 0.
//   load     : Load signal. When high (1), the counter loads the value from data_in.
//   data_in  : 8-bit value to load into the counter when load is high.
//
// Output:
//   addr_out : 8-bit current value of the program counter (address of next instruction).
//
// Behavior:
//   - On reset (rst=1): addr_out is set to 0.
//   - On load (load=1): addr_out is set to data_in.
//   - Otherwise: addr_out increments by 1 on each clock cycle.
//
// Example usage:
//   - To reset: set rst=1 for one clock cycle.
//   - To jump: set load=1 and provide address on data_in for one clock cycle.
//   - Normal: keep rst=0 and load=0 to increment.
// -----------------------------
module pc(
    input clk,            // Clock input
    input rst,            // Reset input (active high)
    input load,           // Load input (active high)
    input [7:0] data_in,  // 8-bit data input for loading a new address
    output reg [7:0] addr_out // 8-bit program counter output
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            addr_out <= 8'b0;         // Reset the counter to 0
        else if (load)
            addr_out <= data_in;      // Load new value into counter
        else
            addr_out <= addr_out + 1'b1; // Increment counter by 1
    end
endmodule