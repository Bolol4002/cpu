module cpu(
    input clk,
    input reset
);

wire [31:0] pc_out;
wire [31:0] instr;

// program counter
pc pc0(
    .clk(clk),
    .reset(reset),
    .pc_out(pc_out)
);

// instruction memory
imem imem0(
    .addr(pc_out),
    .instr(instr)
);

// datapath executes instruction
datapath dp0(
    .clk(clk),
    .we(1'b1),
    .instr(instr)
);

endmodule
