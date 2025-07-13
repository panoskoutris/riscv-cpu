`include "alu.v"
`include "calc_enc.v"

`timescale 1ns / 1ps

module calc (
  output reg [15:0] led,
  input wire clk,
  input wire btnc, btnl, btnu, btnr, btnd,
  input wire [15:0] sw );
   
  reg [15:0] accumulator;
  
  // Extended accumulator
  wire [31:0] ext_accumulator = {{16{accumulator[15]}}, accumulator};
  
  // Extended sw
  wire [31:0] ext_sw = {{16{sw[15]}}, sw};
  
  // The operator of the ALU
  wire [3:0] op;
  calc_enc my_calc_enc (.alu_op(op),
                        .btnl(btnl),
                        .btnc(btnc),
                        .btnr(btnr));  
    
  
  // The ALU result and zero
  wire [31:0] alu_result;
  wire alu_zero;
  
  alu my_alu (.result(alu_result),
              .zero(alu_zero),
              .op1(ext_accumulator),
              .op2(ext_sw),
              .alu_op(op));
                 
                    
  // Accumulator design
  always @(posedge clk) 
    begin
      if (btnu)
        accumulator <= 16'b0;
      else if (btnd)
        accumulator <= alu_result[15:0];
      
      led <= accumulator;
      
    end
  
          
endmodule