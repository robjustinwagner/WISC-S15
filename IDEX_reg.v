// Author: Graham Nygard, Robert Wagner

module IDEX_reg(clk, 
	pc_in, rd_data_0_in, rd_data_1_in, 
	pc_out, rd_data_0_out, rd_data_1_out)

//INPUTS
input clk;
input [15:0] pc_in;
input [15:0] rd_data_0_in;
input [15:0] rd_data_1_in;

//OUTPUTS
output [15:0] pc_out;
output [15:0] rd_data_0_out;
output [15:0] rd_data_1_out;

always @(posedge clk) begin
	pc_out <= pc_in;
	rd_data_0_out <= rd_data_0_in;
	rd_data_1_out <= rd_data_1_in;
end

endmodule