/*
 * Taylor Skilling
 * Will Johnson
 * 12/7/2016
 * EECE 3324
 *
 * ALUControl.v -- Control for the main ALU
 */
 
module ALUControl(ALUop,functCode,opOut);
	input[0:1] ALUop;
	input[0:5] functCode;
	output[0:3] opOut;
	reg[0:3] opOut;
	
	always@(*) begin
		case(ALUop)
			2'b10: begin			// ADD, SUB, AND, OR, SLT
				case(functCode)
					6'b100000: opOut = 4'b0010; // ADD
					6'b100010: opOut = 4'b0110; // SUB
					6'b100100: opOut = 4'b0000; // AND
					6'b100101: opOut = 4'b0001; // OR
					6'b101010: opOut = 4'b0111; // SLT
				endcase
			end
			2'b00: opOut = 4'b0010; 			// LW or SW or ADDI -> ADD
			2'b01: opOut = 4'b0110;				// BEQ -> SUB
		endcase
	end
endmodule