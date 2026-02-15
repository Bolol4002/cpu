module imem(
    input [31:0] addr,
    output [31:0] instr
);

reg [31:0] memory [0:31];

assign instr = memory[addr[6:2]]; 
//ignore last 2 bits for some reason.

// Why [6:2]?
// instructions are 4 bytes aligned
// lower 2 bits always 00
// saves memory space
// Hardware loves alignment.

endmodule
