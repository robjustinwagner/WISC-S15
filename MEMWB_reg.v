// Author: Graham Nygard, Robert Wagner

module MEMWB_reg(clk, 
	mem_read_data_in, reg_rd_in, ret_in,
	alu_result_in, mem_to_reg_in,
	   mem_read_data_out, reg_rd_out, ret_out,
	   alu_result_out, mem_to_reg_out);

//INPUTS
input        clk;
input        ret_in;
input        mem_to_reg_in;
input [3:0]  reg_rd_in;
input [15:0] mem_read_data_in;
input [15:0] alu_result_in;

//OUTPUTS
output logic        ret_out;
output logic        mem_to_reg_out;
output logic [3:0]  reg_rd_out;
output logic [15:0] mem_read_data_out; // Stack pointer data for ret
output logic [15:0] alu_result_out;

always @(posedge clk) begin
	mem_read_data_out <= mem_read_data_in;
	reg_rd_out        <= reg_rd_in;
	ret_out           <= ret_in;
	alu_result_out    <= alu_result_in;
end

endmodule