// Author: Graham Nygard, Robert Wagner

module IF_Unit(clk, instr)

//INPUTS
input clk;

inout new_addr;

//OUTPUTS
output [15:0] instr;

//MODULE INSTANTIATIONS
Reg_16bit PC(clk, );
Instruction_Memory instr_mem(clk, addr, rd_en);

//NOTE: you can't read and write to an inout port simultaneously, so kept highZ for reading
//condition is mux select?, val/expr is mux val?
assign new_addr = (condition) ? <some value / expression> : 'bz;

always @(posedge clk) begin
	addr <= new_addr;
end

endmodule