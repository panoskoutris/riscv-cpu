`timescale 1ns / 1ps

module calc_enc (
  output wire [3:0] alu_op,
  input wire btnl, btnc, btnr );
  
  // Not's
  wire not_btnl, not_btnc, not_btnr;
  
  not u1 (not_btnl, btnl);
  not u2 (not_btnc, btnc);
  not u3 (not_btnr, btnr);
  
  // Calculating alu_op[0]
  wire first_and1, second_and1;
  and u4 (first_and1, not_btnc, btnr);
  and u5 (second_and1, btnl, btnr);
  or u6 (alu_op[0], first_and1, second_and1);
  
  // Calculating alu_op[1]
  wire first_and2, second_and2;
  and u7 (first_and2, not_btnl, btnc);
  and u8 (second_and2, btnc, not_btnr);
  or u9 (alu_op[1], first_and2, second_and2);
  
  // Calculating alu_op[2]
  wire first_and3, second_and3, third_and3;
  and u10 (first_and3, btnc, btnr);
  and u11 (second_and3, btnl, not_btnc);
  and u12 (third_and3, second_and3, not_btnr);
  or u13 (alu_op[2], first_and3, third_and3);
  
  // Calculating alu_op[3]
  wire first_and4, second_and4, third_and4, fourth_and4;
  and u14 (first_and4, btnl, not_btnc);
  and u15 (second_and4, first_and4, btnr);
  and u16 (third_and4, btnl, btnc);
  and u17 (fourth_and4, third_and4, not_btnr);
  or u18 (alu_op[3], second_and4, fourth_and4);
   
endmodule
