module alu(
    input [31:0] a,
    input [31:0] b,
    input op_sub,          // 0 = add, 1 = subtract
    output [31:0] result
);

assign result = op_sub ? (a - b) : (a + b);

endmodule
