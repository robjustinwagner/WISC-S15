//`include "icache_def.sv"
//`include "Instruction_Cache.sv"
import icache_def::*;

/*cache finite state machine*/
module Cache_Controller(input bit clk, input bit rst,
 	input cpu_req_type cpu_req, 	//CPU request input (CPU->cache)
 	input mem_data_type mem_data, 	//memory response (memory->cache)
 	output mem_req_type mem_req, 	//memory request (cache->memory)
 	output cpu_result_type cpu_res 	//cache result (cache->CPU)
 );
 
 //timeunit 1ns;
 //timeprecision 1ps;
 
 /*write clock*/
 typedef enum {idle, compare_tag, allocate_1, allocate_2, write_back} cache_state_type;

 /*FSM state register*/
 cache_state_type vstate, rstate;

 /*interface signals to tag memory*/
 cache_tag_type tag_read; 		//tag read result
 cache_tag_type tag_write; 		//tag write data
 cache_req_type tag_req; 		//tag request

 /*interface signals to cache data memory*/
 cache_data_type data_read; 		//cache line read data
 cache_data_type data_write;		//cache line write data
 cache_req_type data_req; 		//data req

 /*temporary variable for cache controller result*/
 cpu_result_type v_cpu_res;

 /*temporary variable for memory controller request*/
 mem_req_type v_mem_req;

 assign mem_req = v_mem_req; 		//connect to output ports
 assign cpu_res = v_cpu_res; 

 always_comb begin

 /*------------------------------default values for all signals*/

	v_mem_req.valid = '0;

 	/*no state change by default*/
 	vstate = rstate;
 	v_cpu_res = '{0, 0}; tag_write = '{0, 0, 0};
 	
 	/*read tag by default*/
 	tag_req.we = '0;
 	/*direct map index for tag*/
 	tag_req.index = cpu_req.addr[4:2];
	
 	/*read current cache line by default*/
 	data_req.we = '0;
 	/*direct map index for cache data*/
 	data_req.index = cpu_req.addr[4:2];
 	
 	/*modify correct word (16-bit) based on address*/
 	//data_write = data_read;

/*
 	case(cpu_req.addr[1:0])
 	2'b00:data_write[15:0] = cpu_req.data;
 	2'b01:data_write[31:16] = cpu_req.data;
 	2'b10:data_write[47:32] = cpu_req.data;
 	2'b11:data_write[63:48] = cpu_req.data;
 	endcase
*/
	
 	/*read out correct word(16-bit) from cache (to CPU)*/
 	case(cpu_req.addr[1:0])
 	2'b00:v_cpu_res.data = data_read[15:0];
 	2'b01:v_cpu_res.data = data_read[31:16];
 	2'b10:v_cpu_res.data = data_read[47:32];
 	2'b11:v_cpu_res.data = data_read[63:48];
 	endcase
	
 	/*memory request address (sampled from CPU request)*/
 	if(rstate == allocate_2)
		v_mem_req.addr = cpu_req.addr + 2;
	else
		v_mem_req.addr = cpu_req.addr;

 	/*memory request data (used in write)*/
 	v_mem_req.data = data_read;
 	v_mem_req.rw = '0;
	
 /*---------------------------------------------------Cache FSM*/
 	case(rstate)
 	
	/*idle state*/
 	idle: begin
 		
		/*If there is a CPU request, then compare cache tag*/
 		if (cpu_req.valid) begin
 			vstate = compare_tag;
		end
	end

	/*compare_tag state*/
 	compare_tag: begin

 		/*cache hit (tag match and cache entry is valid)*/
		if ( (cpu_req.addr[TAGMSB:TAGLSB] == tag_read.tag) && tag_read.valid) begin

 			v_cpu_res.ready = '1;

 			/*hit*/
 			if (cpu_req.rw) begin
 				/*read/modify cache line*/
 				tag_req.we = '1; 
				data_req.we = '1;
 
				/*no change in tag*/
 				tag_write.tag = tag_read.tag;
 				tag_write.valid = '1;
 				/*cache line is dirty*/
 				tag_write.dirty = '1;
 			end

 			/*action is finished*/
 			vstate = idle;
 		end

 		/*cache miss*/
		else begin
 			/*generate new tag*/
 			tag_req.we = '1;
 			tag_write.valid = '1;
 			/*new tag*/
 			tag_write.tag = cpu_req.addr[TAGMSB:TAGLSB];
 			/*cache line is dirty if write*/
 			tag_write.dirty = cpu_req.rw;

 			/*generate memory request on miss*/
 			v_mem_req.valid = '1;
 			/*compulsory miss or miss with clean block*/
 			if (tag_read.valid == 1'b0 || tag_read.dirty == 1'b0) begin
 				/*wait till a new block is allocated*/
 				vstate = allocate_1;
			end
 			else begin
 				/*miss with dirty line*/
 				/*write back address*/
 				v_mem_req.addr = {tag_read.tag, cpu_req.addr[TAGLSB-1:0]};
 				v_mem_req.rw = '1;
 				/*wait till write is completed*/
 				vstate = write_back;
 			end
 
		end
 
	end
 
	/*wait for allocating a new cache line*/
 	allocate_1: begin
 
		/*memory controller has responded*/
 		if (mem_data.ready) begin
			v_mem_req.valid = '0;
			if (mem_req.addr[1:0] == 2'b00) begin
				data_write[15:0] = mem_data.data[15:0];
 		      		data_write[31:16] = mem_data.data[31:16];
			end
			else if (mem_req.addr[1:0] == 2'b01) begin
            			data_write[31:16] = mem_data.data[15:0];
				data_write[47:32] = mem_data.data[31:16];
			end
			else if (mem_req.addr[1:0] == 2'b10) begin
            			data_write[47:32] = mem_data.data[15:0];
				data_write[63:48] = mem_data.data[31:16];
			end
			else begin
			   	data_write[63:48] = mem_data.data[15:0];
            			data_write[15:0] = mem_data.data[31:16];
		   	end
		   	//v_mem_req.addr = {cpu_req.addr[15:2], !cpu_req.addr[1], cpu_req.addr[0]};
    			v_mem_req.valid = '1;
			vstate = allocate_2;
	   	end
	 
   	end

	/*wait for allocating a new cache line*/
 	allocate_2: begin
 
  		//leave allocate only when we have completed the second read
 		if(mem_data.ready) begin
 			/*re-compare tag for write miss (need modify correct word)*/
 			vstate = compare_tag;
 			if (mem_req.addr[1:0] == 2'b00) begin
				data_write[15:0] = mem_data.data[15:0];
 		      		data_write[31:16] = mem_data.data[31:16];
			end
			else if (mem_req.addr[1:0] == 2'b01) begin
            			data_write[31:16] = mem_data.data[15:0];
				data_write[47:32] = mem_data.data[31:16];
			end
			else if (mem_req.addr[1:0] == 2'b10) begin
            			data_write[47:32] = mem_data.data[15:0];
				data_write[63:48] = mem_data.data[31:16];
			end
			else begin
			   	data_write[63:48] = mem_data.data[15:0];
            			data_write[15:0] = mem_data.data[31:16];
		   	end
     			/*update cache line data*/
 		   	data_req.we = '1;
 	   	end
	 
   	end
 
	/*wait for writing back dirty cache line*/
 	write_back: begin
 
		/*write back is completed*/
 		if (mem_data.ready) begin
 			/*issue new memory request (allocating a new line)*/
 			v_mem_req.valid = '1;
 			v_mem_req.rw = '0;
			
 			vstate = allocate_1;
 		end
 	end

  	endcase

  end //end always_comb block

  always_ff @(posedge clk) begin
 	if (rst) begin
 		rstate <= idle; //reset to idle state
	end
 	else begin
 		rstate <= vstate;
  	end
  end

  /*connect cache tag/data memory*/
  dm_cache_tag ctag(.*);
  dm_cache_data cdata(.*);

endmodule
