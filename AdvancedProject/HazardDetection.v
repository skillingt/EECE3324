/*
 * Taylor Skilling
 * Will Johnson
 * 12/14/2016
 * EECE 3324
 *
 * Hazard Detection Unit 
 */

module HazardDetection(d_instr, x_rt, x_M, haz_pcEn, haz_ifidEn, haz_idexEn);
input [31:0] d_instr;
input [4:0] x_rt;
input [2:0] x_M;
output reg haz_pcEn, haz_ifidEn, haz_idexEn;
wire [4:0] next_op, next_rs, next_rt;

// Assign instruction fields
assign next_op = d_instr[31:26];
assign next_rs = d_instr[25:21];
assign next_rt = d_instr[20:16];

always@(d_instr or x_rt or x_M[1])
begin

  // No hazard state
  haz_idexEn <= 0;
  haz_pcEn <= 1;
  haz_ifidEn <= 1;

  // Check for halt or hazard
  if (next_op == 6'h3f || (x_M[1] && ((x_rt == next_rt) || (x_rt == next_rs))))
    begin
      haz_idexEn <= 1;
      haz_pcEn <= 0;
      haz_ifidEn <= 0;      
    end

end
endmodule