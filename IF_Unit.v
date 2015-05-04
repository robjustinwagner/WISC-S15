// Author: Graham Nygard, Robert Wagner

//`include "Instruction_Memory.v"
`include "Cache_Controller.v"
//`include "icache_def.v"

import icache_def::*;

module IF_Unit(clk, rst, data_hazard, PC_hazard, PC_hazard_ff, 
	               PC_src, PC_ret, PC_branch, mem_data_res, 
	               mem_req, PC_out, instruction, PC_src_hazard);

//////////////////////////INPUTS/////////////////////////////

input		clk;
input		rst;

input		data_hazard;        // Disable PC update for hazards
input        	PC_hazard;
input		PC_src;        // Mux select for choosing PC source
input		PC_ret;

input	[15:0]	PC_branch;
input mem_data_type mem_data_res;

/////////////////////////END INPUTS///////////////////////////

//////////////////////////OUTPUTS/////////////////////////////

output logic	  PC_hazard_ff;
output logic [15:0]	PC_out;
output logic [15:0]	instruction;
output logic	PC_src_hazard;

output mem_req_type mem_req;			//memory request (cache->memory); requests to memory from the cache

////////////////////////END OUTPUTS///////////////////////////

//INTERNAL CONTROL
logic	[15:0]	PC_plus_2;
logic	[15:0]	PC_update;
logic	[15:0]	PC_address;

logic hazard;

logic PC_src_ff;
logic PC_src_ff_2;

logic PC_ret_ff;
logic PC_ret_ff_2;

logic [15:0] PC_branch_ff;
logic [15:0] PC_branch_ff_2;

logic rst_PC;

//logic [15:0] read_instr; // The instruction read form memory

//instruction cache locals
cpu_req_type cpu_req;			//CPU request input (CPU->cache);  request from the CPU to the cache
cpu_result_type cpu_res;		//cache result (cache->CPU);  responses to the CPU from the cache

/*
initial begin
cpu_req.data = mem_req.data;       //TODO FIX THIS
cpu_req.rw = mem_req.rw;       //TODO FIX THIS
cpu_req.valid = mem_req.valid;      //TODO FIX THIS
end
*/

assign cpu_req.addr = PC_address;
//assign cpu_req.data = mem_data_res.data;       //TODO FIX THIS
assign cpu_req.rw = 1'b0;       //TODO FIX THIS

assign PC_src_hazard = PC_src_ff;

always_comb begin
	if (PC_address === 16'hxxxx)
		cpu_req.valid = 1'b0;      //TODO FIX THIS
	else 
		cpu_req.valid = 1'b1;
end 
// Pipeline stall on hazard
always_comb begin
    
    hazard = (data_hazard | PC_hazard | !cpu_res.ready);
    
end

always @(posedge clk) begin

    if (rst_PC) begin
	PC_src_ff <= 1'b0;
	PC_ret_ff <= 1'b0;
	PC_branch_ff <= 16'hxxxx;
    end
    else if (PC_src) begin
	PC_src_ff <= PC_src;
	PC_ret_ff <= PC_ret;
	PC_branch_ff <= PC_branch;
    end
    else begin
	PC_src_ff <= PC_src_ff;
	PC_ret_ff <= PC_ret_ff;
	PC_branch_ff <= PC_branch_ff;
    end
end

always @(posedge clk) begin

    if (rst_PC) begin
	PC_src_ff_2 <= 1'b0;
	PC_ret_ff_2 <= 1'b0;
	PC_branch_ff_2 <= 16'hxxxx;
    end
    else if (cpu_res.ready) begin
	PC_src_ff_2 <= PC_src_ff;
	PC_ret_ff_2 <= PC_ret_ff;
	PC_branch_ff_2 <= PC_branch_ff;
    end
    else begin
	PC_src_ff_2 <= PC_src_ff_2;
	PC_branch_ff_2 <= PC_branch_ff_2;
    end
end

// Program Counter
always_ff @(posedge clk) begin
    
    if (!rst & !hazard) begin
       PC_address <= PC_update;
       PC_hazard_ff <= PC_hazard;
    end

    else if (rst) begin
       PC_address <= 16'h0000;
       PC_hazard_ff <= 1'b0;
    end
    
    else if (PC_src_ff_2) begin
	PC_address <= PC_update;
        PC_hazard_ff <= PC_hazard;
    end
       
    else begin
       PC_address <= PC_address;
       PC_hazard_ff <= PC_hazard;
    end
       
end

/*-----------------------------MODULE INSTANTIATIONS */
//Instruction_Memory instr_mem(.clk(clk), .addr(PC_address), .instr(read_instr), .rd_en(!clk));

Cache_Controller cc(.clk(clk), .rst(rst),
 	.cpu_req(cpu_req), 	//CPU request input (CPU->cache)
 	.mem_data(mem_data_res), 	//memory response (memory->cache)
 	.mem_req(mem_req), 	//memory request (cache->memory)
 	.cpu_res(cpu_res)); 	//cache result (cache->CPU));    

//PC update logic (branch target or next instr)
always_comb begin
    
    if (PC_ret) begin
	PC_update = PC_branch;
        PC_plus_2 = PC_branch + 2;
	rst_PC = 1'b1;
    end
    else if (PC_src_ff_2 & !PC_ret_ff_2) begin
        PC_update = PC_branch_ff_2;
        PC_plus_2 = PC_branch_ff_2 + 2;
	rst_PC = 1'b1;
    end
    
    else begin
        PC_plus_2 = PC_address + 2;
        PC_update =  PC_plus_2;
	rst_PC = 1'b0;
    end
    
end

always_comb begin
   //if (PC_hazard | PC_hazard_ff) begin
   if (PC_hazard | PC_hazard_ff | !cpu_res.ready) begin //<-- PUT INTO IFID_reg
      instruction = 16'hxxxx;
   end
   else begin
      //instruction = read_instr;
      instruction = cpu_res.data;
   end
end


assign PC_out = PC_address;

endmodule
