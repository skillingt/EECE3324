/*
 * Taylor Skilling
 * Will Johnson
 * 12/14/2016
 * EECE 3324
 *
 * MEM_WB - ME/WB Register
 */

module MEM_WB(clk, pc_rst, m_aluResult, m_writeReg, dmem_readData, m_WB,
                    w_aluResult, w_writeReg, w_dmemReadData, w_WB);

  input clk, pc_rst;
  input [31:0] m_aluResult, dmem_readData;
  input [4:0] m_writeReg;
  input [1:0] m_WB;
  output reg [31:0] w_aluResult, w_dmemReadData;
  output reg [4:0] w_writeReg;
  output reg [1:0] w_WB;
  
  always @ (posedge clk or negedge pc_rst) 
    begin

      // Clear values
      if (pc_rst)
        begin
          w_aluResult <= 0;
          w_dmemReadData <= 0;
          w_writeReg <= 0;
          w_WB <= 0;
        end
      else

      // Pass values through
        begin
          w_aluResult <= m_aluResult;
          w_dmemReadData <= dmem_readData;
          w_writeReg <= m_writeReg;
          w_WB <= m_WB;
        end
        
      end
endmodule