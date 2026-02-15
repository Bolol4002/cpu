module datapath(
    input clk,
    input we,
    input [31:0] instr
);

wire [4:0] rs1, rs2, rd;
wire is_add;
wire is_sub;

wire [31:0] rd1, rd2;
wire [31:0] alu_result;

// decode instruction
decoder dec(
    .instr(instr),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .is_add(is_add),
    .is_sub(is_sub)
);

// register file
regfile rf(
    .clk(clk),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .wd(alu_result),

    // write when either ADD or SUB
    .we(we & (is_add | is_sub)),

    .rd1(rd1),
    .rd2(rd2)
);

// ALU
alu alu0(
    .a(rd1),
    .b(rd2),
    .op_sub(is_sub),   // control signal
    .result(alu_result)
);

endmodule
