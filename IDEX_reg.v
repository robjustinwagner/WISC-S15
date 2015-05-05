// Author: Graham Nygard, Robert Wagner

module IDEX_reg(clk, 
	PC_hazard_in, RegWrite_in, MemWrite_in, MemRead_in, mem_to_reg_in, branch_cond_in, call_target_in, branch_in, call_in, ret_in, 
		alu_src_in, alu_op_in, shift_in, load_half_imm_in, rd_data_1_in, rd_data_2_in, 
		sign_ext_in, reg_rd_in, PC_in, load_half_in, half_spec_in, HALT_in,
	PC_hazard_out, RegWrite_out, MemWrite_out, MemRead_out, mem_to_reg_out, branch_cond_out, call_target_out, branch_out, call_out, ret_out, 
		alu_src_out, alu_op_out, shift_out, load_half_imm_out, rd_data_1_out, rd_data_2_out, 
		sign_ext_out, reg_rd_out, PC_out, load_half_out, half_spec_out, HALT_out);

//////////////////////////INPUTS/////////////////////////////

input clk;

input PC_hazard_in;             // Loop back for call/ret pipe haulting

input RegWrite_in;   
input MemWrite_in;
input MemRead_in;

input mem_to_reg_in;        	// LW signal to Memory unit 

// PC UPDATER INPUTS
input [2:0]  branch_cond_in;   	// Branch condition
input [11:0] call_target_in;  	// Call target

input branch_in;            	// PC Updater signal for branch   
input call_in;              	// PC Updater signal for call 
input ret_in;               	// PC Updater signal for ret 

input alu_src_in;           	// ALU operand source seleciton

input [2:0]  alu_op_in;        	// Desired ALU operation
input [3:0]  shift_in;         	// Imm of Arithmetic Inst
input [7:0]  load_half_imm_in; 	// Imm of Load/Save Inst
input [15:0] rd_data_1_in;     	// Regfile Read_Bus_1
input [15:0] rd_data_2_in;     	// Regfile Read_Bus_2
input [15:0] sign_ext_in;      	// Output of sign_ext unit
	
input [3:0]  reg_rd_in;        	// Future Regfile dest

input [15:0] PC_in;            	// PC for branch/call/ret

input load_half_in;	  	// Specifies the ALU result
input half_spec_in;	  	// (0 -> LHB, 1 -> LLB)

input HALT_in;

//////////////////////////////////////////////////////////////

//////////////////////////OUTPUTS/////////////////////////////

output logic PC_hazard_out;

output logic RegWrite_out;
output logic MemWrite_out;
output logic MemRead_out;

output logic mem_to_reg_out;    	// LW signal to Memory unit 

output logic [2:0]  branch_cond_out;   	// Branch condition
output logic [11:0] call_target_out;   	// Call target

output logic branch_out;        	// PC Updater signal for branch   
output logic call_out;          	// PC Updater signal for call 
output logic ret_out;           	// PC Updater signal for ret 

output logic alu_src_out;       	// ALU operand 2 seleciton

output logic [2:0]  alu_op_out;        	// ALU operation
output logic [3:0]  shift_out;         	// ALU shift input
output logic [7:0]  load_half_imm_out; 	// ALU imm load input
output logic [15:0] rd_data_1_out;     	// ALU operand 1
output logic [15:0] rd_data_2_out;     	// ALU operand 2
output logic [15:0] sign_ext_out;      	// ALU operand 2

output logic [3:0]	 reg_rd_out;	// Future Regfile dest

output logic [15:0]	PC_out;     	// PC for branch/call/ret

output logic load_half_out;		// Specifies the ALU result
output logic half_spec_out;		// (0 -> LHB, 1 -> LLB)

output logic HALT_out;

////////////////////////END OUTPUTS///////////////////////////

always @(posedge clk) begin
	
	HALT_out <= HALT_in;
	
	PC_hazard_out <= PC_hazard_in;

   	RegWrite_out <= RegWrite_in;
   	MemWrite_out <= MemWrite_in;
   	MemRead_out <= MemRead_in;

   	mem_to_reg_out <= mem_to_reg_in;

   	branch_cond_out <= branch_cond_in;
   	call_target_out <= call_target_in;  

   	branch_out <= branch_in;
   	call_out <= call_in;      
   	ret_out <= ret_in;        

   	alu_src_out <= alu_src_in;

   	alu_op_out <= alu_op_in;      
   	shift_out <= shift_in;      
   	load_half_imm_out <= load_half_imm_in;
   	rd_data_1_out <= rd_data_1_in;   
   	rd_data_2_out <= rd_data_2_in;    
   	sign_ext_out <= sign_ext_in;  

   	if (reg_rd_in === 3'bxxx)
      		reg_rd_out <= reg_rd_out;
   	else
      		reg_rd_out <= reg_rd_in;       

   	PC_out <= PC_in;  

   	load_half_out <= load_half_in;
   	half_spec_out <= half_spec_in;
	
end

endmodule
