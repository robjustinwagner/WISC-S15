// Author: Graham Nygard, Robert Wagner

module WISC-S15_top_level(clk, instr, );

//INPUTS
input clk;
input [15:0] instr;

//OUTPUTS


//INSTANTIATE & CONNECT PIPELINED MODULES
module IF_Unit IFU(clk, );	//stage 1 -- Instruction Fetch Module Unit
module IFID_reg IFID_r(clk, ); // Instruction Fetch/Instruction Decode intermediate register
module ID_Unit IDU(clk, );	//stage 2 -- Instruction Decode Module Unit
module IDEX_reg IDEX_r(clk, );	//Instruction Decode/Execution intermediate register
module EX_Unit EXU(clk, );	//stage 3 -- Execution Module Unit
module EXMEM_reg EXMEM_r(clk, );	//Execution/Memory intermediate register
module MEM_Unit MEMU(clk, );	//stage 4 -- Memory Module Unit
module MEMWB_reg MEMWB_r(clk, );	//Memory/WriteBack intermediate register
module WB_Unit WBU(clk, );	//stage 5 -- WriteBack Module Unit

endmodule