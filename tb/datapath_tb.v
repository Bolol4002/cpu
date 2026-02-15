`timescale 1ns/1ps

module datapath_tb;

reg clk;
reg [31:0] instr;
reg we;

datapath dut (
    .clk(clk),
    .we(we),
    .instr(instr)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("datapath_tb.vcd");
    $dumpvars(0, datapath_tb);

    clk = 0;
    we  = 1;

    // preload registers
    dut.rf.regs[1] = 10;   // x1 = 10
    dut.rf.regs[2] = 20;   // x2 = 20

    #2;

    // TEST 1: ADD x3, x1, x2
    instr = 32'b0000000_00010_00001_000_00011_0110011;
    #10;  // wait for clock edge

    $display("After ADD:");
    $display("x3 = %0d (expected 30)", dut.rf.regs[3]);

    // TEST 2: SUB x4, x2, x1
    // x4 = 20 - 10 = 10
    instr = 32'b0100000_00001_00010_000_00100_0110011;
    #10;

    $display("After SUB:");
    $display("x4 = %0d (expected 10)", dut.rf.regs[4]);

    // TEST 3: invalid instruction
    // should NOT write
    instr = 32'b0000000_00010_00001_000_00101_0000011;
    #10;

    $display("After invalid instruction:");
    $display("x5 = %0d (expected 0)", dut.rf.regs[5]);

    $finish;
end

endmodule
