// Author: Graham Nygard, Robert Wagner

module WISC_S15_top_level(clk, instr);

//INPUTS
input clk;
input [15:0] instr;

/* INTERNAL VARIABLES */
//IF_Unit --> IFID_reg
logic [15:0] PC_out_1;
logic [15:0] instruction_1;
//IFID_reg --> ID_Unit
logic [3:0]  cntrl_input_2;   	  // Inst[15:12] - Opcode
logic [3:0]  branch_cond_2;   	  // Inst[11:8]  - Branch condition
logic [3:0]  reg_rs_2;        	  // Inst[7:4]   - Register rs
logic [3:0]  reg_rt_2;        	  // Inst[3:0]   - Register rt
logic [3:0]  reg_rd_2;        	  // Inst[11:8]  - Register rd
logic [3:0]  arith_imm_2;     	  // Inst[3:0]   - Imm of Arithmetic Inst
logic [7:0]  load_save_imm_2; 	  // Inst[7:0]   - Imm of Load/Save Inst
logic [11:0] call_2;          	  // Inst[11:0]  - Call target
logic [15:0] PC_out_2;        	  // Program counter
//ID_Unit --> IDEX_reg 
logic        mem_to_reg_3;        // LW signal to Memory unit  
logic        reg_to_mem_3;        // SW signal to Memory unit
logic        alu_src_3;           // ALU operand selection
logic [2:0]  alu_op_3;            // ALU control unit input
logic        branch_3;            // PC Updater signal for branch   
logic        call_3;              // PC Updater signal for call 
logic        ret_3;               // PC Updater signal for ret 
logic [15:0] read_data_1_3;       // Regfile Read_Bus_1
logic [15:0] read_data_2_3;       // Regfile Read_Bus_2
logic [2:0]  branch_cond_out_3;   // Branch condition
logic [3:0]  reg_rd_out_3;        // Future Regfile dest
logic [3:0]  arith_imm_out_3;     // Imm of Arithmetic Inst
logic [7:0]  load_save_imm_out_3; // Imm of Load/Save Inst
logic [11:0] call_out_3;          // Call target
logic [15:0] PC_out_3;            // Program counter
logic [15:0] sign_ext_out_3;      // Output of sign extension unit
//IDEX_reg --> EX_Unit
logic        mem_to_reg_out_4;    // LW signal to Memory unit 
logic        reg_to_mem_out_4;    // SW signal to Memory unit 
logic [2:0]  branch_out_4;     	  // Branch condition
logic	     alu_src_out_4;       // ALU operand 2 seleciton
logic [2:0]  alu_op_out_4;    	  // ALU operation
logic [3:0]  shift_out_4;         // ALU shift input
logic [7:0]  load_half_imm_out_4; // ALU imm load input
logic [15:0] rd_data_1_out_4;     // ALU operand 1
logic [15:0] rd_data_2_out_4;     // ALU operand 2
logic [15:0] sign_ext_out_4;   	  // ALU operand 2
logic [3:0]  reg_rd_out_4;        // Future Regfile dest
logic [11:0] call_out_4;       	  // Call target
logic [15:0] PC_out_4;            // PC for branch/call/ret
//EX_Unit --> EXMEM_reg
logic        mem_to_reg_out_5; 	  // LW signal to Memory unit 
logic        reg_to_mem_out_5; 	  // SW signal to Memory unit
logic        ret_future_out_5; 	  // Future ret_wb signal
logic        PC_update_done_5; 	  // Complete branch/call/ret/ update
logic        PC_src_5;         	  // PC source selection
logic [3:0]  reg_rd_out_5;     	  // Future Regfile dest
logic [15:0] alu_result_5;     	  // Results of ALU operation
logic [15:0] PC_update_5;      	  // Updated PC for branch/call/ret
//EXMEM_reg --> MEM_Unit

//MEMWB_reg --> WB_Unit

//WB_Unit --> IF_Unit


//OUTPUTS


/* INSTANTIATE & CONNECT PIPELINED MODULES */
	
	//#1; stage 1 -- Instruction Fetch Module Unit
	IF_Unit IFU(		.clk(clk), 
				.PC_src(), 			//FIX THIS
				.PC_branch(), 			//FIX THIS
				.hazard(), 			//FIX THIS

				.PC_out(PC_out_1), 
				.instruction(instruction_1));	

	//#2; Instruction Fetch/Instruction Decode intermediate register
	IFID_reg IFID_r(	.clk(clk), 
				.hazard(), 			//FIX THIS
				.PC_in(PC_out_1), 
				.instruction(instruction_1), 

                   		.branch_cond(branch_cond_2), 
				.reg_rs(reg_rs_2), 
				.reg_rt(reg_rt_2), 
				.reg_rd(reg_rd_2),
                   		.cntrl_input(cntrl_input_2), 
				.arith_imm(arith_imm_2), 
				.load_save_imm(load_save_imm_2), 
                   		.call(call_2), 
				.PC_out(PC_out_2));

	//#3; stage 2 -- Instruction Decode Module Unit	
	ID_Unit IDU(		.clk(clk), 
				.cntrl_opcode(cntrl_input_2), 
				.branch_cond_in(branch_cond_2), 
				.reg_rs(reg_rs_2), 
				.reg_rt(reg_rt_2), 
               			.reg_rd_in(reg_rd_2), 
				.RegWrite(), 			//FIX THIS
				.reg_rd_wb(), 			//FIX THIS
               			.reg_rd_data(), 		//FIX THIS
				.arith_imm_in(arith_imm_2), 
				.load_save_imm_in(load_save_imm_2), 
               			.call_in(call_2),
				.PC_in(PC_out_2),

				.PC_out(PC_out_3), 
				.reg_rd_out(reg_rd_out_3),
				.mem_to_reg(mem_to_reg_3), 
				.reg_to_mem(reg_to_mem_3),
               			.alu_op(alu_op_3), 
				.alu_src(alu_src_3), 
				.branch(branch_3), 
				.call(call_3), 
				.ret(ret_3), 
				.read_data_1(read_data_1_3),
               			.read_data_2(read_data_2_3), 
				.arith_imm_out(arith_imm_out_3), 
				.sign_ext_out(sign_ext_out_3),
               			.load_save_imm_out(load_save_imm_out_3), 
				.call_out(call_out_3), 
				.branch_cond_out(branch_cond_out_3));

	//#4; Instruction Decode/Execution intermediate register	
	IDEX_reg IDEX_r(	.clk(clk), 
				.PC_in(), 
				.mem_to_reg_in(), 
				.reg_to_mem_in(), 
				.alu_op_in(), 
				.alu_src_in(), 
				.shift_in(), 
				.sign_ext_in(), 
				.load_half_imm_in(), 
				.branch_in(), 
				.rd_data_1_in(), 
				.rd_data_2_in(), 
				.call_in(), 
				.reg_rd_in(),
				.PC_out(), 
				.mem_to_reg_out(), 
				.reg_to_mem_out(), 
				.alu_op_out(), 
				.alu_src_out(), 
				.shift_out(), 
				.sign_ext_out(), 
				.load_half_imm_out(), 
				.branch_out(), 
				.rd_data_1_out(), 
				.rd_data_2_out(), 
				.call_out(), 
				.reg_rd_out());	

	//#5; stage 3 -- Execution Module Unit	
	EX_Unit EXU(		.clk(clk), 
				.mem_to_reg_in(), 
				.reg_to_mem_in(), 
				.branch(),
				.ret_wb(),
               			.PC_stack_pointer(), 
				.alu_src(), 
				.alu_op(), 
				.shift(), 
				.load_half_imm(),
               			.rd_data_1(), 
				.rd_data_2(), 
				.sign_ext(), 
				.ret_future_in(), 
				.reg_rd_in(),
               			.call_imm(), 
				.PC_in(),
                  		.mem_to_reg_out(), 
				.reg_to_mem_out(), 
				.reg_rd_out(),
                  		.ret_future_out(), 
				.alu_result(), 
				.PC_update(), 
				.PC_src(),
                  		.PC_update_done());	

	//#6; Execution/Memory intermediate register	
	EXMEM_reg EXMEM_r(	.clk(clk),
				);
	
	//#7; stage 4 -- Memory Module Unit	
	MEM_Unit MEMU(		.clk(clk), 
				);	
	
	//#8; Memory/WriteBack intermediate register
	MEMWB_reg MEMWB_r(	.clk(clk),
				);	
	
	//#9; stage 5 -- WriteBack Module Unit
	WB_Unit WBU(		.clk(clk),
				);	

endmodule