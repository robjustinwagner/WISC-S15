// Author: Graham Nygard, Robert Wagner

module HDT_Unit(IF_ID_reg_rs, IF_ID_reg_rt, IF_ID_reg_rd,
                ID_EX_reg_rd, EX_MEM_reg_rd, MEM_WB_reg_rd,
                   hazard);
    
input [3:0] IF_ID_reg_rs;
input [3:0] IF_ID_reg_rt;
input [3:0] IF_ID_reg_rd;

input [3:0] ID_EX_reg_rd;  // Corresponds to IDEX_reg's reg_rd_out
input [3:0] EX_MEM_reg_rd; // Corresponds to EXMEM_reg's reg_rd_out
input [3:0] MEM_WB_reg_rd; // Corresponds to MEMWB_reg's reg_rd_out

output logic hazard;

logic IDEX_hazard;
logic EXMEM_hazard;
logic MEMWB_hazard;

assign IDEX_hazard  = ((IF_ID_reg_rs ~^ ID_EX_reg_rd) |
                       (IF_ID_reg_rt ~^ ID_EX_reg_rd) |
                       (IF_ID_reg_rd ~^ ID_EX_reg_rd));
                     
assign EXMEM_hazard = ((IF_ID_reg_rs ~^ EX_MEM_reg_rd) |
                       (IF_ID_reg_rt ~^ EX_MEM_reg_rd) |
                       (IF_ID_reg_rd ~^ EX_MEM_reg_rd));
                     
assign MEMWB_hazard = ((IF_ID_reg_rs ~^ MEM_WB_reg_rd) |
                       (IF_ID_reg_rt ~^ MEM_WB_reg_rd) |
                       (IF_ID_reg_rd ~^ MEM_WB_reg_rd));

assign hazard = (IDEX_hazard | EXMEM_hazard | MEMWB_hazard);

endmodule
             
   

           
    
    
    
