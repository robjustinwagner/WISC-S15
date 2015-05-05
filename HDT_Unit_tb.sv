// Author: Graham Nygard, Robert Wagner

`include "HDT_Unit.sv"

module HDT_Unit_tb();
    
reg clk, call, ret, PC_update;
    
reg [3:0] IF_ID_reg_rs, IF_ID_reg_rt, IF_ID_reg_rd;
reg [3:0] ID_EX_reg_rd, EX_MEM_reg_rd, MEM_WB_reg_rd;

wire hazard;

initial begin
  forever #5 clk = ~clk; 
end

HDT_Unit DUT(.IF_ID_reg_rs(IF_ID_reg_rs), .IF_ID_reg_rt(IF_ID_reg_rt),
             .IF_ID_reg_rd(IF_ID_reg_rd), .ID_EX_reg_rd(ID_EX_reg_rd),
             .EX_MEM_reg_rd(EX_MEM_reg_rd), .MEM_WB_reg_rd(MEM_WB_reg_rd),
             .call(call), .ret(ret), .PC_update(PC_update), .hazard(hazard));

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
  
  /*************************SECOND TEST*************************/
  
  IF_ID_reg_rs = 4'b0000;
  IF_ID_reg_rt = 4'b0001;
  IF_ID_reg_rd = 4'b0010;
  
  ID_EX_reg_rd = 4'b0000;
  EX_MEM_reg_rd = 4'b1110;
  MEM_WB_reg_rd = 4'b1101;
  
  #5;   // HAZARD
   
  if(!hazard) begin
	$display("REG RS: SECOND TEST FAILED");
	$stop;
  end
  
  else begin 
   $display("REG RS: SECOND TEST PASSED");
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
  
  #5;   // HAZARD
   
  if(!hazard) begin
	$display("REG RS: THIRD TEST FAILED");
	$stop;
  end
  
  else begin 
   $display("REG RS: THIRD TEST PASSED");
  end
  
  /*************************************************************/
  
  #50;
  
  /*************************FOURTH TEST*************************/
  
  IF_ID_reg_rs = 4'b1010;
  IF_ID_reg_rt = 4'b0001;
  IF_ID_reg_rd = 4'b0010;
  
  ID_EX_reg_rd = 4'b1111;
  EX_MEM_reg_rd = 4'b0000;
  MEM_WB_reg_rd = 4'b1010;
  
  #5;   // HAZARD
   
  if(!hazard) begin
	$display("REG RS: FOURTH TEST FAILED");
	$stop;
  end
  
  else begin 
   $display("REG RS: FOURTH TEST PASSED");
  end
  
  /*************************************************************/
  
  #50;
  
  /*************************************************************/
  /******************IF_ID_reg_rt HAZARD TESTS******************/
  /*************************************************************/
  
  /*************************FIRST TEST**************************/
  
  IF_ID_reg_rs = 4'b0100;
  IF_ID_reg_rt = 4'b0001;
  IF_ID_reg_rd = 4'b0110;
  
  ID_EX_reg_rd = 4'b1111;
  EX_MEM_reg_rd = 4'b0011;
  MEM_WB_reg_rd = 4'b0011;
  
  #5;   // NO HAZARD
   
  if(hazard) begin
	$display("REG RT: FIRST TEST FAILED");
	$stop;
  end
  
  else begin 
   $display("REG RT: FIRST TEST PASSED");
  end
  
  /*************************************************************/
  
  #50;
  
  /*************************SECOND TEST*************************/
  
  IF_ID_reg_rs = 4'b0000;
  IF_ID_reg_rt = 4'b0001;
  IF_ID_reg_rd = 4'b0010;
  
  ID_EX_reg_rd = 4'b0001;
  EX_MEM_reg_rd = 4'b1110;
  MEM_WB_reg_rd = 4'b1101;
  
  #5;   // HAZARD
   
  if(!hazard) begin
	$display("REG RT: SECOND TEST FAILED");
	$stop;
  end
  
  else begin 
   $display("REG RT: SECOND TEST PASSED");
  end
  
  /*************************************************************/
  
  #50;
  
  /**************************THIRD TEST*************************/
  
  IF_ID_reg_rs = 4'b0000;
  IF_ID_reg_rt = 4'b0001;
  IF_ID_reg_rd = 4'b0010;
  
  ID_EX_reg_rd = 4'b1111;
  EX_MEM_reg_rd = 4'b0001;
  MEM_WB_reg_rd = 4'b1101;
  
  #5;   // HAZARD
   
  if(!hazard) begin
	$display("REG RT: THIRD TEST FAILED");
	$stop;
  end
  
  else begin 
   $display("REG RT: THIRD TEST PASSED");
  end
  
  /*************************************************************/
  
  #50;
  
  /*************************FOURTH TEST*************************/
  
  IF_ID_reg_rs = 4'b1010;
  IF_ID_reg_rt = 4'b0001;
  IF_ID_reg_rd = 4'b0010;
  
  ID_EX_reg_rd = 4'b1111;
  EX_MEM_reg_rd = 4'b0000;
  MEM_WB_reg_rd = 4'b0001;
  
  #5;   // HAZARD
   
  if(!hazard) begin
	$display("REG RT: FOURTH TEST FAILED");
	$stop;
  end
  
  else begin 
   $display("REG RT: FOURTH TEST PASSED");
  end
  
  /*************************************************************/
  
  #50;
  
  /*************************************************************/
  /******************IF_ID_reg_rd HAZARD TESTS******************/
  /*************************************************************/
  
  /*************************FIRST TEST**************************/
  
  IF_ID_reg_rs = 4'b0100;
  IF_ID_reg_rt = 4'b0001;
  IF_ID_reg_rd = 4'b0110;
  
  ID_EX_reg_rd = 4'b1111;
  EX_MEM_reg_rd = 4'b0011;
  MEM_WB_reg_rd = 4'b1011;
  
  #5;   // NO HAZARD
   
  if(hazard) begin
	$display("REG RD: FIRST TEST FAILED");
	$stop;
  end
  
  else begin 
   $display("REG RD: FIRST TEST PASSED");
  end
  
  /*************************************************************/
  
  #50;
  
  /*************************SECOND TEST*************************/
  
  IF_ID_reg_rs = 4'b0000;
  IF_ID_reg_rt = 4'b0001;
  IF_ID_reg_rd = 4'b0010;
  
  ID_EX_reg_rd = 4'b0010;
  EX_MEM_reg_rd = 4'b1110;
  MEM_WB_reg_rd = 4'b1101;
  
  #5;   // HAZARD
   
  if(!hazard) begin
	$display("REG RD: SECOND TEST FAILED");
	$stop;
  end
  
  else begin 
   $display("REG RD: SECOND TEST PASSED");
  end
  
  /*************************************************************/
  
  #50;
  
  /**************************THIRD TEST*************************/
  
  IF_ID_reg_rs = 4'b0000;
  IF_ID_reg_rt = 4'b0001;
  IF_ID_reg_rd = 4'b0010;
  
  ID_EX_reg_rd = 4'b1111;
  EX_MEM_reg_rd = 4'b0010;
  MEM_WB_reg_rd = 4'b1101;
  
  #5;   // HAZARD
   
  if(!hazard) begin
	$display("REG RD: THIRD TEST FAILED");
	$stop;
  end
  
  else begin 
   $display("REG RD: THIRD TEST PASSED");
  end
  
  /*************************************************************/
  
  #50;
  
  /*************************FOURTH TEST*************************/
  
  IF_ID_reg_rs = 4'b1010;
  IF_ID_reg_rt = 4'b0001;
  IF_ID_reg_rd = 4'b0010;
  
  ID_EX_reg_rd = 4'b1111;
  EX_MEM_reg_rd = 4'b0000;
  MEM_WB_reg_rd = 4'b0010;
  
  #5;   // HAZARD
   
  if(!hazard) begin
	$display("REG RD: FOURTH TEST FAILED");
	$stop;
  end
  
  else begin 
   $display("REG RD: FOURTH TEST PASSED");
  end
  
  /*************************************************************/
  
  #50;
  
  /*************************************************************/
  /********************Haulting Pipe with Call******************/
  /*************************************************************/
  
  /*************************FIRST TEST**************************/
  
  IF_ID_reg_rs = 4'b0100;
  IF_ID_reg_rt = 4'b0001;
  IF_ID_reg_rd = 4'b0110;
  
  ID_EX_reg_rd = 4'b1111;
  EX_MEM_reg_rd = 4'b0011;
  MEM_WB_reg_rd = 4'b1011;
  
  call = 1;
  
  #5;
   
  if(!hazard) begin
	$display("Call: FIRST TEST FAILED");
	$stop;
  end
  
  else begin 
   $display("Call: FIRST TEST PASSED");
  end
  
  call = 0;
  
  /*************************************************************/
  
  #50;
  
  /*************************SECOND TEST*************************/
  
  PC_update = 1;
  
  #5;
   
  if(hazard) begin
	$display("Call: SECOND TEST FAILED");
	$stop;
  end
  
  else begin 
   $display("Call: SECOND TEST PASSED");
  end
  
  PC_update = 0;
  
  /*************************************************************/
  
  /*************************************************************/
  /*******************Haulting Pipe with Ret********************/
  /*************************************************************/
  
  /*************************FIRST TEST**************************/
  
  IF_ID_reg_rs = 4'b0100;
  IF_ID_reg_rt = 4'b0001;
  IF_ID_reg_rd = 4'b0110;
  
  ID_EX_reg_rd = 4'b1111;
  EX_MEM_reg_rd = 4'b0011;
  MEM_WB_reg_rd = 4'b1011;
  
  ret = 1;
  
  #5;
   
  if(!hazard) begin
	$display("Ret: FIRST TEST FAILED");
	$stop;
  end
  
  else begin 
   $display("Ret: FIRST TEST PASSED");
  end
  
  ret = 0;
  
  /*************************************************************/
  
  #50;
  
  /*************************SECOND TEST*************************/
  
  PC_update = 1;
  
  #5;
   
  if(hazard) begin
	$display("Ret: SECOND TEST FAILED");
	$stop;
  end
  
  else begin 
   $display("Ret: SECOND TEST PASSED");
  end
  
  PC_update = 0;
  
  /*************************************************************/
  
  #50;
  
  $display("ALL HDT_Unit TESTS HAVE PASSED");
  $stop; 
  
end
  
endmodule
