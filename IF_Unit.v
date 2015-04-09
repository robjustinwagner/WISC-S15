// Author: Graham Nygard, Robert Wagner

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

//MODULE INSTANTIATIONS

// Program Counter
always_ff @(posedge clk, posedge hazard) begin
    
    if (!rst /*& !hazard*/)
       PC_address <= PC_update;

    else if (rst)
       PC_address <= 16'h0000;
       
    else
       PC_address <= PC_address;
       
end

// Instruction cache
Instruction_Memory instr_mem(.clk(clk), .addr(PC_address),
                             .instr(instruction), .rd_en(1));

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
