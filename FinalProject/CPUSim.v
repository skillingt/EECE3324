`timescale 1ns/100ps
module CPUSim;
	reg clk,pc_rst;
	integer cycles,numInstr,cpi;
	
	$display("\nNumber of Cycles: %d", cycles);
	$display("\nNumber of Instructions: %d", numInstr);
	$display("\nCycles per Instruction: %d", cpi);
	
	CPU proc1(clk,pc_rst);
	
	initial begin
		clk = 0;
		cycles = 0;
		numInstr = 0;
		cpi = 0;
		forever #2.5 clk=!clk;
	end
	
	
	always@(posedge clk, pc_rst) begin
		if (pc_rst) begin
			cycles = 0;
			numInstr = 0;
			cpi = 0;
		end
		cycles = cycles+1;
		numInstr = numInstr+1;
		cpi = cycles/numInstr;
	end
	
	initial begin // Feed a high reset after the first instruction executes, see the program restart
		#4 pc_rst = 1'b1;
		#12 pc_rst = 1'b1;
	end

endmodule