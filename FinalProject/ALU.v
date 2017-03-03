/*
 * Taylor Skilling
 * Will Johnson
 * 12/7/2016
 * EECE 3324
 *
 * ALU.v -- Main ALU
 */
 
module ALU(I0,I1,op,result,zero);
	input[31:0] I0,I1;
	input[3:0] op;
	reg[31:0] result;
	reg zero;
	output[31:0] result;
	output zero;
	
	always@(*) begin
		case(op)
			4'b0000: result = I0 & I1; 		// And
			4'b0001: result = I0 | I1;		// Or (unused)
			4'b0010: result = I0 + I1;		// Add
			4'b0110: result = I0 - I1;		// Subtract
			4'b0111: 						// Set on Less Than (alternate implementation from using 'signed')
				begin
					if (I0[31] == 0 && I1[31] == 0) result = I0 < I1;		// Both positive
					else if (I0[31] == 0 && I1[31] == 1) result = 32'b0;	// I0 positive and I1 negative
					else if (I0[31] == 1 && I1[31] == 0) result = 32'b1;	// I0 negative and I1 positive
					else if (I0[31] == 1 && I1[31] == 1) begin				// Both negative
						result = (~I0[30:0] < ~I1[30:0]);				// Compare the bitwise not (or 2s complement minus 1)
					end
				end
			4'b1100: result = !(I0 | I1); 	// Nor (unused)
		endcase
		
	zero = (result == 32'b0);
	
	end
endmodule