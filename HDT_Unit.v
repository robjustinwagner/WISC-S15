// Author: Graham Nygard, Robert Wagner

module HDT_Unit(IF_ID_reg_rs, IF_ID_reg_rt, IF_ID_reg_rd,
                   ID_EX_reg_rd, EX_MEM_reg_rd, MEM_WB_reg_rd,
                   ret, call, branch, DataReg, PC_update, rst,
                data_hazard, PC_hazard);
  
/////////////////////////////INPUTS//////////////////////////////////

input [3:0] IF_ID_reg_rs;  // Incoming Regfile Read Registers
input [3:0] IF_ID_reg_rt;
input [3:0] IF_ID_reg_rd;

input [3:0] ID_EX_reg_rd;  // Corresponds to IDEX_reg's reg_rd_out
input [3:0] EX_MEM_reg_rd; // Corresponds to EXMEM_reg's reg_rd_out
input [3:0] MEM_WB_reg_rd; // Corresponds to MEMWB_reg's reg_rd_out

input rst, ret, call, branch, DataReg, PC_update;

//////////////////////////////////////////////////////////////////////

//////////////////////////////OUTPUTS/////////////////////////////////

// OUTPUT TO HAULT PIPE
output logic data_hazard;
output logic PC_hazard;

//////////////////////////////////////////////////////////////////////

/* This logic is used for determining a hazard 
   when the data segment register isn't ready */
logic [15:0] read_reg_1; 

/* Internal signals for determining if there is
   a data hazard within the pipe */
logic IDEX_hazard;
logic EXMEM_hazard;
logic MEMWB_hazard;

// Main combinational logic for determining hazards
always_comb begin
    
    if (rst) begin
        PC_hazard = 1'b0;
        data_hazard = 1'b0;
    end
    
    /* Reset the PC_hazard when the PC_Update module finishes
       computing the new target PC */
    else if (PC_update) begin
        PC_hazard = 1'b0;
        data_hazard = data_hazard;
    end
    
    // Can't have a data hazard if the current instruction is return
    else if (ret) begin
       PC_hazard = 1'b1;
       data_hazard = 1'b0; 
    end
    
    // Can't have a data hazard if the current instruction is call
    else if (call) begin
        PC_hazard = 1'b0;
        data_hazard = 1'b0; 
    end
       
    else begin
        
	/* If the current instruction requires the Data_Segment register
	   then assign that register for hazard detection */
        if (DataReg)
           read_reg_1 = 4'b1110;
        else
           read_reg_1 = IF_ID_reg_rs;

	// Combinational XOR and AND gates for register comparisons
        IDEX_hazard  = ( (&(read_reg_1 ~^ ID_EX_reg_rd)) |
                         (&(IF_ID_reg_rt ~^ ID_EX_reg_rd)) |
                         (&(IF_ID_reg_rd ~^ ID_EX_reg_rd)) );
                     
        EXMEM_hazard = ( (&(read_reg_1 ~^ EX_MEM_reg_rd)) |
                         (&(IF_ID_reg_rt ~^ EX_MEM_reg_rd)) |
                         (&(IF_ID_reg_rd ~^ EX_MEM_reg_rd)) );
                     
        MEMWB_hazard = ( (&(read_reg_1 ~^ MEM_WB_reg_rd)) |
                         (&(IF_ID_reg_rt ~^ MEM_WB_reg_rd)) |
                         (&(IF_ID_reg_rd ~^ MEM_WB_reg_rd)) );
                       
	// Data hazards occur when any one of the above signals are satified  
        data_hazard = (IDEX_hazard | EXMEM_hazard | MEMWB_hazard);
        
	// Data hazards shouldn't happen when one of the above signals is undefined
        if (data_hazard === 1'bx)
    		data_hazard = 1'b0;
      
    end

end

endmodule