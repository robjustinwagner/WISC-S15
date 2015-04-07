// Author: Graham Nygard, Robert Wagner

module IFID_reg(clk, hazard, PC_in, instruction, reg_rs, reg_rt, reg_rd,
                cntrl_input, arith_imm, load_save_imm, call, PC_out);

//INPUTS
input        clk;
input        hazard;        // Stall the pipe for hazards
input [15:0] instruction;   // Instruction to execute
input [15:0] PC_in;         // Program counter

//OUTPUTS
output logic [3:0]  cntrl_input;   // Inst[15:12] - Opcode
output logic [3:0]  reg_rs;        // Inst[7:4]   - Register rs
output logic [3:0]  reg_rt;        // Inst[3:0]   - Register rt
output logic [3:0]  reg_rd;        // Inst[11:8]  - Register rd
output logic [3:0]  arith_imm;     // Inst[3:0]   - Imm of Arithmetic Inst
output logic [7:0]  load_save_imm; // Inst[7:0]   - Imm of Load/Save Inst
output logic [11:0] call;          // Inst[11:0]  - Call target
output logic [15:0] PC_out;        // Program counter

//INTERNAL CONTROL
logic [3:0]  CI;
logic [3:0]  RS;
logic [3:0]  RT;
logic [3:0]  RD;
logic [3:0]  AI;
logic [7:0]  LSI;
logic [11:0] CALL;
logic [15:0] PC;

//NO OPERATION FOR PIPE STALL
logic [15:0] NO_OP = 16'hF000;

                                           /* YANK THIS OUT TO SEPARATE MODULE
//PIPELINE ENABLE COUNTER
logic [1:0] counter;
logic rst_counter;
logic enable;

//PIPELINE ENABLE COUNTER
always @(posedge clk) begin
   counter <= counter + 1;
end

//ENABLE THE PIPELINE WHEN COUNTER MAXES OUT
assign enable = &counter;
                                             END OF THE YANK */

// Pipeline register will be sensitive flopped clock
always @(posedge clk) begin
    
   // Don't stall the pipe
   if (!hazard) begin
   
      // Pass on the PC
      PC <= PC_in;
    
      // Set the input to the control unit
	   //cntrl_input <= instruction[15:12];
	   CI <= instruction[15:12];

      // Specify the src and dest registers
	   RS <= instruction[7:4];
	   RT <= instruction[3:0];
	   RD <= instruction[11:8];
	
	   // Set the immediate fields of instruction
	   AI  <= instruction[3:0];
	   LSI <= instruction[7:0];
	
	   // Set call target
	   CALL <= instruction[11:0];
	   
	end
	
	// Stall the pipe
	else begin
	    
	   // Lock the PC
      PC <= 16'hzzzz;
    
      // Set the input to the control unit
	   CI <= NO_OP[15:12];

      // Specify the src and dest registers
	   RS <= NO_OP[7:4];
	   RT <= NO_OP[3:0];
	   RD <= NO_OP[11:8];
	
	   // Set the immediate fields of instruction
	   AI  <= NO_OP[3:0];
	   LSI <= NO_OP[7:0];
	
	   // Set call target
	   CALL <= NO_OP[11:0];
	   
	end
	
end

//ASSIGN INTERNAL CONTROLS TO OUTPUT
assign cntrl_input    = CI;
assign reg_rs         = RS;
assign reg_rt         = RT;
assign reg_rd         = RD;
assign arith_imm      = AI;
assign load_save_imm  = LSI;
assign call           = CALL;
assign PC_out         = PC;


endmodule