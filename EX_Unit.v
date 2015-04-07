// Author: Graham Nygard, Robert Wagner

module EX_Unit(clk, mem_to_reg_in, reg_to_mem_in, branch,ret_wb,
               PC_stack_pointer, alu_src, alu_op, shift, load_half_imm,
               rd_data_1, rd_data_2, sign_ext, ret_future_in, reg_rd_in,
               call_imm, PC_in,
                  mem_to_reg_out, reg_to_mem_out, reg_rd_out,
                  ret_future_out, alu_result, PC_update)
;
////////////////////////////INPUTS/////////////////////////////////

input        clk;
input        mem_to_reg_in;    // LW signal to Memory unit 
input        reg_to_mem_in;    // SW signal to Memory unit 

input [2:0]	 branch;           // Branch condition

input        ret_wb;           // Return signal when SP is ready
input [15:0] PC_stack_pointer; // SP value for PC update

input	       alu_src;          // ALU operand 2 seleciton

input [2:0]	 alu_op;           // ALU operation
input [3:0]  shift;            // ALU shift input
input [7:0]  load_half_imm;    // ALU imm load input
input [15:0] rd_data_1;        // ALU operand 1
input [15:0] rd_data_2;        // ALU operand 2
input [15:0]	sign_ext;         // ALU operand 2

input        ret_future_in;    // Future ret_wb signal
input [3:0]  reg_rd_in;        // Future Regfile dest
input [11:0]	call_imm;         // Call target
input [15:0] PC_in;            // PC for branch/call/ret

///////////////////////////////////////////////////////////////////

///////////////////////////OUTPUTS/////////////////////////////////

output logic        mem_to_reg_out; // LW signal to Memory unit 
output logic        reg_to_mem_out; // SW signal to Memory unit
output logic        ret_future_out; // Future ret_wb signal

output logic [3:0]  reg_rd_out;     // Future Regfile dest

output logic [15:0] alu_result;     // Results of ALU operation

output logic [15:0] PC_update;      // Updated PC for branch/call/ret

///////////////////////////////////////////////////////////////////

//MODULE INSTANTIATIONS
ALU alu(data_one, data_two, shift, load_half_imm, control, zero, result, flags);		//FIX THIS.

PC_Update pc_update(.PC_in(PC_in), PC_stack_pointer, alu_done, flags, call_imm,
                 sign_ext, branch_cond, branch, call, ret, 
                    PC_update, PC_src, update_done);

Forwarding_Unit FU();																				//FIX THIS


endmodule