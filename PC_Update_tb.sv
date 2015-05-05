// Author: Graham Nygard, Robert Wagner

`include "PC_Update.v"

module PC_Update_tb();
    
//////////////////////////INPUTS///////////////////////////////

reg clk;

// FROM ID/EX REG
reg               branch;
reg        [2:0]  branch_cond;

reg               call;
reg        [11:0] call_imm;

reg        [15:0] PC_in;
reg        [15:0] sign_ext;

// FROM ALU
reg               alu_done;
reg        [2:0]  flags;          // [Z, V, N]

// FROM MEM/WB REG
reg               ret;              
reg        [15:0] PC_stack_pointer;

//////////////////////////OUTPUTS//////////////////////////////
wire [15:0] PC_update;
wire        PC_src;
wire        update_done;

initial begin
  forever #5 clk = ~clk; 
end

PC_Update PCU (.PC_in(PC_in), .PC_stack_pointer(PC_stack_pointer), .alu_done(alu_done), .flags(flags),
                  .call_imm(call_imm), .sign_ext(sign_ext), .branch_cond(branch_cond), .branch(branch),
                  .call(call), .ret(ret), 
               .PC_update(PC_update), .PC_src(PC_src), .update_done(update_done));


initial begin
    
  clk = 0;
  
  #50;
  
  /*************************************************************/
  /******************IF_ID_reg_rs HAZARD TESTS******************/
  /*************************************************************/
  
  /*************************FIRST TEST**************************/
  
  IF_ID_reg_rs = 4'b0000;
  IF_ID_reg_rt = 4'b0001;
  IF_ID_reg_rd = 4'b0010;
  
  ID_EX_reg_rd = 4'b1111;
  EX_MEM_reg_rd = 4'b1110;
  MEM_WB_reg_rd = 4'b1101;
  
  #5;   // NO HAZARD
   
  if(hazard) begin
	$display("REG RS: FIRST TEST FAILED");
	$stop;
  end
  
  else begin 
   $display("REG RS: FIRST TEST PASSED");
  end
  
  /*************************************************************/
  
  #50;
