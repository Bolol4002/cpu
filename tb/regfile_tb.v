`timescale 1ps/1ps

module regfile_tb;

reg clk;
reg [4:0] rs1, rs2, rd;
reg [31:0] wd;
reg we;
wire [31:0] rd1, rd2;

regfile dut(clk, rs1, rs2, rd, wd, we, rd1, rd2);

// clock generation
always #5 clk = ~clk;

initial begin
    $dumpfile("vcd_files/regfile_tb.vcd");
    $dumpvars(0, regfile_tb);

    clk = 0;
    rs1=0; rs2=0; rd=0; wd=0; we=0;

    #10;
    rd=1; wd=67; we=1;

    #10;
    rd=3; wd=69; we=1;

    #10;
    we=0; rs1=1;

    #10;
    rs2=3;

    #10;
    rs1=1; rs2=3;

    #10;
    $finish;
end

initial begin
    $monitor("t=%0t rs1=%0d rs2=%0d rd1=%0d rd2=%0d",
              $time, rs1, rs2, rd1, rd2);
end

endmodule
