/*
 * Taylor Skilling
 * Will Johnson
 * 12/14/2016
 * EECE 3324
 *
 * control.v -- CPU Control
 */

module control (instr_opcode, ctl_regDst, ctl_jump, ctl_branch, ctl_memRead, 
		ctl_memToReg, ctl_memWrite, ctl_aluSrc, ctl_regWrite, ctl_halt, ctl_aluOp);

input [5:0] instr_opcode;
output reg ctl_regDst, ctl_jump, ctl_branch, ctl_memRead, ctl_memToReg, 
		ctl_memWrite, ctl_aluSrc, ctl_regWrite, ctl_halt;
output reg [1:0] ctl_aluOp;

initial ctl_regDst = 0;
initial ctl_jump = 0;initial ctl_branch = 0;
initial ctl_memRead = 0;
initial ctl_memToReg = 0;
initial ctl_memWrite = 0;
initial ctl_aluSrc = 0;
initial ctl_regWrite = 0;
initial ctl_halt = 0;
initial ctl_aluOp = 2'b0;

always @(instr_opcode)
begin
    // Reset to 0 to ensure only valid control bits are active
    ctl_regDst = 0;
    ctl_jump = 0;
    ctl_memRead = 0;
    ctl_branch = 0;
    ctl_memRead = 0;
    ctl_memToReg = 0;
    ctl_memWrite = 0;
    ctl_aluSrc = 0;
    ctl_regWrite = 0;
    ctl_halt = 0;

    // Determine control signals based on opcode
    case (instr_opcode)
        6'b000000: // add, slt
            begin
                ctl_regDst = 1;
                ctl_regWrite = 1;
                ctl_aluOp = 2'b10;
            end
        6'b001000:  // addi
            begin
                ctl_regWrite = 1;
                ctl_aluSrc = 1;
		ctl_aluOp = 2'b00;
            end
        6'b001001: // addiu
            begin
                ctl_regWrite = 1;
                ctl_aluSrc = 1;
            end
        6'b100011: // lw
            begin
                ctl_memRead = 1;
                ctl_memToReg = 1;
                ctl_regWrite = 1;
                ctl_aluSrc = 1;
            end
        6'b101011: // sw
            begin
                ctl_memWrite = 1;
                ctl_aluSrc = 1;
            end
        6'b000100:  // beq, ALU handles subtration
            begin
                ctl_branch = 1;
                ctl_aluOp = 2'b01;
            end
        6'b000010: 
			begin
				ctl_jump = 1;
			end
        6'h3f: // halt 
            begin
                ctl_halt = 1;
            end
    endcase
end

endmodule
