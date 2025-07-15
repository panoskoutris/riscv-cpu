`timescale 1ns / 1ps

module regfile # ( parameter DATAWIDTH = 32 )
  (input wire clk,
   input wire [4:0] readReg1,
   input wire [4:0] readReg2,
   input wire [4:0] writeReg,
   input wire [DATAWIDTH-1:0] writeData,
   input wire write,
   output reg [DATAWIDTH-1:0] readData1,
   output reg [DATAWIDTH-1:0] readData2);
  
  // Our registers
  reg [DATAWIDTH-1:0] registers [31:0];  
  
  // Initialize our registers as zero
  initial 
    begin
      integer i;
      for (i = 0; i < 32; i = i + 1)
        registers[i] = {DATAWIDTH{1'b0}};                       
    end
  
  always @(posedge clk)
    begin
      if (write) begin
        // Write to the register
        registers[writeReg] <= writeData;

        // Handle overlaps
        if (writeReg == readReg1) 
          readData1 <= writeData;
        else 
          readData1 <= registers[readReg1];

        if (writeReg == readReg2) 
          readData2 <= writeData;
        else 
          readData2 <= registers[readReg2];
      end 
      else begin
        // Read without writing
        readData1 <= registers[readReg1];
        readData2 <= registers[readReg2];
      end
    end
  
endmodule

   