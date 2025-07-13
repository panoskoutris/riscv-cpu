`include "datapath.v"

`timescale 1ns / 1ps

module top_proc # (parameter INITIAL_PC = 32'h00400000)
  (input wire clk, 
   input wire rst, 
   input wire [31:0] instr, 
   input wire [31:0] dReadData, 
   output reg [31:0] PC, 
   output wire [31:0] dAddress, 
   output wire [31:0] dWriteData, 
   output reg MemRead,
   output reg MemWrite,
   output wire [31:0] WriteBackData); 
  
  
  // Decoder
  reg [6:0] opcode;              // Opcode field
  reg [2:0] funct3;              // Funct3 field
  reg [6:0] funct7;              // Funct7 field
  reg [4:0] rd;                  // Destination register
  reg [4:0] rs1;                 // Source register 1
  reg [4:0] rs2;                 // Source register 2
  reg [31:0] imm;                // Immediate or shamt
  reg [15:0] command;             // What is the command  
              
  
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
  
  // Connecting with the datapath
  reg PCSrc, ALUSrc, RegWrite, MemToReg, loadPC;
  wire Zero;
  reg [3:0] ALUCtrl;
  
  datapath #(.INITIAL_PC(INITIAL_PC)) my_datapath
   (.clk(clk),
    .rst(rst),
    .instr(instr),
    .PCSrc(PCSrc),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .MemToReg(MemToReg),
    .ALUCtrl(ALUCtrl), 
    .loadPC(loadPC),
    .PC(PC),
    .Zero(Zero), 
    .dAddress(dAddress),
    .dWriteData(dWriteData),
    .dReadData(dReadData),
    .WriteBackData(WriteBackData));
 
  
  // The 5 states of the FSM
  localparam [2:0] IF = 3'b000;  
  localparam [2:0] ID = 3'b001; 
  localparam [2:0] EX = 3'b010; 
  localparam [2:0] MEM = 3'b011; 
  localparam [2:0] WB = 3'b100; 
  
  reg [2:0] state;
   
  
  always @(posedge clk)
    begin
      

      
      if(rst)
        begin
          loadPC <= 0;
          PCSrc <= 0;
          RegWrite <= 0;          
          MemRead <= 0;
          MemWrite <= 0;
          
          state <= IF;
        end
      else
        begin
          
          case (state)
            
            IF: begin
              loadPC <= 0;
              RegWrite <= 0;             
              MemRead <= 0;
              MemWrite <= 0;
              
              state <= ID;
            end
            
            ID: begin
              loadPC <= 0;
              RegWrite <= 0;
              MemRead <= 0;
              MemWrite <= 0;
              
              state <= EX;
            end
            
            EX: begin 
              loadPC <= 0;
              RegWrite <= 0;
              MemRead <= 0;
              MemWrite <= 0;
              
              state <= MEM;
            end
            
            MEM: begin
              
              loadPC <= 0;
              RegWrite <= 0;
                        
              case (command)
                SW: MemWrite <= 1;
                LW: MemRead <= 1;
                default: begin
                  MemRead <= 0;
                  MemWrite <= 0; end
              endcase
              
              state <= WB;             
            end
            
            WB: begin
              
              loadPC <= 1;
              MemRead <= 0;
              MemWrite <= 0;
              
              case (command)
                SW, BEQ: RegWrite <= 0;
                default: RegWrite <= 1;
              endcase
              
              state <= IF;              
            end
            
            default: begin
              loadPC <= 0;
              RegWrite <= 0;
              MemRead <= 0;
              MemWrite <= 0;
              
              state <= IF;
            end
            
          endcase
        end     
      
    end
  
  always @(*)
    begin
      
      // ALUCtrl: We have added command from the decoder so we directly use it for cases
      case (command)        
        LW, SW: ALUCtrl = 4'b0010;
        BEQ: ALUCtrl = 4'b0110;
        ADD, ADDI: ALUCtrl = 4'b0010;
        SUB: ALUCtrl = 4'b0110;
        AND, ANDI: ALUCtrl = 4'b0000;
        OR, ORI: ALUCtrl = 4'b0001;
        XOR, XORI: ALUCtrl = 4'b0101;
        SLT, SLTI: ALUCtrl = 4'b0100;
        SLL, SLLI: ALUCtrl = 4'b1001;
        SRL, SRLI: ALUCtrl = 4'b1000;
        SRA, SRAI: ALUCtrl = 4'b1010;
        default:  ALUCtrl = 4'b0000;
      endcase
      
      // ALUSrc      
      case (command)
        LW, SW, ADDI, ANDI, ORI, XORI, SLTI, SLLI, SRLI, SRAI: ALUSrc = 1;
        default: ALUSrc = 0;
      endcase
      
      // MemToReg
      if (command == LW)
        MemToReg = 1;
      else
        MemToReg = 0;
      
      // PCSrc
      if (command == BEQ && Zero == 1)
        PCSrc = 1;
      else
        PCSrc = 0;
            
    end
                       
                       
                       
                       
                       
                       
  
  
endmodule