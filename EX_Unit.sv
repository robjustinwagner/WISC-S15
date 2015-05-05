// Author: Graham Nygard, Robert Wagner

`include "ALU.sv"
//`include "Flag_reg.sv"
//`include "PC_Update.sv"

module EX_Unit(clk, 
	RegWrite_in, MemWrite_in, MemRead_in, mem_to_reg_in, branch_cond, call_target,
	   branch, call_in, PC_in, ret_future_in, 
	   alu_src, alu_op, shift, rd_data_1, rd_data_2, sign_ext, reg_rd_in,
	   load_half, half_spec, load_half_imm, HALT_in,
	RegWrite_out, MemWrite_out, MemRead_out, mem_to_reg_out, call_out, ret_future_out,
	   reg_rd_out, alu_result, sw_data, HALT_out, alu_done, set_flags);

////////////////////////////INPUTS/////////////////////////////////

input clk;

//PIPE TO PIPE
input RegWrite_in;
input MemWrite_in;
input MemRead_in;

input mem_to_reg_in;          // LW signal to Memory unit 
input ret_future_in;          // Future ret_wb signal
input [3:0] reg_rd_in;         // Future Regfile dest

//PC UPDATER 
input [2:0]  branch_cond;      // Branch condition
input [11:0] call_target;      // Call target

input branch;
input call_in;

input [15:0] PC_in;            // PC for branch/call/ret

//ALU INPUTS
input alu_src;          // ALU operand 2 seleciton

input [2:0]  alu_op;           // ALU operation
input [3:0]  shift;            // ALU shift input
input [15:0] rd_data_1;        // ALU operand 1
input [15:0] rd_data_2;        // ALU operand 2
input [15:0] sign_ext;         // ALU operand 2

//LOAD HALF INSTRUCTIONS
input load_half;        // Specifies the ALU result
input half_spec;        // (0 -> LHB, 1 -> LLB)
input [7:0] load_half_imm;    // ALU imm load input

input HALT_in;

///////////////////////////////////////////////////////////////////

///////////////////////////OUTPUTS/////////////////////////////////

//PIPE TO PIPE
output logic RegWrite_out;
output logic MemWrite_out;
output logic MemRead_out;
output logic mem_to_reg_out; // LW signal to Memory unit 
output logic ret_future_out; // Future ret_wb signal

output logic call_out;       // Signal to decrement SP
output logic [3:0] reg_rd_out;     // Future Regfile dest

output logic [15:0] alu_result;     // Results of ALU operation

output logic [15:0] sw_data;        // Save Word data

output logic HALT_out;

output logic alu_done;

output logic [2:0] set_flags;

///////////////////////////////////////////////////////////////////

////////////////////////INTERCONNECTS//////////////////////////////

logic [15:0] alu_out;

logic [15:0] load_half_result;

logic [2:0] updated_flags;

logic [15:0] alu_op_2;

//PIPE TO PIPE
assign RegWrite_out   = RegWrite_in;
assign MemWrite_out   = MemWrite_in;
assign MemRead_out    = MemRead_in;

assign mem_to_reg_out = mem_to_reg_in;
assign ret_future_out = ret_future_in;

///////////////////////////////////////////////////////////////////

// LHB, LLB instructions
always_comb begin
    
    if (!half_spec)
       load_half_result = {load_half_imm, rd_data_2[7:0]};
    else
       load_half_result = {rd_data_2[15:8], load_half_imm};
       
end

always_comb begin
    
    if (load_half)
       alu_result = load_half_result;
    else
       alu_result = alu_out;
       
end

// ALU source selection
always_comb begin
    
    if (alu_src)
       alu_op_2 = sign_ext;
    else
       alu_op_2 = rd_data_2;
       
end

// Save word selection for saving PC
always_comb begin
    
    if (call_in)
       sw_data = PC_in;
    else
       sw_data = rd_data_2;
       
end

/* Specify the Stack_Pointer register as the
   future register destination */
always_comb begin
    
    if (call_in | ret_future_in)
       reg_rd_out = 4'b1111;
    else
       reg_rd_out = reg_rd_in;
       
end

/////////////////////MODULE INSTANTIATIONS/////////////////////////

ALU       alu(.data_one(rd_data_1), .data_two(alu_op_2),
              .shift(shift), .control(alu_op), .result(alu_out),
              .flags(set_flags), .done(alu_done));		                           

///////////////////////////////////////////////////////////////////

assign HALT_out = HALT_in;

assign call_out = call_in;

endmodule
