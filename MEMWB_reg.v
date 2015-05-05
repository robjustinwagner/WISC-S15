// Author: Graham Nygard, Robert Wagner

module MEMWB_reg(clk, 
	RegWrite_in, ret_in, mem_to_reg_in, reg_rd_in, mem_read_data_in, alu_result_in, HALT_in,
	RegWrite_out, ret_out, mem_to_reg_out, reg_rd_out, mem_read_data_out, alu_result_out, HALT_out);

//////////////////////////INPUTS///////////////////////////////
input clk;

input RegWrite_in;
input ret_in;
input mem_to_reg_in;
input [3:0]  reg_rd_in;
input [15:0] mem_read_data_in;
input [15:0] alu_result_in;

input HALT_in;

///////////////////////////////////////////////////////////////

//////////////////////////OUTPUTS//////////////////////////////

output logic RegWrite_out;
output logic ret_out;
output logic mem_to_reg_out;
output logic [3:0]  reg_rd_out;
output logic [15:0] mem_read_data_out;
output logic [15:0] alu_result_out;

output logic HALT_out;

///////////////////////////////////////////////////////////////

always @(posedge clk) begin

   	HALT_out          <= HALT_in;
   	mem_to_reg_out    <= mem_to_reg_in;
	mem_read_data_out <= mem_read_data_in;
	reg_rd_out        <= reg_rd_in;
	ret_out           <= ret_in;
	alu_result_out    <= alu_result_in;
	RegWrite_out      <= RegWrite_in;
	
end

endmodule
