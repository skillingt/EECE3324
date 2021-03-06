/*
 * Taylor Skilling
 * Will Johnson
 * 12/14/2016
 * EECE 3324
 *
 * CPUSIM.v -- Test Bench for CPU
 */

`timescale 1ns/100ps
module CPUSim;
	reg clk,pc_rst;
	integer cycles,cpi;
	
	cpu proc1(clk,pc_rst);

	wire [31:0] R8_t0 = proc1.rf.regFile['d8];   
	wire [31:0] R9_t1 = proc1.rf.regFile['d9];   
  	wire [31:0] R10_t2 = proc1.rf.regFile['d10];   
  	wire [31:0] R11_t3 = proc1.rf.regFile['d11];
	wire [31:0] R12_t4 = proc1.rf.regFile['d12];   
	wire [31:0] R13_t5 = proc1.rf.regFile['d13];   
  	wire [31:0] R14_t6 = proc1.rf.regFile['d14];   
  	wire [31:0] R17_s1 = proc1.rf.regFile['d17];
	wire [31:0] R18_s2 = proc1.rf.regFile['d18];
	wire [31:0] R19_s3 = proc1.rf.regFile['d19];
	
	initial begin
		clk = 0;
		cycles = 0;
		cpi = 0;
		forever #2.5 clk=!clk;
	end
	
	
	always@(posedge clk) begin
		if (pc_rst == 1) begin
			cycles = 0;
			cpi = 0;
		end else begin
			cycles = cycles+1;
			cpi = cycles/149;
		end
	end
	
	initial begin // Feed a high reset after the first instruction executes, see the program restart
		#4 pc_rst = 1'b1;
		#12 pc_rst = 1'b0;
	end

endmodule