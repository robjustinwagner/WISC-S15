// Author: Graham Nygard, Robert Wagner

module EXMEM_reg(clk, 
	RegWrite_in, MemWrite_in, MemRead_in, call_in, mem_to_reg_in, reg_rd_in, alu_result_in, save_word_data_in, ret_future_in, HALT_in,
	RegWrite_out, MemWrite_out, MemRead_out, call_out, mem_to_reg_out, reg_rd_out, alu_result_out, save_word_data_out, ret_future_out, HALT_out);

////////////////////////////INPUTS///////////////////////////////

input clk;

input RegWrite_in;
input MemWrite_in;
input MemRead_in;

input call_in;           // Signal to decrement SP
input mem_to_reg_in;     // LW signal to Memory unit 
input [3:0]  reg_rd_in;         // Future Regfile dest
input [15:0] alu_result_in;     // Results of ALU operation
input [15:0] save_word_data_in; // Data for Memory Write

input ret_future_in;     // Future ret_wb signal

input HALT_in;

/////////////////////////////////////////////////////////////////

////////////////////////////OUTPUTS//////////////////////////////

// Input to data cache
output logic RegWrite_out;
output logic MemWrite_out;
output logic MemRead_out;

output logic call_out;           
output logic mem_to_reg_out;     	// Memory Read to register 
output logic [3:0]  reg_rd_out;         // Destination of Memory Read
output logic [15:0] alu_result_out;     // Results of ALU operation
output logic [15:0] save_word_data_out; // Data for Memory Write

// Pipe to pipe
output logic ret_future_out; 		// Future ret_wb signal

output logic HALT_out;

//////////////////////////////////////////////////////////////////

always @(posedge clk) begin
    
   	HALT_out <= HALT_in;
    
	mem_to_reg_out     <= mem_to_reg_in;
	
	if (reg_rd_in === 3'bxxx)
      		reg_rd_out <= reg_rd_out;
   	else
      		reg_rd_out <= reg_rd_in; 
      
	alu_result_out     <= alu_result_in;
	save_word_data_out <= save_word_data_in;
	ret_future_out     <= ret_future_in;
	call_out           <= call_in;
	RegWrite_out       <= RegWrite_in;
	MemWrite_out       <= MemWrite_in;
	MemRead_out        <= MemRead_in;
	
end

endmodule
