`timescale 1ns / 1ps

module alu (
  output reg [31:0] result,
  output reg zero,
  input wire [31:0] op1,
  input wire [31:0] op2,
  input wire [3:0] alu_op);
  
  parameter [3:0] ALUOP_AND = 4'b0000;   // And
  parameter [3:0] ALUOP_OR = 4'b0001;    // Or
  parameter [3:0] ALUOP_ADD = 4'b0010;   // Add 
  parameter [3:0] ALUOP_SUB = 4'b0110;   // Subtract
  parameter [3:0] ALUOP_SLT = 4'b0100;   // Smaller than
  parameter [3:0] ALUOP_LSR = 4'b1000;   // Logical Shift Right
  parameter [3:0] ALUOP_LSL = 4'b1001;   // Logical Shift Left
  parameter [3:0] ALUOP_ASR = 4'b1010;   // Arithmetic Shift Right
  parameter [3:0] ALUOP_XOR = 4'b0101;   // Xor
  
  
  wire signed [31:0] signed_op1 = op1;  // Signed op1
  wire signed [31:0] signed_op2 = op2;  // Signed op2
  
  always @ (*)
    begin
      case(alu_op)
        
        ALUOP_AND : result = op1 & op2;
        ALUOP_OR  : result = op1 | op2;  
        ALUOP_ADD : result = signed_op1 + signed_op2; 
        ALUOP_SUB : result = signed_op1 - signed_op2;
        ALUOP_SLT : result = (signed_op1 < signed_op2) ? 32'b1 : 32'b0;
        ALUOP_LSR : result = op1 >> op2[4:0];
        ALUOP_LSL : result = op1 << op2[4:0];
        ALUOP_ASR : result = signed_op1 >>> op2[4:0];
        ALUOP_XOR : result = op1 ^ op2;
        default   : result = 32'b0;
      endcase
      
      zero = (result == 32'b0) ? 1'b1 : 1'b0;      
      
    end
  
endmodule