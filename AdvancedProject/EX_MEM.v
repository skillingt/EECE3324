/*
 * Taylor Skilling
 * Will Johnson
 * 12/14/2016
 * EECE 3324
 *
 * EX_MEM - EX/MEM Register
 */
module EX_MEM(clk, pc_rst, x_aluResult, x_writeData, x_writeReg, x_WB, x_M,
                            m_aluResult, m_writeData, m_writeReg, m_WB, m_M);
  input clk, pc_rst;
  input [31:0] x_aluResult, x_writeData;
  input [4:0] x_writeReg;
  input [2:0] x_M;
  input [1:0] x_WB;
  output reg [31:0] m_aluResult, m_writeData;
  output reg [4:0] m_writeReg;
  output reg [2:0] m_M;
  output reg [1:0] m_WB;
  
  always @ (posedge clk or negedge pc_rst) begin

  	// Clear values
	if (pc_rst)
		begin
			m_aluResult = 0;
      			m_writeData = 0;
      			m_writeReg = 0;
      			m_WB = 0;
      			m_M = 0;
    		end

   	// Pass values through
	else 
		begin
      			m_aluResult = x_aluResult;
      			m_writeData = x_writeData;
      			m_writeReg = x_writeReg;
      			m_WB = x_WB;
      			m_M = x_M;
    		end
    		
  	end
endmodule