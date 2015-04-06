// Author: Graham Nygard, Robert Wagner

module IF_Unit(clk, instruction);

//INPUTS
input        clk;
input        PC_src;
input [15:0] PC_branch;

//OUTPUTS
output [15:0] PC_out;
output [15:0] instruction;

//INTERNAL CONTROL
logic [15:0] PC_update;

//MODULE INSTANTIATIONS
Reg_16bit PC(clk, );
Instruction_Memory instr_mem(clk, .instr(instruction), rd_en);

//NOTE: you can't read and write to an inout port simultaneously, so kept highZ for reading
//condition is mux select?, val/expr is mux val?
assign new_addr = (condition) ? <some value / expression> : 'bz;

always @(posedge clk) begin
	addr <= new_addr;
end

endmodule