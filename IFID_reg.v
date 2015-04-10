// Author: Graham Nygard, Robert Wagner

module IFID_reg(clk, hazard, instruction, PC_in, 
	cntrl_input, branch_cond, reg_rs, reg_rt, 
	reg_rd, arith_imm, load_save_imm, call_target, PC_out);

//INPUTS
input        clk;
input        hazard;        // Stall the pipe for hazards
input [15:0] instruction;   // Instruction to execute
input [15:0] PC_in;         // Program counter

//OUTPUTS
output logic [3:0]  cntrl_input;   // Inst[15:12] - Opcode
output logic [2:0]  branch_cond;   // Inst[10:8]  - Branch condition
output logic [3:0]  reg_rs;        // Inst[7:4]   - Register rs
output logic [3:0]  reg_rt;        // Inst[3:0]   - Register rt
output logic [3:0]  reg_rd;        // Inst[11:8]  - Register rd
output logic [3:0]  arith_imm;     // Inst[3:0]   - Imm of Arithmetic Inst
output logic [7:0]  load_save_imm; // Inst[7:0]   - Imm of Load/Save Inst
output logic [11:0] call_target;   // Inst[11:0]  - Call target
output logic [15:0] PC_out;        // Program counter

//NO OPERATION FOR PIPE STALL
logic [15:0] NO_OP = 16'hF000;

// Pipeline register will be sensitive flopped clock
always @(posedge clk) begin
    
   // Don't stall the pipe
   if (!hazard) begin
   
      // Pass on the PC
      PC_out        <= PC_in;
    
      // Set the input to the control unit
	   cntrl_input   <= instruction[15:12];

      // Specify the src and dest registers
	   reg_rs        <= instruction[7:4];
	   reg_rt        <= instruction[3:0];
	   reg_rd        <= instruction[11:8];
	
	   // Set the immediate fields of instruction
	   arith_imm     <= instruction[3:0];
	   load_save_imm <= instruction[7:0];
	
	   // Set call target
	   call_target   <= instruction[11:0];
	   
	   // Set branch condition
	   branch_cond   <= instruction[10:8];
	   
	end
	
	// Stall the pipe
	else begin
	    
	   // Lock everything
      PC_out        <= PC_out;
    
	   cntrl_input   <= cntrl_input;

	   reg_rs        <= instruction[7:4];
	   reg_rt        <= instruction[3:0];
	   reg_rd        <= instruction[11:8];
	
	   arith_imm     <= arith_imm;
	   load_save_imm <= load_save_imm;
	
	   call_target   <= call_target;
	   
	   branch_cond   <= branch_cond;
	   
	end
	
end

endmodule
