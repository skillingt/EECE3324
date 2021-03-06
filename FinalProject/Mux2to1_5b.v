/*
 * Taylor Skilling
 * Will Johnson
 * 12/7/2016
 * EECE 3324
 *
 * Mux2to1_5b.v -- 5b 2 to 1 mux
 */
 
module Mux2to1_5b(I0,I1,S0,A);
	input[0:5] I0,I1;
	input S0;
	reg[0:5] A;
	output[0:5] A;
	
	always@(I0 or I1 or S0) begin
		if(S0)
			A = I1;
		else
			A = I0;
	end
endmodule