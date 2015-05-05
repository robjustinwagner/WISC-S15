//`include "icache_def.sv"
import icache_def::*;

/*cache: data memory, single port, 8 blocks*/
module dm_cache_data(input bit clk,
 input cache_req_type data_req,		//data request/command, e.g. RW, valid
 input cache_data_type data_write, 	//write port (64-bit line)
 output cache_data_type data_read);	//read port
 //timeunit 1ns; timeprecision 1ps;

 cache_data_type data_mem[0:7];

 initial begin
 	for (int i=0; i<8; i++)
 		data_mem[i] = '0;
 end

 assign data_read = data_mem[data_req.index];

 //always_ff @(posedge clk) begin
 always @(posedge clk) begin
 	if (data_req.we)
 		data_mem[data_req.index] <= data_write;
 end

endmodule
