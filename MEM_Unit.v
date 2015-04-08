// Author: Graham Nygard, Robert Wagner

module MEM_Unit(clk, 
	   call_in, RegWrite_in, mem_to_reg_in, reg_to_mem,
	      reg_rd_in, alu_result_in, mem_write_data, ret_future_in, 
	   RegWrite_out, ret_future_out, mem_to_reg_out, reg_rd_out,
	      mem_read_data, alu_result_out);

//INPUTS
input clk;

input        call_in;
input        RegWrite_in;
input        mem_to_reg_in;  // Memory Read to register 
input        reg_to_mem;     // Memory Write from register
input [3:0]  reg_rd_in;      // Destination of Memory Read
input [15:0] alu_result_in;  // Results of ALU operation
input [15:0] mem_write_data; // Data for Memory Write      <-- PC during call

//PIPE TO PIPE
input        ret_future_in; // Future ret_wb signal

//OUTPUTS
output logic        RegWrite_out;
output logic        ret_future_out;
output logic        mem_to_reg_out;
output logic [3:0]  reg_rd_out;
output logic [15:0] mem_read_data;
output logic [15:0] alu_result_out;

logic alu_addr;

assign RegWrite_out   = RegWrite_in;
assign ret_future_out = ret_future_in;
assign mem_to_reg_out = mem_to_reg_in;
assign reg_rd_out     = reg_rd_in;

//MUX for updating stack pointer with Call
always_comb begin
    
    if (call_in)
       alu_result_out = alu_result_in - 2;
    else
       alu_result_out = alu_result_in;
       
end

//MUX for updating stack pointer with Ret
always_comb begin
    
    if (ret_future_in)
       alu_addr = alu_result_in + 2;
    else
       alu_addr = alu_result_in;
       
end

//MODULE INSTANTIATIONS
Data_Memory data_mem(.clk(clk), .addr(alu_addr), .re(mem_to_reg_in),
                     .we(reg_to_mem), .wrt_data(mem_write_data),
                     .rd_data(mem_read_data));


endmodule
