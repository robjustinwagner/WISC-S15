//`include "icache_def.sv"
import icache_def::*;

/*cache: tag memory, single port, 8 blocks*/
module dm_cache_tag(input bit clk, 	//write clock
 input cache_req_type tag_req, 		//tag request/command, e.g. RW, valid
 input cache_tag_type tag_write,	//write port
 output cache_tag_type tag_read);	//read port
 //timeunit 1ns; timeprecision 1ps;

 cache_tag_type tag_mem[0:7];

 initial begin
 	for (int i=0; i<8; i++)
 		tag_mem[i] = '0;
 end

 assign tag_read = tag_mem[tag_req.index];

 //always_ff @(posedge clk) begin
 always @(posedge clk) begin
 	if (tag_req.we)
 		tag_mem[tag_req.index] <= tag_write;
 end

endmodule
