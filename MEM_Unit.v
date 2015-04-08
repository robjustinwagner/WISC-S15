// Author: Graham Nygard, Robert Wagner

module MEM_Unit(clk, addr, re, we, wrt_data, rd_data)

//INPUTS
input clk;

input        mem_to_reg;    // Memory Read to register 
input        reg_to_mem;    // Memory Write from register
input [3:0]  reg_rd;        // Destination of Memory Read
input [15:0] alu_result;    // Results of ALU operation

//PIPE TO PIPE
input        ret_future_in; // Future ret_wb signal



//OUTPUTS


//MODULE INSTANTIATIONS
Data_Memory data_mem(clk, addr, re, we, wrt_data, rd_data);


endmodule