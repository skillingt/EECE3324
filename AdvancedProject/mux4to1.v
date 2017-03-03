module mux4to1(zero, one, two, three, select, out);
	input [31:0] zero, one, two, three; 
	input [1:0] select;
	output reg[31:0] out;

	always @(zero or one or two or three or select)
		case(select)
		2'b00: 
		  out <= zero;
		2'b01: 
		  out <= one;
		2'b10: 
		  out <= two;
		2'b11: 
		  out <= three;
		endcase
endmodule
