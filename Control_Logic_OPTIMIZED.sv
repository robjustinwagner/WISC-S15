// Author: Graham Nygard, Robert Wagner

module Control_Logic_OPTIMIZED(instruction, /*opcode,*/
	data_reg, stack_reg, call, rtrn, branch, mem_to_reg, alu_op, alu_src, sign_ext_sel,
	reg_rt_src, RegWrite, MemWrite, MemRead, load_half, half_spec, HALT);

//INPUTS
input  [15:0]  instruction; // Used for differentiating between NO_OP and HALT


//OUTPUTS
output reg data_reg;	/* Control signal to Regfile to
                           	specifiy the contents of the 
                                Data Segment Register for
                                supplying read_data_1 */
output reg stack_reg;	/* Control signal to RegFile to
                                specify the contents of the
                                Stack_Pointer Register for
                                supplying read_data_1 */
output reg call;
output reg rtrn;
output reg branch;	// branching control; 0-2 sensitive, 3 pick 
output reg mem_to_reg;	// LW signal to Memory unit 
output reg [2:0] alu_op;// ALU control unit input
output reg alu_src;	// ALU operand seleciton
output reg sign_ext_sel;// sign extend select bit
output reg reg_rt_src;	// Read_reg_2 proper SW select
output reg RegWrite;
output reg MemWrite;	// Signal for writing to memory
output reg MemRead;	// Signal for reading from memory
output reg load_half;	// Specifies the ALU result
output reg half_spec;	// (0 -> LHB, 1 -> LLB)

output reg HALT;	// STOP THE CPU

reg [2:0] opcode;   	//3-bit instruction opcode
               
/* LOCAL PARAMS */      
//ALU OPERATIONS 
localparam   ADD   =   4'b0000;
/*
localparam   SUB   =   4'b0001;
localparam   NAND  =   4'b0010;
localparam   XOR   =   4'b0011;
localparam   INC   =   4'b0100;
localparam   SRA   =   4'b0101;
localparam   SRL   =   4'b0110;
localparam   SLL   =   4'b0111;
*/
//SPECIAL
/*
localparam   LW    =   4'b1000;
localparam   SW    =   4'b1001;
localparam   LHB   =   4'b1010;
localparam   LLB   =   4'b1011;
localparam   B     =   4'b1100;
localparam   CALL  =   4'b1101;
localparam   RET   =   4'b1110;
localparam   ERR   =   4'b1111;
*/
localparam   LW    =   3'b000;
localparam   SW    =   3'b001;
localparam   LHB   =   3'b010;
localparam   LLB   =   3'b011;
localparam   B     =   3'b100;
localparam   CALL  =   3'b101;
localparam   RET   =   3'b110;
localparam   ERR   =   3'b111;
//BRANCH CONTROL
localparam   EQ    =   3'b000;
localparam   LT    =   3'b001;
localparam   GT    =   3'b010;
localparam   OV    =   3'b011;
localparam   NE    =   3'b100;
localparam   GE    =   3'b101;
localparam   LE    =   3'b110;
localparam   TR    =   3'b111;

always_comb begin
         
	opcode = instruction[14:12];
	
	data_reg = 1'b0;
	stack_reg = 1'b0;
	call = 1'b0;
	rtrn = 1'b0;
	branch = 1'b0;
	mem_to_reg = 1'b0;
	alu_op = opcode[2:0];
	alu_src = 1'b0;
	sign_ext_sel = 1'b0;
	reg_rt_src = 1'b0;
	RegWrite = 1'b1;
	MemWrite = 1'b0;
	MemRead  = 1'b0;
	load_half = 1'b0;
	half_spec = 1'b0;
	HALT = 1'b0;

   //special case for INC
   if(instruction[15:12] == 4'b0100)
       alu_src = 1'b1;
   else begin

   case(opcode[2:1])
       
   2'b00 : begin
      data_reg = 1'b1; 
      alu_op = ADD[2:0];
      alu_src = 1'b1;
      sign_ext_sel = 1'b1;
   end
   2'b01 : begin 
      reg_rt_src = 1'b1;
      load_half = 1'b1;
   end
   2'b10 : begin end
   2'b11 : begin end
   default : begin end
       
   endcase

	case(opcode)   //FIX THIS to 3 
	
	LW :  begin
	   mem_to_reg = 1'b1;
	   MemRead  = 1'b1;
	end

   SW :  begin
	   reg_rt_src = 1'b1;
	   RegWrite = 1'b0;
	   MemWrite = 1'b1;     
   end

   LHB : begin end

   LLB : begin
	   half_spec = 1'b1;
   end

   B : begin
      branch = 1'b1;
      alu_op = 3'bzzz;
      RegWrite = 1'b0;
      sign_ext_sel = 1'b1;
   end

   CALL : begin
      stack_reg = 1'b1;
      call = 1'b1;
      alu_op = ADD[2:0];
	   MemWrite = 1'b1;
   end

   RET : begin
      stack_reg = 1'b1;
      rtrn = 1'b1;
      alu_op = ADD[2:0];
      MemRead  = 1'b1;
   end

   default : begin    //ERR is now defaulted
      alu_op = 3'bzzz;
      alu_src = 1'bz;
      sign_ext_sel = 1'bz;
      reg_rt_src = 1'bz;
      RegWrite = 1'b0;
      load_half = 1'bz;
      half_spec = 1'bz;
      if (&instruction) HALT = 1'b1;
      else HALT = 1'b0;
   end

   endcase
      
   end   //if/else
   
end   //always_comb

endmodule