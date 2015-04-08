// Author: Graham Nygard, Robert Wagner

module EXMEM_reg(clk, mem_to_reg_in, reg_to_mem_in,
                 reg_rd_in, alu_result_in, ret_future_in,
                 save_word_data_in,
                    mem_to_reg_out, reg_to_mem_out,
                    reg_rd_out, alu_result_out, ret_future_out,
                    save_word_data_out);

////////////////////////////INPUTS///////////////////////////////

input clk;

input        mem_to_reg_in;     // LW signal to Memory unit 
input        reg_to_mem_in;     // SW signal to Memory unit
input [3:0]  reg_rd_in;         // Future Regfile dest
input [15:0] alu_result_in;     // Results of ALU operation
input [15:0] save_word_data_in; // Data for Memory Write

input        ret_future_in;     // Future ret_wb signal

/////////////////////////////////////////////////////////////////

////////////////////////////OUTPUTS//////////////////////////////

//INPUT TO MEMORY UNIT
output logic        mem_to_reg_out;     // Memory Read to register 
output logic        reg_to_mem_out;     // Memory Write from register
output logic [3:0]  reg_rd_out;         // Destination of Memory Read
output logic [15:0] alu_result_out;     // Results of ALU operation
output logic [15:0] save_word_data_out; // Data for Memory Write

//PIPE TO PIPE
output logic        ret_future_out; // Future ret_wb signal

//////////////////////////////////////////////////////////////////

always @(posedge clk) begin
    
	mem_to_reg_out     <= mem_to_reg_in;
	reg_to_mem_out     <= reg_to_mem_in;
	reg_rd_out         <= reg_rd_in;
	alu_result_out     <= alu_result_in;
	save_word_data_out <= save_word_data_in;
	ret_future_out     <= ret_future_in;
	
end

endmodule