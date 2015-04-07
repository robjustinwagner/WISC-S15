// Author: Graham Nygard, Robert Wagner

module MEM_Unit(clk, addr, re, we, wrt_data, rd_data)

//INPUTS
input clk;

//OUTPUTS


//MODULE INSTANTIATIONS
Data_Memory data_mem(clk, addr, re, we, wrt_data, rd_data);


endmodule