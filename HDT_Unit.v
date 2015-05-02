// Author: Graham Nygard, Robert Wagner

module HDT_Unit(IF_ID_reg_rs, IF_ID_reg_rt, IF_ID_reg_rd,
                   ID_EX_reg_rd, EX_MEM_reg_rd, MEM_WB_reg_rd,
                   ret, call, branch, DataReg, PC_update, rst, clk, opcode,
                data_hazard, PC_hazard);
    
input [3:0] IF_ID_reg_rs;  // Incoming Regfile Read Registers
input [3:0] IF_ID_reg_rt;
input [3:0] IF_ID_reg_rd;

input [3:0] ID_EX_reg_rd;  // Corresponds to IDEX_reg's reg_rd_out
input [3:0] EX_MEM_reg_rd; // Corresponds to EXMEM_reg's reg_rd_out
input [3:0] MEM_WB_reg_rd; // Corresponds to MEMWB_reg's reg_rd_out

input       clk, rst, ret, call, branch, DataReg, PC_update;

input [3:0] opcode;

//OUTPUT TO HAULT PIPE
output logic data_hazard;
output logic PC_hazard;

logic [15:0] read_reg_1; // This logic is used for determining a hazard when the data segment register isn't ready

logic IDEX_hazard;
logic EXMEM_hazard;
logic MEMWB_hazard;

always_comb begin
    
    if (rst) begin
        PC_hazard = 1'b0;
        data_hazard = 1'b0;
    end
    
    else if (PC_update) begin
        PC_hazard = 1'b0;
        data_hazard = data_hazard;
    end
    
    else if (ret) begin
       PC_hazard = 1'b1;
       data_hazard = 1'b0; // Can't have a data hazard if the current inst is return
    end
    
    else if (call) begin
        PC_hazard = 1'b0;
        data_hazard = 1'b0; // Can't have a data hazard if the current inst is call
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