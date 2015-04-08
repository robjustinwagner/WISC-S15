// Author: Graham Nygard, Robert Wagner

module HDT_Unit_tb();
    
reg clk;
    
reg [3:0] IF_ID_reg_rs, IF_ID_reg_rt, IF_ID_reg_rd;
reg [3:0] ID_EX_reg_rd, EX_MEM_reg_rd, MEM_WB_reg_rd;

wire hazard;

initial begin
  forever #5 clk = ~clk; 
end

HDT_Unit DUT(.IF_ID_reg_rs(IF_ID_reg_rs), .IF_ID_reg_rt(IF_ID_reg_rt),
             .IF_ID_reg_rd(IF_ID_reg_rd), .ID_EX_reg_rd(ID_EX_reg_rd),
             .EX_MEM_reg_rd(EX_MEM_reg_rd), .MEM_WB_reg_rd(MEM_WB_reg_rd),
             .hazard(hazard));

initial begin
    
  clk = 0;
  
  #50;
  
  /*************************FIRST TEST**************************/
  
  IF_ID_reg_rs = 4'b0000;
  IF_ID_reg_rt = 4'b0001;
  IF_ID_reg_rd = 4'b0010;
  
  ID_EX_reg_rd = 4'b1111;
  EX_MEM_reg_rd = 4'b1110;
  MEM_WB_reg_rd = 4'b1101;
  
  #5;
   
  if(hazard) begin
	$display("FIRST TEST FAILED");
	$stop;
  end
  
  else begin 
   $display("FIRST TEST PASSED");
  end
  
  /*************************************************************/
  
  #50;
  
  /*************************SECOND TEST*************************/
  
  IF_ID_reg_rs = 4'b0000;
  IF_ID_reg_rt = 4'b0001;
  IF_ID_reg_rd = 4'b0010;
  
  ID_EX_reg_rd = 4'b0000;
  EX_MEM_reg_rd = 4'b1110;
  MEM_WB_reg_rd = 4'b1101;
  
  #5;
   
  if(!hazard) begin
	$display("SECOND TEST FAILED");
	$stop;
  end
  
  else begin 
   $display("SECOND TEST PASSED");
  end
  
  /*************************************************************/
  
  #50;
  
  /**************************THIRD TEST*************************/
  
  IF_ID_reg_rs = 4'b0000;
  IF_ID_reg_rt = 4'b0001;
  IF_ID_reg_rd = 4'b0010;
  
  ID_EX_reg_rd = 4'b1111;
  EX_MEM_reg_rd = 4'b0000;
  MEM_WB_reg_rd = 4'b1101;
  
  #5;
   
  if(!hazard) begin
	$display("THIRD TEST FAILED");
	$stop;
  end
  
  else begin 
   $display("THIRD TEST PASSED");
  end
  
  /*************************************************************/
  
  #50;
 
 
$stop; 
end
  
endmodule
