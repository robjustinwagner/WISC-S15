// Author: Graham Nygard, Robert Wagner

module ID_Unit(clk, )

//INPUTS
input clk;

//OUTPUTS


//MODULE INSTANTIATIONS
Reg_16bit reg_mem(clk, RegWrite, 
                 Read_Reg_1, Read_Reg_2, Write_Reg,
                 Read_Bus_1, Read_Bus_2, Write_Bus);
Control control();
HDT_Unit hazard_unit();


endmodule