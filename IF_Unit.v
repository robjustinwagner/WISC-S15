// Author: Graham Nygard, Robert Wagner

module IF_Unit(clk, PC_src, PC_branch, read_cntrl,
               PC_out, instruction);

//INPUTS
input        clk;
input        PC_src;
input        read_cntrl;
input [15:0] PC_branch;

//OUTPUTS
output logic [15:0] PC_out;
output [15:0] instruction;

//INTERNAL CONTROL
logic [15:0] PC_update;
logic [15:0] PC_address;

//MODULE INSTANTIATIONS

// PC register
Reg_16bit PC(.clk(clk), .en(1), .d(PC_update), .q(PC_address));

// Instruction cache
Instruction_Memory instr_mem(.clk(clk), .addr(PC_address),
                             .instr(instruction), .rd_en(read_cntrl));

//PC update logic (branch target or next instr)
always_comb begin
    
    if (PC_src) begin
        PC_update = PC_branch;
    end
    
    else begin
        PC_update = PC_address + 4;
    end
    
end

assign PC_out = PC_update;

endmodule