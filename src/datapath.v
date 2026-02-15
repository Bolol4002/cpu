module datapath(
    input clk,
    input we,
    input [31:0] instr
);

wire [4:0] rs1, rs2, rd;
wire is_add, is_sub;
wire [31:0] rd1, rd2;
wire [31:0] alu_result;
wire write_enable;

decoder dec0(
    .instr(instr),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .is_add(is_add),
    .is_sub(is_sub)
);

regfile rf(
    .clk(clk),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .wd(alu_result),
    .we(write_enable),
    .rd1(rd1),
    .rd2(rd2)
);

alu alu0(
    .a(rd1),
    .b(rd2),
    .op_sub(is_sub),
    .result(alu_result)
);

// only write back on enabled (we) and for ALU ops (add/sub)
assign write_enable = we & (is_add | is_sub);

endmodule
