// Author: Graham Nygard, Robert Wagner

module EX_Unit(clk, )

//INPUTS
input clk;

//OUTPUTS


//MODULE INSTANTIATIONS
ALU alu(data_one, data_two, shift, load_half_imm, control, zero, result, flags);		//FIX THIS.
Forwarding_Unit FU();																				//FIX THIS


endmodule