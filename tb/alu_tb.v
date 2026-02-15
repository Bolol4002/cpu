`timescale 1ps/1ps
module alu_tb;
reg [31:0] a;
reg [31:0] b;
wire [31:0] result;
alu dut(a,b,result);
initial begin
    $dumpfile("alu_tb.vcd");
    $dumpvars(0,alu_tb);
    a=32'd0;
    b=32'd0;
    #10;
    a=32'd10;
    b=32'd20;
    #10;
    $finish;
end
initial begin
    $monitor("a=%d, b=%d, result=%d",a,b,result);
end
endmodule