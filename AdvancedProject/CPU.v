/*
 * Taylor Skilling
 * Will Johnson
 * 12/14/2016
 * EECE 3324
 *
 * CPU.v -- CPU - instantiates modules for each pipeline stage
 */

// Instantiate CPU module
module cpu(clk_in, pc_rst);

// Inputs from test bench
input clk_in, pc_rst;

// Define halt
wire clk, d_halt;

// Connect clock and halt
assign clk = clk_in & !d_halt;

/*
 * Fetch
*/
// Declare Wires
wire [31:0] pc, pcp4, d_pcp4, instr, d_instr, nextInstr, d_branchAddr, 
		jAddr, d_seInstr16, m_aluResult;
wire [1:0] d_pcSrc;
wire haz_ifidFlush, haz_pcEn, haz_ifidEn, haz_idexEn, x_zero;
// Assign next PC 
assign pcp4 = pc + 4;

mux3to1 pc_mux(pcp4, d_branchAddr, jAddr, d_pcSrc, nextInstr);
// Instantiate PC 
reg32 pc_32(clk, nextInstr, haz_pcEn, pc_rst, pc);
// Instantiate IF/ID Register
IF_ID IFID(haz_ifidEn, haz_ifidFlush, clk, pc_rst, instr, d_instr, pcp4, d_pcp4);

/*
 * Decode
*/
wire [31:0] se_sll_instr16, d_readData0, d_readData1, d_forwardData0, d_forwardData1, d_writeData,
		x_readData0, x_readData1, x_pcp4, x_seInstr16;
wire [15:0] instr_imm16;
wire [5:0] d_opcode, d_ctlIn, x_ctlIn;
wire [4:0] d_rs, d_rt, d_rd, d_writeReg; 
wire [4:0] x_rs, x_rt, x_rd;
wire [3:0] x_EX;
wire [2:0] x_M;
wire [1:0] d_aluOp, x_WB, w_WB;
wire d_regWrite, d_memToReg, d_branch, d_memRead, d_memWrite, d_regDst, d_aluSrc, d_zero, d_jump;
// Assign fields instruction code to variables
assign d_opcode = d_instr[31:26];
assign d_rs = d_instr[25:21];
assign d_rt = d_instr[20:16];
assign d_rd = d_instr[15:11];
assign d_ctlIn = d_instr[5:0];

// Create the branch address
// Repeat the MSB of the 16 bit immediate and concatenate that with the lower 16 bits
assign instr_imm16 = d_instr[15:0];
assign d_seInstr16 = {{16{instr_imm16[15]}}, instr_imm16[15:0]};
assign se_sll_instr16 = d_seInstr16 << 2;
assign d_branchAddr = d_pcp4 + se_sll_instr16;
// Create a 32 bit address using PC + 4 and the instruction shifted left 2
assign jAddr = {pcp4[31:28], d_instr[25:0], 2'b00};

// Branch Control
assign d_zero = (d_forwardData0 == d_forwardData1);
assign d_pcSrc = {d_jump, d_zero && d_branch};
assign haz_ifidFlush = d_pcSrc[0] ||  d_pcSrc[1];

// Muxes
mux2to1 mux_forward0(d_readData0, m_aluResult, forward0_br, d_forwardData0);
mux2to1 mux_forward1(d_readData1, m_aluResult, forward1_br, d_forwardData1);

// Register File
reg_file rf(clk, w_WB[0], d_rs, d_rt, d_writeReg, 
		d_writeData, d_readData0, d_readData1);

// Control Unit
control ctl(d_opcode, d_regDst, d_jump, d_branch, d_memRead, d_memToReg, 
		d_memWrite, d_aluSrc, d_regWrite, d_halt, d_aluOp);

// ID/EX Register
ID_EX IDEX(clk, haz_idexEn,
           d_pcp4, d_seInstr16, d_rs, d_rt, d_rd, d_readData0, d_readData1, d_aluOp, d_regWrite,
 	   d_memToReg, d_branch, d_memRead, d_memWrite, d_regDst, d_aluSrc, d_zero, d_ctlIn,
           x_pcp4, x_seInstr16, x_rs, x_rt, x_rd, x_readData0, x_readData1, 
           x_WB, x_M, x_EX, x_ctlIn);

/*
 * Execution
 */
wire [31:0] aluIn0, x_writeData, aluIn1, x_aluResult, m_writeData, w_writeData; //m_aluResult
wire [4:0] x_writeReg, m_writeReg;
wire [3:0] operation;
wire [2:0] m_M;
wire [1:0] m_WB, forward0_alu, forward1_alu;

// ALU Muxes
mux4to1 mux_alu1(x_readData0, w_writeData, m_aluResult, 0, forward0_alu, aluIn0);
mux4to1 mux_writeData(x_readData1, w_writeData, m_aluResult, 0, forward1_alu, x_writeData);
mux2to1 mux_alu2(x_writeData, x_seInstr16, x_EX[0], aluIn1);

// ALU Control
ALUControl alu_ctl(x_EX[2:1], x_ctlIn, operation);
// ALU (note that x_zero is not used in this implementation
ALU alu(aluIn0, aluIn1, operation, x_aluResult, x_zero);
mux2to1_5b mux_writeRegister(x_rt, x_rd, x_EX[3], x_writeReg);
	  
EX_MEM EXMEM(clk, pc_rst, x_aluResult, x_writeData, x_writeReg, x_WB, x_M,
                            m_aluResult, m_writeData, m_writeReg, m_WB, m_M);

// Memory
wire [31:0] dmem_readData, w_aluResult, w_dmemReadData;
wire [4:0] w_writeReg;
wire ctl_memRead;
// Assign memory module inputs and outputs
assign ctl_memRead = m_M[1];
assign ctl_memWrite = m_M[0];

// Instantiate MEM/WB Register
MEM_WB MEMWB(clk, pc_rst, m_aluResult, m_writeReg, dmem_readData, m_WB,
                            w_aluResult, w_writeReg, w_dmemReadData, w_WB);
	
	
// Write/Hazard Detection/Forwarding
mux2to1 mux_writeBack(w_aluResult, w_dmemReadData, w_WB[1], w_writeData);
assign d_writeReg = w_writeReg;
assign d_writeData = w_writeData;

HazardDetection haz_detect(d_instr, x_rt, x_M, haz_pcEn, haz_ifidEn, haz_idexEn);
ForwardingUnit forward_unit(pc_rst, d_rs, d_rt, x_rs, x_rt, 
		       m_writeReg, w_writeReg, m_WB, w_WB, 
		       forward0_br, forward1_br, forward0_alu, forward1_alu);

// Instantiate Combined Instruction and Data Memory
Memory mem(pc, instr, m_aluResult, m_writeData, ctl_memRead, ctl_memWrite, dmem_readData);

// Stop the program if the halt instruction is hit
always@(instr) 
begin
	if(instr == 32'hfc000000)
	    $stop;
end

endmodule