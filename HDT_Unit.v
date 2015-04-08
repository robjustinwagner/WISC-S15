// Author: Graham Nygard, Robert Wagner

module HDT_Unit();
    
input [3:0] IF_ID_reg_rs;
input [3:0] IF_ID_reg_rt;
input [3:0] IF_ID_reg_rd;

input [3:0] ID_EX_reg_rd_out;
input [3:0] EX_MEM_reg_rd_out;
input [3:0] MEM_WB_reg_rd_out;
