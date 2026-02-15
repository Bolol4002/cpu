module decoder(
    input [31:0] instr,
    output [4:0] rs1,rs2,rd,
    output is_add,is_sub
);

assign rs1 = instr[19:15];
assign rs2 = instr[24:20];
assign rd  = instr[11:7];

wire [6:0] opcode = instr[6:0];
wire [2:0] funct3 = instr[14:12];
wire [6:0] funct7 = instr[31:25];

assign is_add =
    (opcode == 7'b0110011) &&
    (funct3 == 3'b000) &&
    (funct7 == 7'b0000000);
assign is_sub = is_add ? 1'b0 :
                (opcode == 7'b0110011) &&
                (funct3 == 3'b000) &&
                (funct7 == 7'b0100000);

endmodule