// Author: Graham Nygard, Robert Wagner

module Control_Logic(opcode, branch_cond,
	data_reg, call, return, branch, mem_to_reg, reg_to_mem, alu_op, alu_src, sign_ext)

//INPUTS
input 	[3:0] 	opcode;   	//4-bit instruction opcode
input	[3:0]	branch_cond;	//3-bit branch condition encoding

//OUTPUTS
output 	      	data_reg;	/* Control signal to Regfile to
                                    specifiy the contents of the 
                                    Data Segment Register for
                                    supplying read_data_1 */
output 		call;		/* Control signal to RegFile to
                                    specify the contents of the
                                    Stack_Pointer Register for
                                    supplying read_data_1 */
output		return;
output 	[3:0]  	branch;   	// branching control; 0-2 sensitive, 3 pick 
output        	mem_to_reg;     // LW signal to Memory unit 
output        	reg_to_mem;     // SW signal to Memory unit
output 	[2:0]  	alu_op;         // ALU control unit input
output       	alu_src;        // ALU operand seleciton
output 		sign_ext;       // sign extend select bit
                      
localparam   ADD   =   4'b0000;
localparam   SUB   =   4'b0001;
localparam   NAND  =   4'b0010;
localparam   XOR   =   4'b0011;
localparam   INC   =   4'b0100;
localparam   SRA   =   4'b0101;
localparam   SRL   =   4'b0110;
localparam   SLL   =   4'b0111;
localparam   LW    =   4'b1000;
localparam   SW    =   4'b1001;
localparam   LHB   =   4'b1010;
localparam   LLB   =   4'b1011;
localparam   B     =   4'b1100;
localparam   CALL  =   4'b1101;
localparam   RET   =   4'b1110;
localparam   ERR   =   4'b1111;

  always_comb begin
       
	case(opcode)
              
   	   ADD : data_reg = ;
		 call = ;
		 branch = {0, branch_cond[2:0]};
		 mem_to_reg = ;
		 reg_to_mem = ;
		 alu_op = opcode[2:0];
		 alu_src = 1'b0;
		 sign_ext = ;
           
           SUB : data_reg = ;
		 call = ;
		 branch = {0, branch_cond[2:0]};
		 mem_to_reg = ;
		 reg_to_mem = ;
		 alu_op = opcode[2:0];
		 alu_src = 1'b0;
		 sign_ext = ;

           NAND : data_reg = ;
		 call = ;
		 branch = {0, branch_cond[2:0]};
		 mem_to_reg = ;
		 reg_to_mem = ;
		 alu_op = opcode[2:0];
		 alu_src = 1'b0;
		 sign_ext = ;
           
           XOR : data_reg = ;
		 call = ;
		 branch = {0, branch_cond[2:0]};
		 mem_to_reg = ;
		 reg_to_mem = ;
		 alu_op = opcode[2:0];
		 alu_src = 1'b0;
		 sign_ext = ;
                             
           INC : data_reg = ;
		 call = ;
		 branch = {0, branch_cond[2:0]};
		 mem_to_reg = ;
		 reg_to_mem = ;
		 alu_op = opcode[2:0];
		 alu_src = 1'b0;
		 sign_ext = ;
           
           SRA : data_reg = ;
		 call = ;
		 branch = {0, branch_cond[2:0]};
		 mem_to_reg = ;
		 reg_to_mem = ;
		 alu_op = opcode[2:0];
		 alu_src = 1'b0;
		 sign_ext = ;
           
           SRL : data_reg = ;
		 call = ;
		 branch = {0, branch_cond[2:0]};
		 mem_to_reg = ;
		 reg_to_mem = ;
		 alu_op = opcode[2:0];
		 alu_src = 1'b0;
		 sign_ext = ;
           
           SLL : data_reg = ;
		 call = ;
		 branch = {0, branch_cond[2:0]};
		 mem_to_reg = ;
		 reg_to_mem = ;
		 alu_op = opcode[2:0];
		 alu_src = 1'b0;
		 sign_ext = ;

	   LW :  data_reg = ;
		 call = ;
		 branch = {0, branch_cond[2:0]};
		 mem_to_reg = ;
		 reg_to_mem = ;
		 alu_op = opcode[2:0];
		 alu_src = 1'b1;
		 sign_ext = ;

	   SW :  data_reg = ;
		 call = ;
		 branch = {0, branch_cond[2:0]};
		 mem_to_reg = ;
		 reg_to_mem = ;
		 alu_op = opcode[2:0];
		 alu_src = 1'b1;
		 sign_ext = ;

	   LHB : data_reg = ;
		 call = ;
		 branch = {0, branch_cond[2:0]};
		 mem_to_reg = ;
		 reg_to_mem = ;
		 alu_op = opcode[2:0];
		 alu_src = ;
		 sign_ext = ;

	   LLB : data_reg = ;
		 call = ;
		 branch = {0, branch_cond[2:0]};
		 mem_to_reg = ;
		 reg_to_mem = ;
		 alu_op = opcode[2:0];
		 alu_src = ;
		 sign_ext = ;

	   B :   data_reg = ;
		 call = ;
		 branch = {1, branch_cond[2:0]};
		 mem_to_reg = ;
		 reg_to_mem = ;
		 alu_op = opcode[2:0];
		 alu_src = 1'b1;
		 sign_ext = ;

	   CALL : data_reg = ;
		 call = ;
		 branch = {1, branch_cond[2:0]};
		 mem_to_reg = ;
		 reg_to_mem = ;
		 alu_op = opcode[2:0];
		 alu_src = ;
		 sign_ext = ;

	   RET : data_reg = ;
		 call = ;
		 branch = {1, branch_cond[2:0]};
		 mem_to_reg = ;
		 reg_to_mem = ;
		 alu_op = opcode[2:0];
		 alu_src = 1'b1;
		 sign_ext = ;

	   ERR : 

	   default : 

       endcase
      
  end

endmodule