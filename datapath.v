`include "alu.v"
`include "regfile.v"

`timescale 1ns / 1ps

module datapath # (parameter INITIAL_PC = 32'h00400000)
  (input wire clk, 
   input wire rst, 
   input wire [31:0] instr, 
   input wire PCSrc, 
   input wire ALUSrc,
   input wire RegWrite,
   input wire MemToReg,
   input wire [3:0] ALUCtrl,
   input wire loadPC, 
   output reg [31:0] PC, 
   output reg Zero,
   output reg [31:0] dAddress,
   output reg [31:0] dWriteData,
   input wire [31:0] dReadData,
   output reg [31:0] WriteBackData);
   
  
  // Decoder
  reg [6:0] opcode;              // Opcode field
  reg [2:0] funct3;              // Funct3 field
  reg [6:0] funct7;              // Funct7 field
  reg [4:0] rd;                  // Destination register
  reg [4:0] rs1;                 // Source register 1
  reg [4:0] rs2;                 // Source register 2
  reg [31:0] imm;                // Immediate or shamt
  reg [15:0] command;            // What is the command
  
  
  localparam BEQ  = 16'h0001;
  localparam LW   = 16'h0002;
  localparam SW   = 16'h0003;
  localparam ADDI = 16'h0004;
  localparam SLTI = 16'h0005;
  localparam XORI = 16'h0006;
  localparam ORI  = 16'h0007;
  localparam ANDI = 16'h0008;
  localparam SLLI = 16'h0009;
  localparam SRLI = 16'h000A;
  localparam SRAI = 16'h000B;
  localparam ADD  = 16'h000C;
  localparam SUB  = 16'h000D;
  localparam SLL  = 16'h000E;
  localparam SLT  = 16'h000F;
  localparam XOR  = 16'h0010;
  localparam SRL  = 16'h0011;
  localparam SRA  = 16'h0012;
  localparam OR   = 16'h0013;
  localparam AND  = 16'h0014;  
  
  always @(*) begin
        // Initialize outputs to default values
        opcode = instr[6:0];
        funct3 = 3'b0;
        funct7 = 7'b0;
        rd     = 5'b0;
        rs1    = 5'b0;
        rs2    = 5'b0;
        imm    = 32'b0;
        command = 16'h0000;
      
      

        // Decode instruction based on opcode
        case (opcode)
            7'b1100011: begin // Branch instructions (B-type)
                funct3 = instr[14:12];
                case (funct3)
                    3'b000: begin // BEQ
                        command = BEQ;
                        imm = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0}; // B-type 
                        rs1 = instr[19:15];
                        rs2 = instr[24:20];
                    end
                endcase
            end
            7'b0000011: begin // LW which is I-type
                funct3 = instr[14:12];
                case (funct3)
                    3'b010: begin 
                        command = LW;
                        imm = {{20{instr[31]}}, instr[31:20]}; // I-type immediate
                       
                        rd = instr[11:7];
                        rs1 = instr[19:15];
                    end
                endcase
            end
            7'b0100011: begin // Store instructions (S-type)
                funct3 = instr[14:12];
                case (funct3)
                    3'b010: begin // SW
                        command = SW;
                        imm = {{20{instr[31]}}, instr[31:25], instr[11:7]}; // S-type immediate
                        
                        rs1 = instr[19:15];
                        rs2 = instr[24:20];
                    end
                endcase
            end
            7'b0010011: begin // Immediate arithmetic/logical (I-type)
                funct3 = instr[14:12];
                case (funct3)
                    3'b000: begin // ADDI
                        command = ADDI;
                        imm = {{20{instr[31]}}, instr[31:20]}; // I-type immediate
                        
                        rd = instr[11:7];
                        rs1 = instr[19:15];
                    end
                    3'b010: begin // SLTI
                        command = SLTI;
                        imm = {{20{instr[31]}}, instr[31:20]};
                        
                        rd = instr[11:7];
                        rs1 = instr[19:15];
                    end
                    3'b100: begin // XORI
                        command = XORI;
                        imm = {{20{instr[31]}}, instr[31:20]};
                       
                        rd = instr[11:7];
                        rs1 = instr[19:15];
                    end
                    3'b110: begin // ORI
                        command = ORI;
                        imm = {{20{instr[31]}}, instr[31:20]};
                        
                        rd = instr[11:7];
                        rs1 = instr[19:15];
                    end
                    3'b111: begin // ANDI
                        command = ANDI;
                        imm = {{20{instr[31]}}, instr[31:20]};
                        
                        rd = instr[11:7];
                        rs1 = instr[19:15];
                    end
                    3'b001: begin // SLLI
                        command = SLLI;
                        imm = {27'b0, instr[24:20]}; // Shamt (shift amount)
                        
                        rd = instr[11:7];
                        rs1 = instr[19:15];
                    end
                    3'b101: begin
                        case (instr[31:25]) // Use funct7
                            7'b0000000: begin // SRLI
                                command = SRLI;
                                imm = {27'b0, instr[24:20]}; // Shamt
                                
                                rd = instr[11:7];
                                rs1 = instr[19:15];
                            end
                            7'b0100000: begin // SRAI
                                command = SRAI;
                                imm = {27'b0, instr[24:20]}; // Shamt
                                
                                rd = instr[11:7];
                                rs1 = instr[19:15];
                            end
                        endcase
                    end
                endcase
            end
            7'b0110011: begin // Register arithmetic/logical (R-type)
                funct3 = instr[14:12];
                funct7 = instr[31:25];
                rd     = instr[11:7];
                rs1    = instr[19:15];
                rs2    = instr[24:20];
                case (funct3)
                    3'b000: begin
                        case (funct7)
                            7'b0000000: command = ADD; // ADD
                            7'b0100000: command = SUB; // SUB
                        endcase
                    end
                    3'b001: command = SLL; // SLL
                    3'b010: command = SLT; // SLT
                    3'b100: command = XOR; // XOR
                    3'b101: begin
                        case (funct7)
                            7'b0000000: command = SRL; // SRL
                            7'b0100000: command = SRA; // SRA
                        endcase
                    end
                    3'b110: command = OR; // OR
                    3'b111: command = AND; // AND
                endcase
            end
            default: begin
                command = 16'h0000; // Unknown instruction
            end
        endcase
    end
  
    
  
  
  // Connecting with the register file
  wire [31:0] readData1, readData2;
    
  
  regfile my_regfile(.clk(clk),
                     .readReg1(rs1),
                     .readReg2(rs2),
                     .writeReg(rd),
                     .writeData(WriteBackData),
                     .write(RegWrite),
                     .readData1(readData1),
                     .readData2(readData2));
                     
  // Connecting with the ALU
  wire [31:0] op1, op2;
  
  assign op1 = readData1;
  assign op2 = (ALUSrc == 0) ? readData2 : imm;
  
  wire [31:0] ALUResult;
  
  alu my_alu(.result(ALUResult),
             .zero(Zero),
             .op1(op1),
             .op2(op2),
             .alu_op(ALUCtrl));
  
  
  always @(*) // Some combinational logic (could also use assign and declare them as wires)
    begin      
      // Write Back Data Multiplexer
      WriteBackData = (MemToReg) ? dReadData : ALUResult;
      
      // Connecting the result of the ALU to the adress of the write data to ram 
      dAddress = ALUResult;
      
      // Connecting the data which is read from the reg file to the data that enters the ram 
      dWriteData = readData2;
    end
  
    
  
  always @(posedge clk)
    begin
      
      if (rst == 1)
        begin
          PC <= INITIAL_PC;
        end
      
      
      if (loadPC == 1)
        begin
          
          // Multiplexer for PCSrc
          if (PCSrc == 1) // Branch taken
            begin
              PC <= PC + imm;
            end
          else // Branch not taken
            begin
              PC <= PC + 32'b00000000000000000000000000000100;
            end
          
          
        end      
      
    end
  
  
endmodule