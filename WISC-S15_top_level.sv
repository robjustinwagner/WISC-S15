// Author: Graham Nygard, Robert Wagner

`include "IF_Unit.sv"
`include "IFID_reg.sv"
`include "ID_Unit.sv"
`include "IDEX_reg.sv"
`include "EX_Unit.sv"
`include "EXMEM_reg.sv"
`include "MEM_Unit.sv"
`include "MEMWB_reg.sv"
`include "WB_Unit.sv"

//`include "icache_def.sv"
import icache_def::*;

module WISC_S15_top_level(clk, rst, HALT);

//INPUTS
input clk;
input rst;
//input [15:0] instr;
output reg HALT;

/* INTERNAL VARIABLES */
logic rst_g;                      // Global reset for modules
//#1; IF_Unit --> IFID_reg
       mem_req_type mem_req_1;
logic [15:0] PC_out_1;
logic [15:0] instruction_out_1;
logic        PC_hazard_1;
//#2; IFID_reg --> ID_Unit
logic [3:0]  cntrl_input_2;   	  // Inst[15:12] - Opcode
logic [2:0]  branch_cond_2;   	  // Inst[11:8]  - Branch condition
logic [3:0]  reg_rs_2;        	  // Inst[7:4]   - Register rs
logic [3:0]  reg_rt_2;        	  // Inst[3:0]   - Register rt
logic [3:0]  reg_rd_2;        	  // Inst[11:8]  - Register rd
logic [3:0]  arith_imm_2;     	  // Inst[3:0]   - Imm of Arithmetic Inst
logic [7:0]  load_save_imm_2; 	  // Inst[7:0]   - Imm of Load/Save Inst
logic [11:0] call_target_2;      // Inst[11:0]  - Call target
logic [15:0] PC_out_2;        	  // Program counter
logic [15:0] instruction_out_2;  
//#3; ID_Unit --> IDEX_reg 
logic        RegWrite_out_3;      // Regfile RegWrite when not reset
logic        MemWrite_out_3;      // SW signal to Memory unit
logic        MemRead_out_3;       // LW signal to Memory unit 
logic        mem_to_reg_3;               
logic        alu_src_3;           // ALU operand selection
logic [2:0]  alu_op_3;            // ALU control unit input
logic        branch_3;            // PC Updater signal for branch   
logic        call_3;              // PC Updater signal for call 
logic        ret_3;               // PC Updater signal for ret 
logic	     load_half_out_3;	  // Specifies the ALU result
logic	     half_spec_out_3;	  // (0 -> LHB, 1 -> LLB)
logic [15:0] read_data_1_3;       // Regfile Read_Bus_1
logic [15:0] read_data_2_3;       // Regfile Read_Bus_2
logic [2:0]  branch_cond_out_3;   // Branch condition
logic [3:0]  arith_imm_out_3;     // Imm of Arithmetic Inst
logic [3:0]  load_save_reg_out_3; // Future Regfile dest
logic [7:0]  load_save_imm_out_3; // Imm of Load/Save Inst
logic [11:0] call_target_out_3;   // Call target
logic [15:0] PC_out_3;            // Program counter
logic [15:0] sign_ext_out_3;      // Output of sign extension unit
logic	     data_hazard_3;		  // Hazard signaling for pipe stall
logic      PC_hazard_3;
logic      HALT_3;
//#4; IDEX_reg --> EX_Unit
logic        RegWrite_out_4;
logic        MemWrite_out_4;      // SW signal to Memory unit
logic        MemRead_out_4;       // LW signal to Memory unit 
logic        mem_to_reg_out_4;    
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
logic	     load_half_out_4;	  // Specifies the ALU result
logic	     half_spec_out_4;	  // (0 -> LHB, 1 -> LLB)
logic      PC_hazard_4;
logic      HALT_4;
//PC_update and Flag_reg
logic     [2:0] updated_flags; 
logic		ret_PC;

//#5; EX_Unit --> EXMEM_reg
logic	     call_out_5;
logic	     RegWrite_out_5;
logic        MemWrite_out_5;      // SW signal to Memory unit
logic        MemRead_out_5;       // LW signal to Memory unit 
logic        mem_to_reg_out_5;   
logic        ret_future_out_5; 	  // Future ret_wb signal
logic        PC_update_done_5; 	  // Complete branch/call/ret/ update
logic        PC_src_5;         	  // PC source selection
logic [3:0]  reg_rd_out_5;     	  // Future Regfile dest
logic [15:0] alu_result_5;     	  // Results of ALU operation
logic [15:0] PC_update_5;      	  // Updated PC for branch/call/ret
logic [15:0] sw_data_5;        	  // Save Word data
logic      HALT_5;
logic      alu_done;
logic [2:0] set_flags;
//#6; EXMEM_reg --> MEM_Unit
logic	     RegWrite_out_6;
logic        MemWrite_out_6;      // SW signal to Memory unit
logic        MemRead_out_6;       // LW signal to Memory unit 
logic        mem_to_reg_out_6;   
logic	     call_out_6;
logic [3:0]  reg_rd_out_6;         // Destination of Memory Read
logic [15:0] alu_result_out_6;     // Results of ALU operation
logic [15:0] save_word_data_out_6; // Data for Memory Write
logic        ret_future_out_6;	   // Future ret_wb signal
logic      HALT_6;
//#7; MEM_Unit --> MEMWB_reg
logic	     RegWrite_out_7; 
logic        mem_to_reg_out_7;
logic 	     ret_future_out_7;
logic 	     [3:0] reg_rd_out_7;
logic 	     [15:0] mem_read_data_out_7;
logic 	     [15:0] alu_result_out_7;
         mem_data_type mem_data_res_7;
logic      HALT_7;
//#8; MEMWB_reg --> WB_Unit
logic	     RegWrite_out_8;
logic	     ret_out_8;
logic	     mem_to_reg_out_8;
logic 	     [15:0] mem_read_data_out_8;
logic        [3:0] reg_rd_out_8;
logic        [15:0] alu_result_out_8;
logic      HALT_8;
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
				.data_hazard(data_hazard_3),
				.PC_hazard(PC_hazard_3),
				.PC_src(PC_src_5), 
				.PC_ret(ret_PC),
				.PC_branch(PC_update_5), 
				.mem_data_res(mem_data_res_7), 
				
				.mem_req(mem_req_1), 
				.PC_out(PC_out_1), 
				.instruction(instruction_out_1),
				.PC_hazard_ff(PC_hazard_1));	

	//#2; Instruction Fetch/Instruction Decode intermediate register
	IFID_reg IFID_r(	.clk(clk), 
	         		.call(call_3),
				.ret_control(ret_3),
				.ret_PC(ret_PC),
				.data_hazard(data_hazard_3), 
				.PC_hazard(PC_hazard_3),
				.instruction_in(instruction_out_1),
				.PC_in(PC_out_1),

          			.branch_cond(branch_cond_2), 
				.reg_rs(reg_rs_2), 
				.reg_rt(reg_rt_2), 
				.reg_rd(reg_rd_2),
				.arith_imm(arith_imm_2), 
				.load_save_imm(load_save_imm_2), 
          			.call_target(call_target_2), 
				.PC_out(PC_out_2),
				.instruction_out(instruction_out_2));

	//#3; stage 2 -- Instruction Decode Module Unit	
	ID_Unit IDU(		.clk(clk), 
				.rst(rst_g), 
				.PC_update(PC_update_done_5),
				.PC_hazard_in(PC_hazard_4),
				.branch_in(branch_out_4),
				.instruction(instruction_out_2),
				.RegWrite_in(RegWrite_out_8), 
				.reg_rs(reg_rs_2), 
				.reg_rt_arith(reg_rt_2), 
				.reg_rd_wb(reg_rd_out_9), 
         			.reg_rd_data(write_back_data_9),
				.branch_cond_in(branch_cond_2), 
				.arith_imm_in(arith_imm_2), 
				.load_save_reg_in(reg_rd_2), 
				.load_save_imm_in(load_save_imm_2), 
         			.call_target_in(call_target_2),
				.PC_in(PC_out_2),
				.ID_EX_reg_rd(reg_rd_out_4), 
				.EX_MEM_reg_rd(reg_rd_out_6), 
				.MEM_WB_reg_rd(reg_rd_out_8), 
				.HALT_in(HALT),
				
				.RegWrite_out(RegWrite_out_3),
				.MemWrite_out(MemWrite_out_3),
            			.MemRead_out(MemRead_out_3),     
				.mem_to_reg(mem_to_reg_3), 
				.alu_src(alu_src_3), 
				.alu_op(alu_op_3), 
				.branch(branch_3), 
				.call(call_3), 
				.ret(ret_3), 
				.load_half(load_half_out_3), 
				.half_spec(half_spec_out_3), 
				.read_data_1(read_data_1_3),
         			.read_data_2(read_data_2_3), 
				.branch_cond_out(branch_cond_out_3), 
				.load_save_reg_out(load_save_reg_out_3), 
				.arith_imm_out(arith_imm_out_3), 
         			.load_save_imm_out(load_save_imm_out_3), 
				.call_target_out(call_target_out_3), 
				.PC_out(PC_out_3), 
				.sign_ext_out(sign_ext_out_3),
				.data_hazard(data_hazard_3),
				.PC_hazard_out(PC_hazard_3),
				.HALT_out(HALT_3));

	//#4; Instruction Decode/Execution intermediate register	
	IDEX_reg IDEX_r(	.clk(clk), 
				.RegWrite_in(RegWrite_out_3),
				.MemWrite_in(MemWrite_out_3),
            			.MemRead_in(MemRead_out_3),     
				.mem_to_reg_in(mem_to_reg_3), 
				.branch_cond_in(branch_cond_out_3), 
				.call_target_in(call_target_out_3), 
				.branch_in(branch_3), 
				.call_in(call_3), 
				.ret_in(ret_3), 
				.alu_src_in(alu_src_3), 
				.alu_op_in(alu_op_3), 
				.shift_in(arith_imm_out_3), 
				.load_half_imm_in(load_save_imm_out_3), 
				.rd_data_1_in(read_data_1_3), 
				.rd_data_2_in(read_data_2_3), 
				.sign_ext_in(sign_ext_out_3), 
				.reg_rd_in(load_save_reg_out_3), 
				.PC_in(PC_out_3), 
				.load_half_in(load_half_out_3), 
				.half_spec_in(half_spec_out_3), 
				.PC_hazard_in(PC_hazard_3),
				.HALT_in(HALT_3),

            .PC_hazard_out(PC_hazard_4),
				.RegWrite_out(RegWrite_out_4),
				.MemWrite_out(MemWrite_out_4),
            .MemRead_out(MemRead_out_4),      
				.mem_to_reg_out(mem_to_reg_out_4), 
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
				.PC_out(PC_out_4), 
				.load_half_out(load_half_out_4), 
				.half_spec_out(half_spec_out_4),
				.HALT_out(HALT_4));

   // Intermediate module PC_update -- used for updating the PC on branch, call, and return
   PC_Update PCU(.PC_in(PC_out_1), 
                 .PC_stack_pointer(mem_read_data_out_8), 
                 .alu_done(alu_done), 
                 .flags(updated_flags), 
                 .call_target(call_target_out_3), 
                 .sign_ext(sign_ext_out_3),
                 .branch_cond(branch_cond_out_3),
                 .branch(branch_3), 
                 .call(call_3), 
                 .ret_in(ret_out_8),
                 
                 .PC_update(PC_update_5), 
                 .PC_src(PC_src_5), 
                 .update_done(PC_update_done_5),
		 .ret_out(ret_PC));
   
   // Flags reg set by the ALU           
   Flag_reg  flags(.clk(clk), 
                   .en(alu_done), 
                   .d(set_flags), 
                   .q(updated_flags));

	//#5; stage 3 -- Execution Module Unit	
	EX_Unit EXU(		.clk(clk), 
				.RegWrite_in(RegWrite_out_4),
				.MemWrite_in(MemWrite_out_4),
            			.MemRead_in(MemRead_out_4),      
				.mem_to_reg_in(mem_to_reg_out_4), 
				.branch_cond(branch_cond_out_4), 
				.call_target(call_target_out_4), 
				.branch(branch_out_4), 
				.call_in(call_out_4),
				.PC_in(PC_out_4), 
				.ret_future_in(ret_out_4), 
				.alu_src(alu_src_out_4), 
				.alu_op(alu_op_out_4), 
				.shift(shift_out_4), 
         			.rd_data_1(rd_data_1_out_4), 
				.rd_data_2(rd_data_2_out_4), 
				.sign_ext(sign_ext_out_4), 
				.reg_rd_in(reg_rd_out_4), 
				.load_half(load_half_out_4), 
				.half_spec(half_spec_out_4), 
				.load_half_imm(load_half_imm_out_4),
				.HALT_in(HALT_4), 
				.alu_done(alu_done),
				.set_flags(set_flags),

				.call_out(call_out_5), 
				.RegWrite_out(RegWrite_out_5), 
				.MemWrite_out(MemWrite_out_5),
            .MemRead_out(MemRead_out_5),
          		.mem_to_reg_out(mem_to_reg_out_5), 
          		.ret_future_out(ret_future_out_5), 
				.reg_rd_out(reg_rd_out_5), 
				.alu_result(alu_result_5), 
				.sw_data(sw_data_5),
				.HALT_out(HALT_5));	

	//#6; Execution/Memory intermediate register	
	EXMEM_reg EXMEM_r(	.clk(clk), 
				.RegWrite_in(RegWrite_out_5), 
				.MemWrite_in(MemWrite_out_5),
            .MemRead_in(MemRead_out_5),
				.call_in(call_out_5), 
				.mem_to_reg_in(mem_to_reg_out_5), 
          		.reg_rd_in(reg_rd_out_5), 
				.alu_result_in(alu_result_5), 
          		.save_word_data_in(sw_data_5), 
				.ret_future_in(ret_future_out_5),
				.HALT_in(HALT_5),
				
				.RegWrite_out(RegWrite_out_6),
				.MemWrite_out(MemWrite_out_6),
            .MemRead_out(MemRead_out_6),
				.call_out(call_out_6), 
          		.mem_to_reg_out(mem_to_reg_out_6), 
          		.reg_rd_out(reg_rd_out_6), 
				.alu_result_out(alu_result_out_6), 
          		.save_word_data_out(save_word_data_out_6), 
				.ret_future_out(ret_future_out_6),
				.HALT_out(HALT_6));
	
	//#7; stage 4 -- Memory Module Unit	
	MEM_Unit MEMU(.clk(clk), 
				.rst(rst_g), 
				.call_in(call_out_6), 
				.RegWrite_in(RegWrite_out_6), 
				.MemWrite_in(MemWrite_out_6),
            .MemRead_in(MemRead_out_6),		
				.mem_to_reg_in(mem_to_reg_out_6), 
				.reg_rd_in(reg_rd_out_6), 
   	 		   .alu_result_in(alu_result_out_6), 
				.mem_write_data(save_word_data_out_6), 
				.ret_future_in(ret_future_out_6), 
				.mem_req(mem_req_1), 
				.HALT_in(HALT_6),

				.RegWrite_out(RegWrite_out_7), 
				.ret_future_out(ret_future_out_7), 
				.mem_to_reg_out(mem_to_reg_out_7), 
				.reg_rd_out(reg_rd_out_7), 
          		.mem_read_data(mem_read_data_out_7), 
          		.alu_result_out(alu_result_out_7), 
          		.mem_data_res(mem_data_res_7), 
          		.HALT_out(HALT_7));

	//#8; Memory/WriteBack intermediate register
	MEMWB_reg MEMWB_r(	.clk(clk), 
				.RegWrite_in(RegWrite_out_7), 
				.ret_in(ret_future_out_7), 
				.mem_to_reg_in(mem_to_reg_out_7), 
				.reg_rd_in(reg_rd_out_7), 
				.mem_read_data_in(mem_read_data_out_7), 
				.alu_result_in(alu_result_out_7),
				.HALT_in(HALT_7), 
				
				.RegWrite_out(RegWrite_out_8), 
				.ret_out(ret_out_8), 
				.mem_to_reg_out(mem_to_reg_out_8), 
				.reg_rd_out(reg_rd_out_8), 
				.mem_read_data_out(mem_read_data_out_8), 
				.alu_result_out(alu_result_out_8),
				.HALT_out(HALT_8));
	
	//#9; stage 5 -- WriteBack Module Unit
	WB_Unit WBU(
				.mem_read_data(mem_read_data_out_8),
				.alu_result(alu_result_out_8),  
				.mem_to_reg(mem_to_reg_out_8), 
				.reg_rd_in(reg_rd_out_8), 
				.HALT_in(HALT_8), 

				.write_back_data(write_back_data_9), 
				.reg_rd_out(reg_rd_out_9),
				.HALT_out(HALT));	

endmodule
