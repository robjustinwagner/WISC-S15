// Author: Graham Nygard, Robert Wagner

module IFID_reg(clk, data_hazard, PC_hazard, instruction_in, PC_in, 
		branch_cond, reg_rs, reg_rt, call, ret_control, ret_PC,
		reg_rd, arith_imm, load_save_imm, call_target, PC_out, instruction_out);

//////////////////////////////INPUTS///////////////////////////////////

input clk;
input call;		// Sets a stall when a call instruction is in the pipe
input ret_control; 	// Sets a stall when a return instruction is in the pipe
input ret_PC; 		/* Resets a stall when the Stack Pointer is ready 
			   to update the PC */

input data_hazard;        
input PC_hazard;

input [15:0] instruction_in;   	// Instruction to execute
input [15:0] PC_in;         	// Program counter

///////////////////////////////////////////////////////////////////////

//////////////////////////////OUTPUTS//////////////////////////////////

output logic [2:0]  branch_cond;   	// Inst[10:8]  - Branch condition
output logic [3:0]  reg_rs;        	// Inst[7:4]   - Register rs
output logic [3:0]  reg_rt;        	// Inst[3:0]   - Register rt
output logic [3:0]  reg_rd;        	// Inst[11:8]  - Register rd
output logic [3:0]  arith_imm;     	// Inst[3:0]   - Imm of Arithmetic Inst
output logic [7:0]  load_save_imm; 	// Inst[7:0]   - Imm of Load/Save Inst
output logic [11:0] call_target;   	// Inst[11:0]  - Call target
output logic [15:0] PC_out;        	// Program counter
output logic [15:0] instruction_out;   	// Used for halting

///////////////////////////////////////////////////////////////////////

//NO OPERATION FOR PIPE STALL
logic [15:0] NO_OP = 16'hF000;
logic ret_halt;
//logic hazard;

/*
// Pipeline stall on hazard
always_comb begin
    
    hazard = (data_hazard | PC_hazard);
    
end
*/

// Pipeline register will be sensitive flopped clock
always @(posedge clk) begin
    
   // Don't stall the pipe
   if (!data_hazard & !call & !ret_control) begin
   
   	// Pass on the PC
      	PC_out        <= PC_in;

      	// Specify the src and dest registers
	reg_rs        <= instruction_in[7:4];
	reg_rt        <= instruction_in[3:0];
	reg_rd        <= instruction_in[11:8];
	
	// Set the immediate fields of instruction
	arith_imm     <= instruction_in[3:0];
	load_save_imm <= instruction_in[7:0];
	
	// Set call target
	call_target   <= instruction_in[11:0];
	   
	// Set branch condition
	branch_cond   <= instruction_in[10:8];

   end
	
   // Stall the pipe
   else begin
	    
	// Lock everything
	PC_out        <= PC_out;

	reg_rs        <= reg_rs;
	reg_rt        <= reg_rt;
	reg_rd        <= reg_rd;
	
	arith_imm     <= arith_imm;
	load_save_imm <= load_save_imm;
	
	call_target   <= call_target;
	   
	branch_cond   <= branch_cond;
	   
   end

end

/* Flop for haulting the pipe appropriately
   during the various types of halts */
always @(posedge clk) begin
	    
	if (PC_hazard | call | ret_halt) begin
	        instruction_out <= NO_OP;
	end
	else if (data_hazard) begin
	        instruction_out <= instruction_out;
	end
	else begin
	        instruction_out <= instruction_in;
	end
end

/* Flop for controlling the return halt 
   signal during a return instrcutions */
always @(posedge clk) begin
	    
	if (ret_PC) begin
		ret_halt <= 1'b0;
     	end
	else if (ret_control) begin
	        ret_halt <= 1'b1;
	end
	else begin
	        ret_halt <= ret_halt;
	end
end

endmodule
