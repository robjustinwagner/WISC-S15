// Author: Graham Nygard, Robert Wagner

`include "Instruction_Memory.v"


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

output logic PC_hazard_ff;
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
       
    else begin
       PC_address <= PC_address;
       PC_hazard_ff <= PC_hazard;
    end
       
end

// Instruction cache
Instruction_Memory instr_mem(.clk(clk), .addr(PC_address),
                             .instr(read_instr), .rd_en(!instr_hazard));
/* Replace Instruction_Memory module with this!

//PER PROJECT SPECIFICATION, ASSUME NO WRITE INTO INSTRUCTION CACHE!
//so wr_data & wdirty don't matter, and tie we to low.
Instruction_Cache instr_cache(.clk(clk), .rst_n(!rst), .addr(PC_address), 
				.wr_data(wr_garbage), .wdirty(wdirty_garbage),
				.we(we), .re(!hazard), .rd_data(rd_data), 
				.tag_out(tag_out), .hit(hit), .dirty(dirty));

TODO: instruction parsing logic from rd_data

*/

always_comb begin
    
    instr_hazard = (PC_hazard_ff);// | (PC_src);
    
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
   if (PC_src) begin
      PC_out = 16'hxxxx;
      instruction = 16'hxxxx;
   end
   else begin
      PC_out = PC_address;
       instruction = read_instr;
   end
end

endmodule
