// Author: Graham Nygard, Robert Wagner

module WISC-S15_top_level(clk, instr);

//INPUTS
input clk;
input [15:0] instr;

/* INTERNAL VARIABLES */
//IF_Unit --> IFID_reg
logic [15:0] PC_out;
logic [15:0] instruction;
//IFID_reg --> ID_Unit
logic [3:0]  cntrl_input;   	// Inst[15:12] - Opcode
logic [3:0]  branch_cond;   	// Inst[11:8]  - Branch condition
logic [3:0]  reg_rs;        	// Inst[7:4]   - Register rs
logic [3:0]  reg_rt;        	// Inst[3:0]   - Register rt
logic [3:0]  reg_rd;        	// Inst[11:8]  - Register rd
logic [3:0]  arith_imm;     	// Inst[3:0]   - Imm of Arithmetic Inst
logic [7:0]  load_save_imm; 	// Inst[7:0]   - Imm of Load/Save Inst
logic [11:0] call;          	// Inst[11:0]  - Call target
logic [15:0] PC_out;        	// Program counter
//ID_Unit --> IDEX_reg 
logic        mem_to_reg;        // LW signal to Memory unit  
logic        reg_to_mem;        // SW signal to Memory unit
logic        alu_src;           // ALU operand selection
logic [2:0]  alu_op;            // ALU control unit input
logic        branch;            // PC Updater signal for branch   
logic        call;              // PC Updater signal for call 
logic        ret;               // PC Updater signal for ret 
logic [15:0] read_data_1;       // Regfile Read_Bus_1
logic [15:0] read_data_2;       // Regfile Read_Bus_2
logic [2:0]  branch_cond_out;   // Branch condition
logic [3:0]  reg_rd_out;        // Future Regfile dest
logic [3:0]  arith_imm_out;     // Imm of Arithmetic Inst
logic [7:0]  load_save_imm_out; // Imm of Load/Save Inst
logic [11:0] call_out;          // Call target
logic [15:0] PC_out;            // Program counter
logic [15:0] sign_ext_out;      // Output of sign extension unit
//IDEX_reg --> EX_Unit
logic        mem_to_reg_out;    // LW signal to Memory unit 
logic        reg_to_mem_out;    // SW signal to Memory unit 
logic [2:0]  branch_out;     	// Branch condition
logic	     alu_src_out;     	// ALU operand 2 seleciton
logic [2:0]  alu_op_out;    	// ALU operation
logic [3:0]  shift_out;         // ALU shift input
logic [7:0]  load_half_imm_out; // ALU imm load input
logic [15:0] rd_data_1_out;     // ALU operand 1
logic [15:0] rd_data_2_out;     // ALU operand 2
logic [15:0] sign_ext_out;   	// ALU operand 2
logic [3:0]  reg_rd_out;        // Future Regfile dest
logic [11:0] call_out;       	// Call target
logic [15:0] PC_out;            // PC for branch/call/ret
//EX_Unit --> EXMEM_reg
logic        mem_to_reg_out; 	// LW signal to Memory unit 
logic        reg_to_mem_out; 	// SW signal to Memory unit
logic        ret_future_out; 	// Future ret_wb signal
logic        PC_update_done; 	// Complete branch/call/ret/ update
logic        PC_src;         	// PC source selection
logic [3:0]  reg_rd_out;     	// Future Regfile dest
logic [15:0] alu_result;     	// Results of ALU operation
logic [15:0] PC_update;      	// Updated PC for branch/call/ret
//EXMEM_reg --> MEM_Unit

//MEMWB_reg --> WB_Unit

//WB_Unit --> IF_Unit


//OUTPUTS


/* INSTANTIATE & CONNECT PIPELINED MODULES */
	
	//stage 1 -- Instruction Fetch Module Unit
	IF_Unit IFU(		.clk(clk), 
				PC_src, 
				PC_branch, 
				hazard, 
				.PC_out(PC_out), 
				.instruction(instruction));	

	//Instruction Fetch/Instruction Decode intermediate register
	IFID_reg IFID_r(	.clk(clk), 
				hazard, 
				.PC_in(PC_out), 
				.instruction(instruction), 
                   		.branch_cond(branch_cond), 
				.reg_rs(reg_rs), 
				.reg_rt(reg_rt), 
				.reg_rd(reg_rt),
                   		.cntrl_input(cntrl_input), 
				.arith_imm(arith_imm), 
				.load_save_imm(load_save_imm), 
                   		.call(call), 
				.PC_out(PC_out));

	//stage 2 -- Instruction Decode Module Unit	
	ID_Unit IDU(		.clk(clk), 
				cntrl_opcode, 
				branch_cond_in, 
				reg_rs, 
				reg_rt,
               			reg_rd_in, 
				reg_rd_out, 
				RegWrite, 
				reg_rd_wb,
               			reg_rd_data, 
				arith_imm_in, 
				load_save_imm_in,
               			call_in, 
				PC_in, 
				PC_out, 
				mem_to_reg, 
				reg_to_mem,
               			alu_op, 
				alu_src, 
				branch, 
				call, 
				ret, 
				read_data_1,
               			read_data_2, 
				arith_imm_out, 
				sign_ext_out,
               			load_save_imm_out, 
				call_out, 
				branch_cond_out);	

	//Instruction Decode/Execution intermediate register	
	IDEX_reg IDEX_r(	.clk(clk), 
				PC_in, 
				mem_to_reg_in, 
				reg_to_mem_in, 
				alu_op_in, 
				alu_src_in, 
				shift_in, 
				sign_ext_in, 
				load_half_imm_in, 
				branch_in, 
				rd_data_1_in, 
				rd_data_2_in, 
				call_in, 
				reg_rd_in,
				PC_out, 
				mem_to_reg_out, 
				reg_to_mem_out, 
				alu_op_out, 
				alu_src_out, 
				shift_out, 
				sign_ext_out, 
				load_half_imm_out, 
				branch_out, 
				rd_data_1_out, 
				rd_data_2_out, 
				call_out, 
				reg_rd_out);	

	//stage 3 -- Execution Module Unit	
	EX_Unit EXU(		.clk(clk), 
				mem_to_reg_in, 
				reg_to_mem_in, 
				branch,ret_wb,
               			PC_stack_pointer, 
				alu_src, 
				alu_op, 
				shift, 
				load_half_imm,
               			rd_data_1, 
				rd_data_2, 
				sign_ext, 
				ret_future_in, 
				reg_rd_in,
               			call_imm, 
				PC_in,
                  		mem_to_reg_out, 
				reg_to_mem_out, 
				reg_rd_out,
                  		ret_future_out, 
				alu_result, 
				PC_update, 
				PC_src,
                  		PC_update_done);	

	//Execution/Memory intermediate register	
	EXMEM_reg EXMEM_r(	.clk(clk),
				);
	
	//stage 4 -- Memory Module Unit	
	MEM_Unit MEMU(		.clk(clk), 
				);	
	
	//Memory/WriteBack intermediate register
	MEMWB_reg MEMWB_r(	.clk(clk),
				);	
	
	//stage 5 -- WriteBack Module Unit
	WB_Unit WBU(		.clk(clk),
				);	

endmodule