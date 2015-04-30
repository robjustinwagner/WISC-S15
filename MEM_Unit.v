// Author: Graham Nygard, Robert Wagner

`include "Data_Memory.v"

module MEM_Unit(clk, rst,
	   call_in, RegWrite_in, MemWrite_in, MemRead_in, mem_to_reg_in, 
	      reg_rd_in, alu_result_in, mem_write_data, ret_future_in, HALT_in,
	   RegWrite_out, ret_future_out, mem_to_reg_out, reg_rd_out,
	      mem_read_data, alu_result_out, HALT_out);

///////////////////////INPUTS////////////////////////
input clk;
input rst;

input        call_in;
input        RegWrite_in;
input        MemWrite_in;
input        MemRead_in;

input        mem_to_reg_in;  // Memory Read to register 
input [3:0]  reg_rd_in;      // Destination of Memory Read
input [15:0] alu_result_in;  // Results of ALU operation
input [15:0] mem_write_data; // Data for Memory Write      <-- PC during call

input        ret_future_in; // Future ret_wb signal

input        HALT_in;
/////////////////////////////////////////////////////

//////////////////////OUTPUTS////////////////////////
output logic        RegWrite_out;
output logic        ret_future_out;
output logic        mem_to_reg_out;
output logic [3:0]  reg_rd_out;
output logic [15:0] mem_read_data;
output logic [15:0] alu_result_out;

output logic        HALT_out;

/////////////////////////////////////////////////////

logic [15:0] alu_addr;
logic [15:0] write_data;

//PIPE TO PIPE
assign RegWrite_out   = RegWrite_in;
assign mem_to_reg_out = mem_to_reg_in;
assign reg_rd_out     = reg_rd_in;
assign ret_future_out = ret_future_in;

//MUX for updating stack pointer with Call
always_comb begin
    
    if (call_in) begin
       alu_result_out = alu_result_in - 2;
       write_data = mem_write_data + 2;
    end
    else begin
       alu_result_out = alu_result_in;
       write_data = mem_write_data;
    end
       
end

//MUX for updating stack pointer with Ret
always_comb begin
    
    if (ret_future_in)
       alu_addr = alu_result_in + 2;
    else
       alu_addr = alu_result_in;
       
end

//MODULE INSTANTIATIONS
Data_Memory data_mem(.clk(clk), .addr(alu_addr), .re(MemRead_in),
                     .we(MemWrite_in), .wrt_data(write_data),
                     .rd_data(mem_read_data));
                     
/* Replace Data_Memory module with this! 

Establishes project-specified size of memory system with 4 cycle delay
unified_mem data_mem(.clk(clk), .rst_n(!rst), .addr(aly_addr), .re(MemRead_in), 
			.we(MemWrite_in), .wdata(mem_write_data), 
			.rd_data(mem_read_data), .rdy(rdy));

TODO: add rdy input
*/

assign HALT_out = HALT_in;

endmodule
