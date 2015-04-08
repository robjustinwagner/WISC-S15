// Author: Graham Nygard, Robert Wagner

module MEM_Unit(clk, mem_to_reg, reg_to_mem, reg_rd_in,
                alu_result, mem_write_data, ret_future_in,
                   mem_read_data, reg_rd_out, ret_future_out);

//INPUTS
input clk;

input        mem_to_reg;     // Memory Read to register 
input        reg_to_mem;     // Memory Write from register
input [3:0]  reg_rd_in;      // Destination of Memory Read
input [15:0] alu_result;     // Results of ALU operation
input [15:0] mem_write_data; // Data for Memory Write

//PIPE TO PIPE
input        ret_future_in; // Future ret_wb signal

//OUTPUTS
output logic mem_read_data;
output logic reg_rd_out;
output reg_future_out;


//MODULE INSTANTIATIONS
Data_Memory data_mem(.clk(clk), .addr(alu_result), .re(mem_to_reg),
                     .we(reg_to_mem), .wrt_data(mem_write_data),
                     .rd_data(mem_read_data));


endmodule