module regfile(
    input clk,
    input [4:0] rs1,rs2,rd,
    input [31:0] wd,
    input we,
    output [31:0] rd1,rd2
);
reg [31:0] regs[31:0];
assign rd1 = (rs1==0)?32'd0:regs[rs1];
assign rd2 = (rs2==0)?32'd0:regs[rs2];
always @(posedge clk) begin
    if(we && rd!=0) begin
        regs[rd]<=wd;
    end
end
endmodule