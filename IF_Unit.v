// Author: Graham Nygard, Robert Wagner

//`include "Instruction_Memory.v"
`include "Cache_Controller.v"
`include "icache_def.v"

import icache_def::*;

module IF_Unit(clk, rst, data_hazard, PC_hazard, PC_hazard_ff, 
	               PC_src, PC_branch, mem_data_res, rdy, 
	               mem_req, PC_out, instruction);

//////////////////////////INPUTS/////////////////////////////

input			    clk;
input			    rst;

input			    data_hazard;        // Disable PC update for hazards
input        PC_hazard;
input			    PC_src;        // Mux select for choosing PC source
input	[15:0]	PC_branch;
input [63:0] mem_data_res;
input        rdy;            //memory is ready

/////////////////////////END INPUTS///////////////////////////

//////////////////////////OUTPUTS/////////////////////////////

output logic	PC_hazard_ff;
output	logic	[15:0]	PC_out;
output	logic	[15:0]	instruction;

////////////////////////END OUTPUTS///////////////////////////

//INTERNAL CONTROL
logic	[15:0]	PC_plus_2;
logic	[15:0]	PC_update;
logic	[15:0]	PC_address;

logic hazard;

logic instr_hazard;

//logic [15:0] read_instr; // The instruction read form memory

//instruction cache locals
cpu_req_type cpu_req;			//CPU request input (CPU->cache);  request from the CPU to the cache
mem_data_type mem_data;			//memory response (memory->cache); response from memory to the cache
output mem_req_type mem_req;			//memory request (cache->memory); requests to memory from the cache
cpu_result_type cpu_res;		//cache result (cache->CPU);  responses to the CPU from the cache

assign cpu_req.addr = PC_address;
assign cpu_req.data = '0;         //TODO FIX THIS
assign cpu_req.rw = '0;         //TODO FIX THIS
assign cpu_req.valid = '0;      //TODO FIX THIS
assign mem_data.data = mem_data_res;
assign mem_data.ready = rdy;

// Pipeline stall on hazard
always_comb begin
    
    hazard = (data_hazard | PC_hazard);
    
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
    
    else if (data_hazard & PC_src) begin
        PC_address <= PC_update;
        PC_hazard_ff <= PC_hazard;
    end
    
    else if (PC_hazard & PC_src) begin
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

Cache_Controller cc(.*);    

//PC update logic (branch target or next instr)
always_comb begin
    
    //PC_plus_2 = PC_address + 2;
    
    if (PC_src) begin
        PC_update = PC_branch;
        PC_plus_2 = PC_address;
    end
    
    else begin
        PC_plus_2 = PC_address + 2;
        PC_update =  PC_plus_2;
    end
    
end

always_comb begin
   //if (PC_hazard | PC_hazard_ff) begin
   if (PC_hazard | PC_hazard_ff | cpu_res.rdy) begin
      instruction = 16'hxxxx;
   end
   else begin
      //instruction = read_instr;
      instruction = cpu_res.data;
   end
end


assign PC_out = PC_address;

endmodule
