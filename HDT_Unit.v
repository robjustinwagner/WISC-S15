// Author: Graham Nygard, Robert Wagner

module HDT_Unit(IF_ID_reg_rs, IF_ID_reg_rt, IF_ID_reg_rd,
                   ID_EX_reg_rd, EX_MEM_reg_rd, MEM_WB_reg_rd,
                   ret, call, DataReg, PC_update, rst, clk,
                data_hazard, PC_hazard);
    
input [3:0] IF_ID_reg_rs;  // Incoming Regfile Read Registers
input [3:0] IF_ID_reg_rt;
input [3:0] IF_ID_reg_rd;

input [3:0] ID_EX_reg_rd;  // Corresponds to IDEX_reg's reg_rd_out
input [3:0] EX_MEM_reg_rd; // Corresponds to EXMEM_reg's reg_rd_out
input [3:0] MEM_WB_reg_rd; // Corresponds to MEMWB_reg's reg_rd_out

input       clk, rst, ret, call, DataReg, PC_update;

//OUTPUT TO HAULT PIPE
output logic data_hazard;
output logic PC_hazard;

logic [15:0] read_reg_1; // This logic is used for determining a hazard when the data segment register isn't ready

logic IDEX_hazard;
logic EXMEM_hazard;
logic MEMWB_hazard;

logic hault;

// Reset the hazards to unhault pipe
always @(posedge clk) begin
    
    if (rst) begin
       hault = 1'b0;
       PC_hazard = 1'b0;
       data_hazard = 1'b0;
    end
   
    else begin
       hault = hault;
       PC_hazard = PC_hazard;
       data_hazard = data_hazard; 
    end
    
end

always_comb begin
    
    if (hault) begin
       if (PC_update) begin
           hault  = 0;
           PC_hazard = 0;
       end
       else begin
           hault  = 1;
           PC_hazard = 1;
       end
    end
    
    else if (ret) begin
       hault = 1;
       PC_hazard = 1;
    end
    
    else if (call) begin
        hault = 1;
        PC_hazard = 1;
    end
       
    else begin
        
        if (DataReg)
           read_reg_1 = 4'b1110;
        else
           read_reg_1 = IF_ID_reg_rs;

        IDEX_hazard  = ( (&(read_reg_1 ~^ ID_EX_reg_rd)) |
                         (&(IF_ID_reg_rt ~^ ID_EX_reg_rd)) |
                         (&(IF_ID_reg_rd ~^ ID_EX_reg_rd)) );
                     
        EXMEM_hazard = ( (&(read_reg_1 ~^ EX_MEM_reg_rd)) |
                         (&(IF_ID_reg_rt ~^ EX_MEM_reg_rd)) |
                         (&(IF_ID_reg_rd ~^ EX_MEM_reg_rd)) );
                     
        MEMWB_hazard = ( (&(read_reg_1 ~^ MEM_WB_reg_rd)) |
                         (&(IF_ID_reg_rt ~^ MEM_WB_reg_rd)) |
                         (&(IF_ID_reg_rd ~^ MEM_WB_reg_rd)) );
                         
        data_hazard = (IDEX_hazard | EXMEM_hazard | MEMWB_hazard);
        
        if (data_hazard === 1'bx)
           data_hazard = 1'b0;
        
    end

end

endmodule