module pc(
    input clk,
    input rst,
    input load,
    input [7:0] data_in,
    output reg [7:0] addr_out
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            addr_out <= 8'b0;
        else if (load)
            addr_out <= data_in;
        else
            addr_out <= addr_out + 1'b1;
    end
endmodule