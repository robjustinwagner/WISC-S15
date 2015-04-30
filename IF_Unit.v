// Author: Graham Nygard, Robert Wagner

`include "Instruction_Memory.v"
`include "Instruction_Cache.v"
`include "Cache_Controller.v"
`include "icache_def.v"

import icache_def::*;

module IF_Unit(clk, rst, data_hazard, PC_hazard, PC_hazard_ff, 
	               PC_src, PC_branch, PC_out, instruction);

//////////////////////////INPUTS/////////////////////////////

input			    clk;
input			    rst;

input			    data_hazard;        // Disable PC update for hazards
input        PC_hazard;
input			    PC_src;        // Mux select for choosing PC source
input	[15:0]	PC_branch;

/////////////////////////END INPUTS///////////////////////////

//////////////////////////OUTPUTS/////////////////////////////

output  logic	PC_hazard_ff;
output	logic	[15:0]	PC_out;
output	logic	[15:0]	instruction;

////////////////////////END OUTPUTS///////////////////////////

//INTERNAL CONTROL
logic	[15:0]	PC_plus_2;
logic	[15:0]	PC_update;
logic	[15:0]	PC_address;

logic hazard;

logic instr_hazard;

logic [15:0] read_instr; // The instruction read form memory

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
// Instruction cache
Instruction_Memory instr_mem(.clk(clk), .addr(PC_address), .instr(read_instr), .rd_en(!clk));

/* Replace Instruction_Memory module with this:

//instruction cache locals
cpu_req_type cpu_req;			//CPU request input (CPU->cache)
mem_data_type mem_data;			//memory response (memory->cache)
mem_req_type mem_req;			//memory request (cache->memory)
cpu_result_type cpu_result;		//cache result (cache->CPU)

//initialization of locals
initial begin
	//set write enable to low permanently (as we will not need to write to IC)
	we = 1'b0;

	//TODO: PROPERLY INITIALIZE VARIABLES HERE
end

Cache_Controller cc(.*);
Instruction_Cache instr_cache(.clk(clk), .rst_n(!rst), .addr(PC_address), 
				.wr_data(), .wdirty(),
				.we(we), .re(!clk), .rd_data(rd_data), 
				.tag_out(tag_out), .hit(hit), .dirty(dirty));
*/

always_comb begin
    
    instr_hazard = (PC_hazard);
    
end
    

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
   if (PC_hazard | PC_hazard_ff) begin
      instruction = 16'hxxxx;;
   end
   else begin
      instruction = read_instr;
   end
end


assign PC_out = PC_address;

endmodule
