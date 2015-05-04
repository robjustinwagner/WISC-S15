// Author: Graham Nygard, Robert Wagner

`include "Data_Memory.v"
`include "unified_mem.v"
import icache_def::*;

module MEM_Unit(clk, rst,
	   call_in, RegWrite_in, MemWrite_in, MemRead_in, mem_to_reg_in, 
	      reg_rd_in, alu_result_in, mem_write_data, ret_future_in, mem_req, HALT_in,
	   RegWrite_out, ret_future_out, mem_to_reg_out, reg_rd_out,
	      mem_read_data, alu_result_out, mem_data_res, HALT_out);

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

input mem_req_type mem_req;   //requests to memory from the i-cache

input        HALT_in;
/////////////////////////////////////////////////////

//////////////////////OUTPUTS////////////////////////
output logic        RegWrite_out;
output logic        ret_future_out;
output logic        mem_to_reg_out;
output logic [3:0]  reg_rd_out;
output logic [15:0] mem_read_data;
output logic [15:0] alu_result_out;
output mem_data_type mem_data_res;

output logic        HALT_out;

/////////////////////////////////////////////////////

logic [15:0] alu_addr;
logic [15:0] write_data;
logic unified_mem_re;

//PIPE TO PIPE
assign RegWrite_out   = RegWrite_in;
assign mem_to_reg_out = mem_to_reg_in;
assign ret_future_out = ret_future_in;

//MUX for updating stack pointer with Call
always_comb begin
    
    if (call_in) begin
       alu_result_out = alu_result_in - 1;
       write_data = mem_write_data + 2;
       alu_addr = alu_result_in + 1;
    end
    else if (ret_future_in) begin
       alu_result_out = alu_result_in + 2;
       write_data = mem_write_data;
       alu_addr = alu_result_in + 1;
    end
    else begin
       alu_result_out = alu_result_in;
       write_data = mem_write_data;
       alu_addr = alu_result_in;
    end
       
end

always_comb begin
    
    if (RegWrite_in) begin
        reg_rd_out = reg_rd_in;
    end
    else begin
        reg_rd_out = 4'bzzzz;
    end
        
end

always_comb begin

	if(!mem_req.rw)
		unified_mem_re = 1'b1;
	else
		unified_mem_re = 1'b0;
end

//MODULE INSTANTIATIONS

Data_Memory data_mem(.clk(clk), .addr(alu_addr), .re(MemRead_in),
                     .we(MemWrite_in), .wrt_data(write_data),
                     .rd_data(mem_read_data));
                  
//Establishes project-specified size of memory system with 4 cycle delay
unified_mem main_mem(.clk(clk), .rst_n(!rst), .addr({1'b0, mem_req.addr[15:2]}), .re(unified_mem_re), 
			.we(1'b0), .wdata(mem_req.data), 
			.rd_data(mem_data_res.data), .rdy(mem_data_res.ready));
			
//TODO CHOOSE mem_req or normal input

assign HALT_out = HALT_in;

endmodule
