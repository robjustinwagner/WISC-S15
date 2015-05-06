// Author: Graham Nygard, Robert Wagner

`include "ID_Unit.sv"

module ID_Unit_tb();
    
//INPUTS 

reg [15:0] instruction;

reg clk, rst, PC_update, RegWrite_in, HALT_in;

// For writing to registers
reg [3:0] reg_rd_wb;
reg [15:0] reg_rd_data;

//CONNECTORS

wire [2:0]  branch_cond;
wire [3:0]  reg_rs, reg_rt_arith, cntrl_opcode, arith_imm_in, load_save_reg_in, ID_EX_reg_rd, EX_MEM_reg_rd, MEM_WB_reg_rd;
wire [7:0]  load_save_imm_in;
wire [11:0] call_target;
wire [15:0] PC_in;

//OUTPUTS

wire       mem_to_reg, RegWrite_out, MemWrite_out,
           MemRead_out, alu_src, branch, call, ret, load_half,
           half_spec, data_hazard, PC_hazard_out, HALT_out;

wire [2:0] branch_cond_out, alu_op;

wire [3:0] load_save_reg_out, arith_imm_out;

wire [7:0] load_save_imm_out;

wire [11:0] call_target_out;

wire [15:0] read_data_1, read_data_2, PC_out, sign_ext_out;

//INIT CLOCK
initial begin
  forever #5 clk = ~clk; 
end

//  MIMICS THE IFID_reg PIPELINE REGISTER
assign cntrl_opcode     = instruction[15:12];
assign reg_rs           = instruction[7:4];
assign reg_rt_arith     = instruction[3:0];
assign load_save_reg_in = instruction[11:8];
assign arith_imm_in     = instruction[3:0];
assign load_save_imm_in = instruction[7:0];
assign call_target      = instruction[11:0];
assign branch_cond      = instruction[10:8];

ID_Unit ID(.clk(clk), .rst(rst), .instruction(instruction),
	         .PC_hazard_in(PC_hazard_in), .RegWrite_in(RegWrite_in), .reg_rs(reg_rs), .reg_rt_arith(reg_rt_arith),
	             .reg_rd_wb(reg_rd_wb), .reg_rd_data(reg_rd_data),.branch_cond_in(branch_cond_in), 
		     .arith_imm_in(arith_imm_in), .load_save_reg_in(load_save_reg_in), .load_save_imm_in(load_save_imm_in),
		     .call_target_in(call_target), .PC_in(PC_in), .ID_EX_reg_rd(ID_EX_reg_rd), .EX_MEM_reg_rd(EX_MEM_reg_rd), 
		     .MEM_WB_reg_rd(MEM_WB_reg_rd), .HALT_out(HALT_out),
	          .PC_hazard_out(PC_hazard_out), .RegWrite_out(RegWrite_out), .MemWrite_out(MemWrite_out), .MemRead_out(MemRead_out),
	             .mem_to_reg(mem_to_reg), .alu_src(alu_src), .alu_op(alu_op), .branch(branch), .call(call), .ret(ret),
	             .load_half(load_half), .half_spec(half_spec), .read_data_1(read_data_1), .read_data_2(read_data_2),
	             .branch_cond_out(branch_out_cond), .load_save_reg_out(load_save_reg_out), .arith_imm_out(arith_imm_out),
	             .load_save_imm_out(load_save_imm_out), .call_target_out(call_target_out), .PC_out(PC_out),
	             .sign_ext_out(sign_ext_out), .data_hazard(data_hazard), .HALT_in(HALT_in));

initial begin
    
  clk = 0;
  rst = 0;
  
  #50;
  
  /*************************************************************/
  /******Arithmetic Instructions [ Opcode, rd, rs, rt ]*********/
  /*************************************************************/
  
  /**************************SET UP****************************/
  
  RegWrite_in = 1;
  reg_rd_wb = 4'b0001;
  reg_rd_data = 16'h0001;
  
  #50;
  
  reg_rd_wb = 4'b0010;
  reg_rd_data = 16'h0002;
  
  #50;
  
  RegWrite_in = 0;
  
  /***************************ADD TEST**************************/
  
  instruction = 16'b0000_0000_0001_0010; // add $0, $1, $2
  
  repeat(50)@(posedge clk);
 
  if( (read_data_1 != 16'h0001) ||
      (read_data_2 != 16'h0002) ||
      (mem_to_reg != 0)         ||
      (RegWrite_out != 1)       ||
      (MemWrite_out != 0)       ||
      (MemRead_out != 0)        ||
      (alu_src != 0)            ||
      (alu_op != 3'b000)        ||
      (branch != 0)             || 
      (call != 0)               || 
      (ret != 0)) begin
	$display("ADD DECODE FAILED");
	$stop;
  end
  
  else begin 
   $display("ADD DECODE PASSED");
  end
  
  /*************************************************************/
  
  #5;
  
  /**************************SET UP****************************/
  
  RegWrite_in = 1;
  reg_rd_wb = 4'b0101;
  reg_rd_data = 16'h0321;
  
  #50;
  
  reg_rd_wb = 4'b0011;
  reg_rd_data = 16'h4321;
  
  #50;
  
  RegWrite_in = 0;
  
  /***************************SUB TEST**************************/
  
  instruction = 16'b0001_0000_0101_0011;
  
  repeat(50)@(posedge clk);
 
  if( (read_data_1 != 16'h0321) ||
      (read_data_2 != 16'h4321) ||
      (mem_to_reg != 0)         ||
      (RegWrite_out != 1)       ||
      (MemWrite_out != 0)       ||
      (MemRead_out != 0)        ||
      (alu_src != 0)            ||
      (alu_op != 3'b001)        ||
      (branch != 0)             || 
      (call != 0)               || 
      (ret != 0)) begin
	$display("SUB DECODE FAILED");
	$stop;
  end
  
  else begin 
   $display("SUB DECODE PASSED");
  end
  
  /*************************************************************/
  
  #5;
  
  /**************************SET UP****************************/
  
  RegWrite_in = 1;
  reg_rd_wb = 4'b0001;
  reg_rd_data = 16'h0FFF;
  
  #50;
  
  RegWrite_in = 0;
  
  /**************************NAND TEST**************************/
  
  instruction = 16'b0010_0000_0001_0001;
  
  repeat(50)@(posedge clk);
 
  if( (read_data_1 != 16'h0FFF) ||
      (read_data_2 != 16'h0FFF) ||
      (mem_to_reg != 0)         ||
      (RegWrite_out != 1)       ||
      (MemWrite_out != 0)       ||
      (MemRead_out != 0)        ||
      (alu_src != 0)            ||
      (alu_op != 3'b010)        ||
      (branch != 0)             || 
      (call != 0)               || 
      (ret != 0)) begin
	$display("NAND DECODE FAILED");
	$stop;
  end
  
  else begin 
   $display("NAND DECODE PASSED");
  end
  
  /*************************************************************/  
  
  #5;
  
  /**************************SET UP****************************/
  
  RegWrite_in = 1;
  reg_rd_wb = 4'b0110;
  reg_rd_data = 16'h0000;
  
  #50;
  
  reg_rd_wb = 4'b1001;
  reg_rd_data = 16'h1234;
  
  #50;
  
  RegWrite_in = 0;
  
  /***************************XOR TEST**************************/
  
  instruction = 16'b0011_0000_0110_1001;
  
  repeat(50)@(posedge clk);
 
  if( (read_data_1 != 16'h0000) ||
      (read_data_2 != 16'h1234) ||
      (mem_to_reg != 0)         ||
      (RegWrite_out != 1)       ||
      (MemWrite_out != 0)       ||
      (MemRead_out != 0)        ||
      (alu_src != 0)            ||
      (alu_op != 3'b011)        ||
      (branch != 0)             || 
      (call != 0)               || 
      (ret != 0)) begin
	$display("XOR DECODE FAILED");
	$stop;
  end
  
  else begin 
   $display("XOR DECODE PASSED");
  end
  
  /*************************************************************/
  
  #5;
  
  /**************************SET UP****************************/
  
  RegWrite_in = 1;
  reg_rd_wb = 4'b1101;
  reg_rd_data = 16'h0FF0;
  
  #50;
  
  reg_rd_wb = 4'b0101;
  reg_rd_data = 16'hABBA;
  
  #50;
  
  RegWrite_in = 0;
  
  /*************************INC TEST 1**************************/
  
  instruction = 16'b0100_0000_1001_1000;
  
  repeat(50)@(posedge clk);
 
  if( (read_data_1 != 16'h1234)  ||
      (read_data_2 != 16'hxxxx)  ||
      (sign_ext_out != 16'hFFF8) ||
      (mem_to_reg != 0)          ||
      (RegWrite_out != 1)        ||
      (MemWrite_out != 0)        ||
      (MemRead_out != 0)         ||
      (alu_src != 1)             ||
      (alu_op != 3'b100)         ||
      (branch != 0)              || 
      (call != 0)                || 
      (ret != 0)) begin
	$display("INC DECODE 1 FAILED");
	$stop;
  end
  
  else begin 
   $display("INC DECODE 1 PASSED");
  end
  
  /*************************************************************/
  
  #5;
  
  /*************************INC TEST 2**************************/
  
  instruction = 16'b0100_0000_1001_0101;
  
  repeat(50)@(posedge clk);
 
  if( (read_data_1 != 16'h1234)  ||
      (read_data_2 != 16'hxxxx)  ||
      (sign_ext_out != 16'h0005) ||
      (mem_to_reg != 0)          ||
      (RegWrite_out != 1)        ||
      (MemWrite_out != 0)        ||
      (MemRead_out != 0)         ||
      (alu_src != 1)             ||
      (alu_op != 3'b100)         ||
      (branch != 0)              || 
      (call != 0)                || 
      (ret != 0)) begin
	$display("INC DECODE 2 FAILED");
	$stop;
  end
  
  else begin 
   $display("INC DECODE 2 PASSED");
  end
  
  /*************************************************************/
  
  /**************************SET UP****************************/
  
  RegWrite_in = 1;
  reg_rd_wb = 4'b0000;
  reg_rd_data = 16'h0000;
  
  #50;
  
  reg_rd_wb = 4'b0001;
  reg_rd_data = 16'hDEAD;
  
  #50;
  
  RegWrite_in = 0;
  
  /**************************SRA TEST***************************/
  
  instruction = 16'b0101_0000_0000_0001;
  
  repeat(50)@(posedge clk);
 
  if( (read_data_1 != 16'h0000) ||
      (read_data_2 != 16'hDEAD) ||
      (mem_to_reg != 0)         ||
      (RegWrite_out != 1)       ||
      (MemWrite_out != 0)       ||
      (MemRead_out != 0)        ||
      (alu_src != 1'b0)         ||
      (alu_op != 3'b101)        ||
      (branch != 0)             || 
      (call != 0)               || 
      (ret != 0)) begin
	$display("SRA DECODE FAILED");
	$stop;
  end
  
  else begin 
   $display("SRA DECODE PASSED");
  end
  
  /*************************************************************/
  
  #5;
  
  /**************************SET UP****************************/
  
  RegWrite_in = 1;
  reg_rd_wb = 4'b1100;
  reg_rd_data = 16'hBEEF;
  
  #50;
  
  reg_rd_wb = 4'b0001;
  reg_rd_data = 16'hCAFE;
  
  #50;
  
  RegWrite_in = 0;
  
  /**************************SRL TEST***************************/
  
  instruction = 16'b0110_0000_1100_0001;
  
  repeat(50)@(posedge clk);
 
  if( (read_data_1 != 16'hBEEF) ||
      (read_data_2 != 16'hCAFE) ||
      (mem_to_reg != 0)         ||
      (RegWrite_out != 1)       ||
      (MemWrite_out != 0)       ||
      (MemRead_out != 0)        ||
      (alu_src != 1'b0)         ||
      (alu_op != 3'b110)        ||
      (branch != 0)             || 
      (call != 0)               || 
      (ret != 0)) begin
	$display("SRL DECODE FAILED");
	$stop;
  end
  
  else begin 
   $display("SRL DECODE PASSED");
  end
  
  /*************************************************************/ 
  
  #5;
  
  /**************************SET UP****************************/
  
  RegWrite_in = 1;
  reg_rd_wb = 4'b0000;
  reg_rd_data = 16'h0000;
  
  /* Read from a previously written register to
     verify that it was saved */
  
  #50;
  
  RegWrite_in = 0;
  
  /**************************SLL TEST***************************/
  
  instruction = 16'b0111_0000_0000_0101;
  
  repeat(50)@(posedge clk);
 
  if( (read_data_1 != 16'h0000) ||
      (read_data_2 != 16'hABBA) ||
      (mem_to_reg != 0)         ||
      (RegWrite_out != 1)       ||
      (MemWrite_out != 0)       ||
      (MemRead_out != 0)        ||
      (alu_src != 1'b0)         ||
      (alu_op != 3'b111)        ||
      (branch != 0)             || 
      (call != 0)               || 
      (ret != 0)) begin
	$display("SLL DECODE FAILED");
	$stop;
  end
  
  else begin 
   $display("SLL DECODE PASSED");
  end
  
  /*************************************************************/
  
  /*************************************************************/
  /********Load/Save Instruction [ Opcode, rt, imm ]************/
  /*************************************************************/
  
  // Write the Data Segment Register
  RegWrite_in = 1;
  reg_rd_wb = 4'b1110;
  reg_rd_data = 16'hF00D;
  
  #50;
  
  RegWrite_in = 0;
  
  /***************************LW TEST 1*************************/
  
  instruction = 16'b1000_0000_0110_1110;
  
  repeat(50)@(posedge clk);
 
  if( (read_data_1 != 16'hF00D)  ||
      (sign_ext_out != 16'h006E) ||
      (load_save_reg_out != 4'h0)||
      (mem_to_reg != 1)          ||
      (RegWrite_out != 1)        ||
      (MemWrite_out != 0)        ||
      (MemRead_out != 1)         ||
      (alu_src != 1)             ||
      (alu_op != 3'b000)         ||
      (branch != 0)              || 
      (call != 0)                || 
      (ret != 0)) begin
	$display("LW DECODE 1 FAILED");
	$stop;
  end
  
  else begin 
   $display("LW DECODE 1 PASSED");
  end
  
  /*************************************************************/
  
  #5;
  
  /**************************SET UP****************************/
  
  RegWrite_in = 1;
  reg_rd_wb = 4'b0110;
  reg_rd_data = 16'h0007;
  
  #50;
  
  RegWrite_in = 0;
  
  /***************************SW TEST 1*************************/
  
  instruction = 16'b1001_0110_1110_1110;
  
  repeat(50)@(posedge clk);
 
  if( (read_data_1 != 16'hF00D)  ||
      (read_data_2 != 16'h0007)  ||
      (sign_ext_out != 16'hFFEE) ||
      (load_save_reg_out != 4'h6)||
      (mem_to_reg != 0)          ||
      (RegWrite_out != 0)        ||
      (MemWrite_out != 1)        ||
      (MemRead_out != 0)         ||
      (alu_src != 1)             ||
      (alu_op != 3'b000)         ||
      (branch != 0)              || 
      (call != 0)                || 
      (ret != 0)) begin
	$display("SW DECODE 1 FAILED");
	$stop;
  end
  
  else begin 
   $display("SW DECODE 1 PASSED");
  end
  
  /*************************************************************/

  #5;
  
  /***************************LW TEST 2*************************/
  
  instruction = 16'b1000_0100_1100_0000;
  
  repeat(50)@(posedge clk);
 
  if( (read_data_1 != 16'hF00D)  ||
      (sign_ext_out != 16'hFFC0) ||
      (load_save_reg_out != 4'h4)||
      (mem_to_reg != 1)          ||
      (RegWrite_out != 1)        ||
      (MemWrite_out != 0)        ||
      (MemRead_out != 1)         ||
      (alu_src != 1)             ||
      (alu_op != 3'b000)         ||
      (branch != 0)              || 
      (call != 0)                || 
      (ret != 0)) begin
	$display("LW DECODE 2 FAILED");
	$stop;
  end
  
  else begin 
   $display("LW DECODE 2 PASSED");
  end
  
  /*************************************************************/
  
  #5;
  
  /***************************SET UP****************************/
  
  RegWrite_in = 1;
  reg_rd_wb = 4'b1010;
  reg_rd_data = 16'h0220;
  
  #50;
  
  RegWrite_in = 0;
  
  /***************************SW TEST 2*************************/
  
  instruction = 16'b1001_1010_0000_0010;
  
  repeat(50)@(posedge clk);
 
  if( (read_data_1 != 16'hF00D)  ||
      (read_data_2 != 16'h0220)  ||
      (sign_ext_out != 16'h0002) ||
      (load_save_reg_out != 4'hA)||
      (mem_to_reg != 0)          ||
      (RegWrite_out != 0)        ||
      (MemWrite_out != 1)        ||
      (MemRead_out != 0)         ||
      (alu_src != 1)             ||
      (alu_op != 3'b000)         ||
      (branch != 0)              || 
      (call != 0)                || 
      (ret != 0)) begin
	$display("SW DECODE 1 FAILED");
	$stop;
  end
  
  else begin 
   $display("SW DECODE 2 PASSED");
  end
  
  /*************************************************************/
  
  #5;
  
  /***************************SET UP****************************/
  
  RegWrite_in = 1;
  reg_rd_wb = 4'b1001;
  reg_rd_data = 16'hBEEF;
  
  #50;
  
  RegWrite_in = 0;
  
  /***************************LHB TEST**************************/
  
  instruction = 16'b1010_1001_0000_0010;
  
  repeat(50)@(posedge clk);
 
  if( (read_data_2 != 16'hBEEF)  ||
      (load_save_reg_out != 4'h9)||
      (mem_to_reg != 0)          ||
      (RegWrite_out != 1)        ||
      (MemWrite_out != 0)        ||
      (MemRead_out != 0)         ||
      (load_half != 1)           ||
      (half_spec != 0)           ||
      (branch != 0)              || 
      (call != 0)                || 
      (ret != 0)) begin
	$display("LHB DECODE FAILED");
	$stop;
  end
  
  else begin 
   $display("LHB DECODE PASSED");
  end
  
  /*************************************************************/
  
  #5;
  
  /***************************SET UP****************************/
  
  RegWrite_in = 1;
  reg_rd_wb = 4'b1100;
  reg_rd_data = 16'hD00D;
  
  #50;
  
  RegWrite_in = 0;
  
  /***************************LHB TEST**************************/
  
  instruction = 16'b1011_1100_0000_0010;
  
  repeat(50)@(posedge clk);
 
  if( (read_data_2 != 16'hD00D)  ||
      (load_save_reg_out != 4'hC)||
      (mem_to_reg != 0)          ||
      (RegWrite_out != 1)        ||
      (MemWrite_out != 0)        ||
      (MemRead_out != 0)         ||
      (load_half != 1)           ||
      (half_spec != 1)           ||
      (branch != 0)              || 
      (call != 0)                || 
      (ret != 0)) begin
	$display("LLB DECODE FAILED");
	$stop;
  end
  
  else begin 
   $display("LLB DECODE PASSED");
  end
  
  /*************************************************************/
  
  #5;
  
  /***************************SET UP****************************/
  
  // Write Stack Pointer register
  RegWrite_in = 1;
  reg_rd_wb = 4'b1111;
  reg_rd_data = 16'hFFFF;
  
  #50;
  
  RegWrite_in = 0;
  
  /************************Branch TEST**************************/
  
  instruction = 16'b1100_0110_1000_0110;
  
  repeat(50)@(posedge clk);
 
  if( (sign_ext_out != 16'hFF86) ||
      (mem_to_reg != 0)          ||
      (RegWrite_out != 0)        ||
      (MemWrite_out != 0)        ||
      (MemRead_out != 0)         ||
      (load_half != 0)           ||
      (branch != 1)              || 
      (call != 0)                || 
      (ret != 0)) begin
	$display("BRANCH DECODE FAILED");
	$stop;
  end
  
  else begin 
   $display("BRANCH DECODE PASSED");
  end
  
  /*************************************************************/
  
  #5;
  
  /**************************Call TEST**************************/
  
  instruction = 16'b1101_1100_0110_0011;
  
  repeat(50)@(posedge clk);
 
  if( (read_data_1 != 16'hFFFF)  ||
      (mem_to_reg != 0)          ||
      (RegWrite_out != 1)        ||
      (MemWrite_out != 1)        ||
      (MemRead_out != 0)         ||
      (load_half != 0)           ||
      (PC_hazard_out != 0)       ||
      (branch != 0)              || 
      (call != 1)                || 
      (ret != 0)) begin
	$display("CALL DECODE FAILED");
	$stop;
  end
  
  else begin 
   $display("CALL DECODE PASSED");
  end
  
  /*************************************************************/
  
  #5;
  
  /************************Return TEST**************************/
  
  instruction = 16'b1110_1100_1111_0101;
  
  repeat(50)@(posedge clk);
 
  if( (read_data_1 != 16'hFFFF)  ||
      (mem_to_reg != 0)          ||
      (RegWrite_out != 1)        ||
      (MemWrite_out != 0)        ||
      (MemRead_out != 1)         ||
      (load_half != 0)           ||
      (PC_hazard_out != 1)       ||
      (branch != 0)              || 
      (call != 0)                || 
      (ret != 1)) begin
	$display("RETURN DECODE FAILED");
	$stop;
  end
  
  else begin 
   $display("RETURN DECODE PASSED");
  end
  
  /*************************************************************/

  $display("ALL INSTRUCTIONS HAVE PASSED THEIR TESTS");
  $stop; 
   
end
  
endmodule