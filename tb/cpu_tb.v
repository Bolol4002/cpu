`timescale 1ns/1ps

module cpu_tb;

reg clk;
reg reset;

cpu dut(
    .clk(clk),
    .reset(reset)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("cpu_tb.vcd");
    $dumpvars(0, cpu_tb);

    clk = 0;
    reset = 1;

    #10 reset = 0;

    // preload registers
    dut.dp0.rf.regs[1] = 10;
    dut.dp0.rf.regs[2] = 20;

    // load instructions
    dut.imem0.memory[0] = 32'b0000000_00010_00001_000_00011_0110011; // ADD
    dut.imem0.memory[1] = 32'b0100000_00001_00011_000_00100_0110011; // SUB

    #40;

    $display("x3 = %0d", dut.dp0.rf.regs[3]);
    $display("x4 = %0d", dut.dp0.rf.regs[4]);

    $finish;
end

endmodule
