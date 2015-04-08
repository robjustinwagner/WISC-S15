// Author: Graham Nygard, Robert Wagner

module MEMWB_reg(clk, 
	mem_read_data_in, reg_rd_in, ret_future_in, alu_result_in, 
	mem_read_data_out, reg_rd_out, ret_future_out, alu_result_out);

//INPUTS
input clk;
input mem_read_data_in;
input reg_rd_in;
input ret_future_in;
input alu_result_in;

//OUTPUTS
output logic mem_read_data_out;
output logic reg_rd_out;
output logic ret_future_out;
output logic alu_result_out;

always @(posedge clk) begin
	mem_read_data_out <= mem_read_data_in;
	reg_rd_out <= reg_rd_in;
	ret_future_out <= ret_future_in;
	alu_result_out <= alu_result_in;
end

endmodule