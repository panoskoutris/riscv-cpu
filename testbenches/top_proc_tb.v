`include "top_proc.v"
`include "rom.v"
`include "ram.v"

`timescale 1ns / 1ps

module top_proc_tb;

  // Clock and Reset
  reg clk;
  reg rst;

  // Interfacing Signals
  wire [31:0] instr;
  wire [31:0] dReadData;
  wire [31:0] PC;
  wire [31:0] dAddress;
  wire [31:0] dWriteData;
  wire [31:0] WriteBackData;
  wire MemRead;
  wire MemWrite;

  // ROM and RAM Instances
  INSTRUCTION_MEMORY my_instruction_memory (
    .clk(clk),
    .addr(PC[8:0]),
    .dout(instr)
  );

  DATA_MEMORY my_data_memory (
    .clk(clk),
    .we(MemWrite),
    .addr(dAddress[8:0]),
    .din(dWriteData),
    .dout(dReadData)
  );

  // Processor Instance
  top_proc processor (
    .clk(clk),
    .rst(rst),
    .instr(instr),
    .dReadData(dReadData),
    .PC(PC),
    .dAddress(dAddress),
    .dWriteData(dWriteData),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .WriteBackData(WriteBackData)
  );

  // Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10ns clock period
  end

  // Test Procedure
  initial begin
    // Generate waveform
    $dumpfile("dump.vcd");
    $dumpvars;

    // Reset the system
    rst = 1;
    #20; // Wait for 20ns
    rst = 0;

    // Run the simulation for a sufficient time
    #1700;

    // Stop the simulation
    $finish;
  end

  // Monitor Outputs
  initial begin
    $monitor("Time: %0dns | PC: %h | Instr: %h | dAddress: %h | dWriteData: %h | dReadData: %h | WriteBackData: %h | MemRead: %b | MemWrite: %b", 
             $time, PC, instr, dAddress, dWriteData, dReadData, WriteBackData, MemRead, MemWrite);
  end

endmodule