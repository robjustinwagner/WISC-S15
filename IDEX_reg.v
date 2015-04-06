// Author: Graham Nygard, Robert Wagner

module IDEX_reg(clk, 
	pc_in, mem_to_reg_in, reg_to_mem_in, alu_op_in, alu_src_in, shift_in, sign_ext_in, 
		load_half_imm_in, branch_in, rd_data_0_in, rd_data_1_in, call_in,
	pc_out, mem_to_reg_out, reg_to_mem_out, alu_op_out, alu_src_out, shift_out, sign_ext_out, 
		load_half_imm_out, branch_out, rd_data_0_out, rd_data_1_out, call_out)

//INPUTS
input 		clk;
input 	[15:0] 	pc_in;
input 		mem_to_reg_in;
input		reg_to_mem_in;
input	[2:0]	alu_op_in;
input		alu_src_in;
input 	[3:0] 	shift_in;
input	[15:0]	sign_ext_in;
input 	[7:0] 	load_half_imm_in;
input	[3:0]	branch_in;
input 	[15:0] 	rd_data_0_in;
input 	[15:0] 	rd_data_1_in;
input	[11:0]	call_in;

//OUTPUTS
output 	[15:0] 	pc_out;
input 		mem_to_reg_out;
input		reg_to_mem_out;
input	[2:0]	alu_op_out;
input		alu_src_out;
input 	[3:0] 	shift_out;
input	[15:0]	sign_ext_out;
input 	[7:0] 	load_half_imm_out;
input	[3:0]	branch_out;
input 	[15:0] 	rd_data_0_out;
input 	[15:0] 	rd_data_1_out;
input	[11:0]	call_out;

always @(posedge clk) begin
	pc_out <= pc_in;
	mem_to_reg_out <= mem_to_reg_in;
	reg_to_mem_out <= reg_to_mem_in;
	alu_op_out <= alu_op_in;
	alu_src_out <= alu_src_in;
	shift_out <= shift_in;
	sign_ext_out <= sign_ext_in;
	load_half_imm_out <= load_half_imm_in;
	branch_out <= branch_in;
	rd_data_0_out <= rd_data_0_in;
	rd_data_1_out <= rd_data_1_in;
	call_out <= call_in;
end

endmodule