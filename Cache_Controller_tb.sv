`include "Cache_Controller.sv"
import icache_def::*;

module Cache_Controller_tb();
	
bit clk;
bit rst;

bit [16:0] counter;

//DUT Inputs
cpu_req_type cpu_req; 	//CPU request input (CPU->cache)
/*
 	  bit [15:0] addr; 	//16-bit request addr
 	  bit [15:0] data; 	//16-bit request data (used when write)
 	  bit rw; 		//request type : 0 = read, 1 = write
 	  bit valid; 		//request is valid
*/
mem_data_type mem_data; 	//memory response (memory->cache)
/*
 	  bit [31:0] data; //32-bit read back data
 	  bit ready; 		//data is ready
*/

//DUT OUTPUTS
mem_req_type mem_req; //memory request (cache->memory)
/*
 	  bit [15:0] addr; 	//request byte addr
 	  bit [31:0] data; 	//32-bit request data (used when write)
 	  bit rw; 		//request type : 0 = read, 1 = write
   	 bit valid; 		//request is valid
*/
cpu_result_type cpu_res; //cache result (cache->CPU)
/*
 	  bit [15:0] data; 	//16-bit data
 	  bit ready; 		//result is ready
*/

bit passed;

Cache_Controller Cache_Controller_DUT(.*);
                            
initial begin

	clk = 1'b0;
	rst = 1'b0;
	passed = 1'b1;
	
	#20;

   rst = 1'b1; //verify rst
   
   #20;

   rst = 1'b0;

   cpu_req.addr = 16'h0000;
   cpu_req.data = 16'hxxxx;
   cpu_req.rw = 1'b0;   //we will never be writing into the i-cache
   cpu_req.valid = 1'b0;
	#5
	while(counter[16] != 1'b1) begin
		#5
		
		cpu_req.valid = 1'b1;
		
		//if at any point test fails, stop test
		if (!passed) begin 
			$display("CACHE CONTROLLER TEST FAILED.");
			$stop;
		end
		
		cpu_req.valid = 1'b0;
		cpu_req.addr = cpu_req.addr + 8;
	end

	// else, TEST PASSED
	$display("CACHE CONTROLLER TEST PASSED.");
   
	$stop;
   
end

always begin
	#5 clk = ~clk;
end

endmodule