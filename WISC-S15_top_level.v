// Author: Graham Nygard, Robert Wagner

module WISC_S15_top_level(clk, rst);

//INPUTS
input clk;
input rst;
//input [15:0] instr;

/* INTERNAL VARIABLES */
logic rst_g;                     // Global reset for modules
//#1; IF_Unit --> IFID_reg
logic [15:0] PC_out_1;
logic [15:0] instruction_1;
//#2; IFID_reg --> ID_Unit
logic [3:0]  cntrl_input_2;   	  // Inst[15:12] - Opcode
logic [3:0]  branch_cond_2;   	  // Inst[11:8]  - Branch condition
logic [3:0]  reg_rs_2;        	  // Inst[7:4]   - Register rs
logic [3:0]  reg_rt_2;        	  // Inst[3:0]   - Register rt
logic [3:0]  reg_rd_2;        	  // Inst[11:8]  - Register rd
logic [3:0]  arith_imm_2;     	  // Inst[3:0]   - Imm of Arithmetic Inst
logic [7:0]  load_save_imm_2; 	  // Inst[7:0]   - Imm of Load/Save Inst
logic [11:0] call_2;          	  // Inst[11:0]  - Call target
logic [15:0] PC_out_2;        	  // Program counter
//#3; ID_Unit --> IDEX_reg 
logic        RegWrite_out_3;      // Regfile RegWrite when not reset
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
logic [3:0]  arith_imm_out_3;     // Imm of Arithmetic Inst
logic [3:0]  load_save_reg_out_3; // Future Regfile dest
logic [7:0]  load_save_imm_out_3; // Imm of Load/Save Inst
logic [11:0] call_out_3;          // Call target
logic [15:0] PC_out_3;            // Program counter
logic [15:0] sign_ext_out_3;      // Output of sign extension unit
logic	     hazard_3;		  // Hazard signaling for pipe stall
//#4; IDEX_reg --> EX_Unit
logic        RegWrite_out_4;
logic        mem_to_reg_out_4;    // LW signal to Memory unit 
logic        reg_to_mem_out_4;    // SW signal to Memory unit 
logic [2:0]  branch_cond_out_4;   // Branch condition
logic [11:0] call_target_out_4;   // Call target
logic 	     branch_out_4;     	  // PC Updater signal for branch
logic        call_out_4;       	  // Call target
logic	     ret_out_4;		  // PC Updater signal for ret 
logic	     alu_src_out_4;       // ALU operand 2 seleciton
logic [2:0]  alu_op_out_4;    	  // ALU operation
logic [3:0]  shift_out_4;         // ALU shift input
logic [7:0]  load_half_imm_out_4; // ALU imm load input
logic [15:0] rd_data_1_out_4;     // ALU operand 1
logic [15:0] rd_data_2_out_4;     // ALU operand 2
logic [15:0] sign_ext_out_4;   	  // ALU operand 2
logic [3:0]  reg_rd_out_4;        // Future Regfile dest
logic [15:0] PC_out_4;            // PC for branch/call/ret
//#5; EX_Unit --> EXMEM_reg
logic	     call_out_5;
logic	     RegWrite_out_5;
logic        mem_to_reg_out_5; 	  // LW signal to Memory unit 
logic        reg_to_mem_out_5; 	  // SW signal to Memory unit
logic        ret_future_out_5; 	  // Future ret_wb signal
logic        PC_update_done_5; 	  // Complete branch/call/ret/ update
logic        PC_src_5;         	  // PC source selection
logic [3:0]  reg_rd_out_5;     	  // Future Regfile dest
logic [15:0] alu_result_5;     	  // Results of ALU operation
logic [15:0] PC_update_5;      	  // Updated PC for branch/call/ret
logic [15:0] sw_data_5;        	  // Save Word data
//#6; EXMEM_reg --> MEM_Unit
logic	     RegWrite_out_6;
logic	     call_out_6;
logic        mem_to_reg_out_6;     // Memory Read to register 
logic        reg_to_mem_out_6;     // Memory Write from register
logic [3:0]  reg_rd_out_6;         // Destination of Memory Read
logic [15:0] alu_result_out_6;     // Results of ALU operation
logic [15:0] save_word_data_out_6; // Data for Memory Write
logic        ret_future_out_6;	   // Future ret_wb signal
//#7; MEM_Unit --> MEMWB_reg
logic	     RegWrite_out_7;
logic 	     mem_read_data_7;
logic	     mem_to_reg_out_7;
logic 	     reg_rd_out_7;
logic 	     ret_future_out_7;
logic 	     alu_result_out_7;
//#8; MEMWB_reg --> WB_Unit
logic	     RegWrite_out_8;
logic	     ret_out_8;
logic	     mem_to_reg_out_8;
logic 	     mem_read_data_out_8;
logic        reg_rd_out_8;
logic        alu_result_out_8;
//#9; WB_Unit --> IF_Unit
logic        RegWrite_9;        // Regfile signal to write reg_rd_out
logic [3:0]  reg_rd_out_9;      // Register to write return_data
logic [15:0] write_back_data_9; // Data to write back

//OUTPUTS

//RESET CONTROL
always_ff @(posedge clk) begin
    
    if (rst)
       rst_g <= 1'b1;
    else
       rst_g <= 1'b0;
       
end


/* INSTANTIATE & CONNECT PIPELINED MODULES */
	
	//#1; stage 1 -- Instruction Fetch Module Unit
	IF_Unit IFU(		.clk(clk), 
				.rst(rst_g),
				.hazard(hazard_3),
				.PC_src(), 			//FIX THIS
				.PC_branch(), 			//FIX THIS
				
				.PC_out(PC_out_1), 
				.instruction(instruction_1));	

	//#2; Instruction Fetch/Instruction Decode intermediate register
	IFID_reg IFID_r(	.clk(clk), 
				.hazard(hazard_3), 
				.instruction(instruction_1),
				.PC_in(PC_out_1), 

                   		.cntrl_input(cntrl_input_2), 
                   		.branch_cond(branch_cond_2), 
				.reg_rs(reg_rs_2), 
				.reg_rt(reg_rt_2), 
				.reg_rd(reg_rd_2),
				.arith_imm(arith_imm_2), 
				.load_save_imm(load_save_imm_2), 
                   		.call(call_2), 
				.PC_out(PC_out_2));

	//#3; stage 2 -- Instruction Decode Module Unit	
	ID_Unit IDU(		.clk(clk), 
				.rst(rst_g), 
				.RegWrite_in(), 		//FIX THIS
				.reg_rs(reg_rs_2), 
				.reg_rt_arith(), 		//FIX THIS
				.reg_rd_wb(reg_rd_out_9), 
               			.reg_rd_data(write_back_data_9), 
				.cntrl_opcode(cntrl_input_2), 
				.branch_cond_in(branch_cond_2), 
				.arith_imm_in(arith_imm_2), 
				.load_save_reg_in(), 		//FIX THIS
				.load_save_imm_in(load_save_imm_2), 
               			.call_in(call_2),
				.PC_in(PC_out_2),
				.ID_EX_reg_rd(), 		//FIX THIS
				.EX_MEM_reg_rd(),		//FIX THIS 
				.MEM_WB_reg_rd(),		//FIX THIS
				//DEPRICATED??			//FIX THIS
				//.reg_rt(reg_rt_2), 
               			//.reg_rd_in(reg_rd_2), 
				//.RegWrite(RegWrite_9), 
				
				.RegWrite_out(RegWrite_out_3),
				.reg_to_mem(reg_to_mem_3),
				.alu_src(alu_src_3), 
				.alu_op(alu_op_3), 
				.branch(branch_3), 
				.call(call_3), 
				.ret(ret_3), 
				.read_data_1(read_data_1_3),
               			.read_data_2(read_data_2_3), 
				.branch_cond_out(branch_cond_out_3), 
				.load_save_reg_out(load_save_reg_out_3), 
				.arith_imm_out(arith_imm_out_3), 
               			.load_save_imm_out(load_save_imm_out_3), 
				.call_out(call_out_3), 
				.PC_out(PC_out_3), 
				.sign_ext_out(sign_ext_out_3),
				.hazard(hazard_3));

	//#4; Instruction Decode/Execution intermediate register	
	IDEX_reg IDEX_r(	.clk(clk), 
				.RegWrite_in(RegWrite_out_3), 
				.mem_to_reg_in(mem_to_reg_3), 
				.reg_to_mem_in(reg_to_mem_3), 
				.branch_cond_in(), 		//FIX THIS
				.call_target_in(), 		//FIX THIS
				.branch_in(branch_3), 
				.call_in(call_3), 
				.ret_in(), 			//FIX THIS
				.alu_src_in(alu_src_3), 
				.alu_op_in(alu_op_3), 
				.shift_in(), 			//FIX THIS
				.load_half_imm_in(), 		//FIX THIS
				.rd_data_1_in(read_data_1_3), 
				.rd_data_2_in(read_data_2_3), 
				.sign_ext_in(sign_ext_out_3), 
				.reg_rd_in(reg_rd_out_3), 
				.PC_in(PC_out_3), 

				.RegWrite_out(RegWrite_out_4), 
				.mem_to_reg_out(mem_to_reg_out_4), 
				.reg_to_mem_out(reg_to_mem_out_4), 
				.branch_cond_out(branch_cond_out_4), 
				.call_target_out(call_target_out_4), 
				.branch_out(branch_out_4), 
				.call_out(call_out_4), 
				.ret_out(ret_out_4), 
				.alu_src_out(alu_src_out_4), 
				.alu_op_out(alu_op_out_4), 
				.shift_out(shift_out_4), 
				.load_half_imm_out(load_half_imm_out_4), 
				.rd_data_1_out(rd_data_1_out_4), 
				.rd_data_2_out(rd_data_2_out_4), 
				.sign_ext_out(sign_ext_out_4), 
				.reg_rd_out(reg_rd_out_4), 
				.PC_out(PC_out_4));

	//#5; stage 3 -- Execution Module Unit	
	EX_Unit EXU(		.clk(clk), 
				.RegWrite_in(RegWrite_out_4), 
				.mem_to_reg_in(mem_to_reg_out_4), 
				.reg_to_mem_in(reg_to_mem_out_4), 
				.branch_cond(branch_cond_out_4), 
				.call_target(call_target_out_4), 
				.branch(branch_out_4), 
				.call(call_out_4),
				.PC_in(PC_out_4), 
				.ret_future_in(),  		//FIX THIS
				.ret_wb(), 			//FIX THIS
               			.PC_stack_pointer(), 	 	//FIX THIS
				.alu_src(alu_src_out_4), 
				.alu_op(alu_op_out_4), 
				.shift(shift_out_4), 
				.load_half_imm(load_half_imm_out_4), 
               			.rd_data_1(rd_data_1_out_4), 
				.rd_data_2(rd_data_2_out_4), 
				.sign_ext(sign_ext_out_4), 
				.reg_rd_in(reg_rd_out_4), 

				.call_out(call_out_5), 
				.RegWrite_out(RegWrite_out_5), 
                  		.mem_to_reg_out(mem_to_reg_out_5), 
				.reg_to_mem_out(reg_to_mem_out_5), 
                  		.ret_future_out(ret_future_out_5), 
				.reg_rd_out(reg_rd_out_5), 
				.PC_update_done(PC_update_done_5), 
				.PC_src(PC_src_5),
				.alu_result(alu_result_5), 
				.PC_update(PC_update_5), 
				.sw_data(sw_data_5));	

	//#6; Execution/Memory intermediate register	
	EXMEM_reg EXMEM_r(	.clk(clk), 
				.RegWrite_in(RegWrite_out_5), 
				.call_in(call_out_5), 
				.mem_to_reg_in(mem_to_reg_out_5), 
				.reg_to_mem_in(reg_to_mem_out_5), 
                 		.reg_rd_in(reg_rd_out_5), 
				.alu_result_in(alu_result_5), 
                 		.save_word_data_in(sw_data_5), 
				.ret_future_in(ret_future_out_5),
				
				.RegWrite_out(RegWrite_out_6), 
				.call_out(call_out_6), 
                    		.mem_to_reg_out(mem_to_reg_out_6), 
				.reg_to_mem_out(reg_to_mem_out_6),
                    		.reg_rd_out(reg_rd_out_6), 
				.alu_result_out(alu_result_out_6), 
                		.save_word_data_out(save_word_data_out_6), 
				.ret_future_out(ret_future_out_6));
	
	//#7; stage 4 -- Memory Module Unit	
	MEM_Unit MEMU(		.clk(clk), 
				.call_in(call_out_6), 
				.RegWrite_in(RegWrite_out_6), 		
				.mem_to_reg_in(mem_to_reg_out_6), 
				.reg_to_mem(reg_to_mem_out_6), 
				.reg_rd_in(reg_rd_out_6), 
   	 		        .alu_result_in(alu_result_out_6), 
				.mem_write_data(), 		//FIX THIS
				.ret_future_in(ret_future_out_6), 

				.RegWrite_out(RegWrite_out_7), 
				.ret_future_out(ret_future_out_7), 
				.mem_to_reg_out(mem_to_reg_out_7), 
				.reg_rd_out(reg_rd_out_7), 
                   		.mem_read_data(mem_read_data_7), 
                   		.alu_result_out(alu_result_out_7));

	//#8; Memory/WriteBack intermediate register
	MEMWB_reg MEMWB_r(	.clk(clk), 
				.RegWrite_in(RegWrite_out_7), 
				.ret_in(), 			//FIX THIS
				.mem_to_reg_in(), 		//FIX THIS
				.reg_rd_in(reg_rd_out_7), 
				.mem_read_data_in(alu_result_out_7), 
				.alu_result_in(alu_result_out_7), 
				
				.RegWrite_out(RegWrite_out_8), 
				.ret_out(ret_out_8), 
				.mem_to_reg_out(mem_to_reg_out_8), 
				.reg_rd_out(reg_rd_out_8), 
				.mem_read_data_out(mem_read_data_out_8), 
				.alu_result_out(alu_result_out_8);
	
	//#9; stage 5 -- WriteBack Module Unit
	WB_Unit WBU(		.clk(clk), 
				.mem_read_data(mem_read_data_out_8),
				.alu_result(alu_result_out_8),  
				.mem_to_reg(), 			//FIX THIS
				.reg_rd_in(reg_rd_out_8),  

				.write_back_data(write_back_data_9), 
				.reg_rd_out(reg_rd_out_9), 
				.RegWrite(RegWrite_9));	

endmodule
