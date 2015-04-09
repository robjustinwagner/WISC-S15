// Author: Graham Nygard, Robert Wagner

module HDT_Unit_tb();
    
//INPUTS
reg clk, rst, mem_to_reg_in;

reg [2:0] branch_cond;
reg [3:0] reg_rs, reg_rt_arith, reg_rd_wb, cntrl_opcode, arith_imm_in,
          load_save_reg_in, ID_EX_reg_rd, EX_MEM_reg_rd, MEM_WB_reg_rd;
reg [7:0] load_save_imm;
reg [11:0] call_target;
reg [15:0] reg_rd_data, PC_in;

//OUTPUTS
wire       mem_to_reg_out, reg_to_mem, alu_src, branch, call, ret, hazard;

wire [2:0] branch_cond_out;

wire [3:0] load_save_reg_out, arith_imm_out;

wire [7:0] load_save_imm_out;

wire [11:0] call_out;

wire [15:0] read_data_1, read_data_2, PC_out, sign_ext_out;

//INIT CLOCK
initial begin
  forever #5 clk = ~clk; 
end

assign cntrl_opcode = instruction[15:12];
assign reg_rs      = instruction[7:4];
assign reg_rt      = instruction[3:0];
assign	reg_rd      = instruction[11:8];
assign arith_imm     = instruction[3:0];
assign load_save_imm = instruction[7:0];
assign call_target         = instruction[11:0];
	   
	   // Set branch condition
	   branch_cond   <= instruction[10:8];

ID_Unit DUT(.clk(clk), .rst(rst), 
	        .mem_to_reg_in(mem_to_reg_in), .reg_rs(reg_rs), .reg_rt_arith(reg_rt_arith),
	          .reg_rd_wb(reg_rd_wb), .reg_rd_data(reg_rd_data), .cntrl_opcode(cntrl_opcode),
	          .branch_cond_in(branch_cond_in), .arith_imm_in(arith_imm_in), .load_save_reg_in(load_save_reg_in),
	          .load_save_imm_in(load_save_imm_in), .call_target_in(call_target), .PC_in(PC_in),
	          .ID_EX_reg_rd(ID_EX_reg_rd), .EX_MEM_reg_rd(EX_MEM_reg_rd), .MEM_WB_reg_rd(MEM_WB_reg_rd), 
	        .mem_to_reg_out(mem_to_reg_out), .reg_to_mem(reg_to_mem), .alu_src(alu_src),
	          .alu_op(alu_op), .branch(branch), .call(call), .ret(ret), .read_data_1(read_data_1),
	          .read_data_2(read_data_2), .branch_cond_out(branch_out_cond), .load_save_reg_out(load_save_reg_out),
	          .arith_imm_out(arith_imm_out), .load_save_imm_out(load_save_imm_out), .call_out(call_out),
	          .PC_out(PC_out), .sign_ext_out(sign_ext_out), .hazard(hazard));

initial begin
    
  clk = 0;
  
  #50;
  
  /*************************************************************/
  /******Arithmetic Instructions [ Opcode, rd, rs, rt ]*********/
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
  
  $display("ALL HDT_Unit TESTS HAVE PASSED");
  $stop; 
  
end
  
endmodule
