/*
 * Taylor Skilling
 * Will Johnson
 * 12/14/2016
 * EECE 3324
 *
 * IF_ID - IF/ID Register
 */

module IF_ID(en, flush, clk, rst, f_instr, d_instr, f_pcp4, d_pcp4);
  input en, flush, clk, rst;
  input [31:0] f_instr, f_pcp4;
  output reg[31:0] d_instr, d_pcp4;

  always @ (posedge clk)
  begin

    // Clear the register
    if (flush || rst)
    	begin
        d_instr <= 0;
        d_pcp4 <= 0;
      end

    // if enabled, pass the values through
    else if (en)
      begin
        d_instr <= f_instr;
        d_pcp4 <= f_pcp4;
      end

  end
endmodule

