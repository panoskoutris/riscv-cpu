`include "calc.v"

`timescale 1ns / 1ps

module calc_tb;
  
  // Inputs and Outputs  
  reg clk;
  reg btnc, btnl, btnr, btnu, btnd;
  reg [15:0] sw;  
  wire [15:0] led;
  
  // Our calculator instance
  calc uut (
    .clk(clk), 
    .btnc(btnc), 
    .btnl(btnl), 
    .btnr(btnr), 
    .btnu(btnu), 
    .btnd(btnd), 
    .sw(sw), 
    .led(led)
  );
  
  // Clock 
  initial clk = 0;
  always #5 clk = ~clk; // Clock period = 10ns

  
  initial begin
    
    // Open the VCD file to record waveform data
    $dumpfile("dump.vcd"); 
    $dumpvars(0, calc_tb);   

    // Initialize inputs
    btnc = 0; btnl = 0; btnr = 0; btnu = 0; btnd = 0; sw = 16'h0000;

    // Test 1: Reset
    #10 btnu = 1; 
    #10 btnu = 0;
    #10;
    if (led !== 16'h0000) $display("Test 1 Failed: Reset did not work. LED = %h", led);
    else $display("Test 1 Passed: Reset succeded.");

    // Test 2: ADD
    sw = 16'h354a;
    btnc = 1; 
    btnd = 1; 
    #10 btnd = 0;
    #10;
    if (led !== 16'h354a) $display("Test 2 Failed: ADD operation failed. LED = %h", led);
    else $display("Test 2 Passed: ADD operation succeeded.");

    // Test 3: SUB 
    sw = 16'h1234;
    btnr = 1; 
    btnd = 1; 
    #10 btnd = 0;
    #10;
    if (led !== 16'h2316) $display("Test 3 Failed: SUB operation failed. LED = %h", led);
    else $display("Test 3 Passed: SUB operation succeeded.");

    // Test 4: OR 
    sw = 16'h1001;
    btnl = 0; btnc = 0; btnr = 1; 
    btnd = 1;
    #10 btnd = 0;
    #10;
    if (led !== 16'h3317) $display("Test 4 Failed: OR operation failed. LED = %h", led);
    else $display("Test 4 Passed: OR operation succeeded.");

    // Test 5: AND 
    sw = 16'hf0f0;
    btnr = 0; 
    btnd = 1;
    #10 btnd = 0;
    #10;
    if (led !== 16'h3010) $display("Test 5 Failed: AND operation failed. LED = %h", led);
    else $display("Test 5 Passed: AND operation succeeded.");

    // Test 6: XOR 
    sw = 16'h1fa2;
    btnl = 1; btnc = 1; btnr = 1; 
    btnd = 1;
    #10 btnd = 0;
    #10;
    if (led !== 16'h2fb2) $display("Test 6 Failed: XOR operation failed. LED = %h", led);
    else $display("Test 6 Passed: XOR operation succeeded.");

    // Test 7: ADD 
    sw = 16'h6aa2;
    btnl = 0; btnc = 1; btnr = 0; 
    btnd = 1;
    #10 btnd = 0;
    #10;
    if (led !== 16'h9a54) $display("Test 7 Failed: ADD operation failed. LED = %h", led);
    else $display("Test 7 Passed: ADD operation succeeded.");

    // Test 8: Logical Shift Left 
    sw = 16'h0004;
    btnl = 1; btnc = 0; btnr = 1; 
    btnd = 1;
    #10 btnd = 0;
    #10;
    if (led !== 16'ha540) $display("Test 8 Failed: Logical Shift Left failed. LED = %h", led);
    else $display("Test 8 Passed: Logical Shift Left succeeded.");

    // Test 9: Shift Right Arithmetic 
    sw = 16'h0001;
    btnl = 1; btnc = 1; btnr = 0; 
    btnd = 1;
    #10 btnd = 0;
    #10;
    if (led !== 16'hd2a0) $display("Test 9 Failed: Shift Right Arithmetic failed. LED = %h", led);
    else $display("Test 9 Passed: Shift Right Arithmetic succeeded.");

    // Test 10: Set Less Than 
    sw = 16'h46ff;
    btnl = 1; btnc = 0; btnr = 0;
    btnd = 1;
    #10 btnd = 0;
    #10;
    if (led !== 16'h0001) $display("Test 10 Failed: Less Than operation failed. LED = %h", led);
    else $display("Test 10 Passed: Less Than operation succeeded.");

 
    $finish;
  end
  
endmodule