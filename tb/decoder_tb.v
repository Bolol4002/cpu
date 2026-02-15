`timescale 1ns/1ps

module decoder_tb;

reg  [31:0] instr;
wire [4:0] rs1, rs2, rd;
wire is_add,is_sub;

decoder dut (
    .instr(instr),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .is_add(is_add),
    .is_sub(is_sub)
);

initial begin

    $display("Time\tInstruction\t\t rs1 rs2 rd is_add is_sub");
    $monitor("%0t\t%b\t %0d  %0d  %0d   %b %b",
              $time, instr, rs1, rs2, rd, is_add, is_sub);

    // =========================
    // Test 1: ADD x3, x1, x2
    // =========================
    instr = 32'b0000000_00010_00001_000_00011_0110011;
    #10;

    // =========================
    // Test 2: SUB x3, x1, x2
    // funct7 different → not ADD
    // =========================
    instr = 32'b0100000_00010_00001_000_00011_0110011;
    #10;

    // =========================
    // Test 3: Different opcode
    // =========================
    instr = 32'b0000000_00010_00001_000_00011_0000011;
    #10;

    $finish;
end

endmodule
