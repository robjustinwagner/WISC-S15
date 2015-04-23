// Author: Graham Nygard, Robert Wagner

`include "Instruction_Memory.v"


module IF_Unit(clk, rst,
	hazard, PC_src, PC_branch, 
	PC_out, instruction);

//////////////////////////INPUTS/////////////////////////////

input			    clk;
input			    rst;

input			    hazard;        // Disable PC update for hazards
input			    PC_src;        // Mux select for choosing PC source
input	[15:0]	PC_branch;

/////////////////////////END INPUTS///////////////////////////

//////////////////////////OUTPUTS/////////////////////////////

output	logic	[15:0]	PC_out;
output	logic	[15:0]	instruction;

////////////////////////END OUTPUTS///////////////////////////

//INTERNAL CONTROL
logic	[15:0]	PC_plus_2;
logic	[15:0]	PC_update;
logic	[15:0]	PC_address;
//instruction cache
logic [63:0] wr_garbage;
logic wdirty_garbage;
logic we;
logic [63:0] rd_data;	// 64-bit/4word cache line read out
logic [10:0] tag_out;	// 8-bit tag.  This is needed during evictions
logic hit;
logic dirty;

initial begin
	//set write enable to low permanently (as we will not need to write to IC)
	we = 1'b0;
end

//MODULE INSTANTIATIONS

// Program Counter
always_ff @(posedge clk, posedge hazard) begin
    
    if (!rst & !hazard)
       PC_address <= PC_update;

    else if (rst)
       PC_address <= 16'h0000;
       
    else
       PC_address <= PC_address;
       
end

// Instruction cache
Instruction_Memory instr_mem(.clk(clk), .addr(PC_address),
                             .instr(instruction), .rd_en(!hazard));
/* Replace Instruction_Memory module with this!

//PER PROJECT SPECIFICATION, ASSUME NO WRITE INTO INSTRUCTION CACHE!
//so wr_data & wdirty don't matter, and tie we to low.
Instruction_Cache instr_cache(.clk(clk), .rst_n(!rst), .addr(PC_address), 
				.wr_data(wr_garbage), .wdirty(wdirty_garbage),
				.we(we), .re(!hazard), .rd_data(rd_data), 
				.tag_out(tag_out), .hit(hit), .dirty(dirty));

TODO: instruction parsing logic from rd_data

*/

//PC update logic (branch target or next instr)
always_comb begin
    
    PC_plus_2 = PC_address + 2;
    
    if (PC_src) begin
        PC_update = PC_branch;
    end
    
    else begin
        PC_update = PC_plus_2;
    end
    
end

assign PC_out = PC_plus_2;

endmodule
