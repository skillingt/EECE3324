/*
 * Taylor Skilling
 * Will Johnson
 * 12/14/2016
 * EECE 3324
 *
 * Mux2to1_5b.v -- 5b 2 to 1 mux
 */
 
module mux2to1_5b(I0,I1,S0,A);
	input[4:0] I0,I1;
	input S0;
	output reg [4:0] A;
	
	initial A = 5'b0;
	
	always@(I0 or I1 or S0) begin
		if(S0 == 0)
			A = I0;
		else
			A = I1;
	end
endmodule