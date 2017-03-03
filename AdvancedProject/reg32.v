/*
 * Taylor Skilling
 * Will Johnson
 * 12/14/2016
 * EECE 3324
 *
 * reg32.v -- 32 32-bit Registers
 */

module reg32 (clk, in, en, rst, out);

input en, rst, clk;
input [31:0] in;
output reg [31:0] out;

always @(posedge clk or posedge rst)
begin
    if (rst == 1)
        out <= 32'h3000;
    else if (en == 1)
        out <= in;
end

endmodule