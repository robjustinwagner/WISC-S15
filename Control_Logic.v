// Author: Graham Nygard, Robert Wagner

module Control_Logic(opcode, RegDst, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite)

//INPUTS
input [3:0] opcode;   //the 4-bit instruction opcode

//OUTPUTS
//mux control signals
output reg RegDst;   //register destination
output reg ALUSrc;   //ALU source
output reg MemtoReg;   //
//controlling reads/writes in the reg file & data mem
output reg RegWrite;
output reg MemWrite;
output reg MemRead;
//branch control
output reg Branch;   //whether we are branching  
//ALU control signal
output reg [3:0] ALUOp;






endmodule