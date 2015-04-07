// Author: Graham Nygard, Robert Wagner

module IF_Unit(clk, PC_src, PC_branch, hazard,
               PC_out, instruction);

//INPUTS
input        clk;
input        PC_src;        // Mux select for choosing PC source
input        hazard;        // Disable PC update for hazards
input [15:0] PC_branch;

//OUTPUTS
output logic [15:0] PC_out;
output logic [15:0] instruction;

//INTERNAL CONTROL
logic [15:0] PC_plus_4;
logic [15:0] PC_update;
logic [15:0] PC_address;

//MODULE INSTANTIATIONS

// PC register
Reg_16bit PC(.clk(clk), .en(!hazard), .d(PC_update), .q(PC_address));

// Instruction cache
Instruction_Memory instr_mem(.clk(clk), .addr(PC_address),
                             .instr(instruction), .rd_en(!hazard));

//PC update logic (branch target or next instr)
always_comb begin
    
    PC_plus_4 = PC_address + 4;
    
    if (PC_src) begin
        PC_update = PC_branch;
    end
    
    else begin
        PC_update = PC_plus_4;
    end
    
end

assign PC_out = PC_plus_4;

endmodule