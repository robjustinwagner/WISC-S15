// Author: Graham Nygard, Robert Wagner

module Control_Logic(opcode, branch_cond, 
	data_reg, call, retrn, branch, mem_to_reg, reg_to_mem, alu_op, alu_src, sign_ext_sel);

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
output		rtrn;
output 	[3:0]  	branch;   	// branching control; 0-2 sensitive, 3 pick 
output        	mem_to_reg;     // LW signal to Memory unit 
output        	reg_to_mem;     // SW signal to Memory unit
output 	[2:0]  	alu_op;         // ALU control unit input
output       	alu_src;        // ALU operand seleciton
output 		sign_ext_sel;   // sign extend select bit
               
/* LOCAL PARAMS */      
//ALU OPERATIONS 
localparam   ADD   =   4'b0000;
localparam   SUB   =   4'b0001;
localparam   NAND  =   4'b0010;
localparam   XOR   =   4'b0011;
localparam   INC   =   4'b0100;
localparam   SRA   =   4'b0101;
localparam   SRL   =   4'b0110;
localparam   SLL   =   4'b0111;
//SPECIAL
localparam   LW    =   4'b1000;
localparam   SW    =   4'b1001;
localparam   LHB   =   4'b1010;
localparam   LLB   =   4'b1011;
localparam   B     =   4'b1100;
localparam   CALL  =   4'b1101;
localparam   RET   =   4'b1110;
localparam   ERR   =   4'b1111;
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
       
	case(opcode)
              
   	   ADD : begin
		 data_reg = 1'b0;
		 call = 1'b0;
		 rtrn = 1'b1;
		 branch = {0, branch_cond[2:0]};
		 mem_to_reg = 1'b0;
		 reg_to_mem = 1'b0;
		 alu_op = opcode[2:0];
		 alu_src = 1'b0;
		 sign_ext_sel = 1'b0;
		 end
           
           SUB : begin
		 data_reg = 1'b0;
		 call = 1'b0;
		 rtrn = 1'b1;
		 branch = {0, branch_cond[2:0]};
		 mem_to_reg = 1'b0;
		 reg_to_mem = 1'b0;
		 alu_op = opcode[2:0];
		 alu_src = 1'b0;
		 sign_ext_sel = 1'b0;
		 end

           NAND : begin
		 data_reg = 1'b0;
		 call = 1'b0;
		 rtrn = 1'b1;
		 branch = {0, branch_cond[2:0]};
		 mem_to_reg = 1'b0;
		 reg_to_mem = 1'b0;
		 alu_op = opcode[2:0];
		 alu_src = 1'b0;
		 sign_ext_sel = 1'b0;
		 end
           
           XOR : begin
		 data_reg = 1'b0;
		 call = 1'b0;
		 rtrn = 1'b1;
		 branch = {0, branch_cond[2:0]};
		 mem_to_reg = 1'b0;
		 reg_to_mem = 1'b0;
		 alu_op = opcode[2:0];
		 alu_src = 1'b0;
		 sign_ext_sel = 1'b0;
		 end
                             
           INC : begin
		 data_reg = 1'b0;
		 call = 1'b0;
		 rtrn = 1'b1;
		 branch = {0, branch_cond[2:0]};
		 mem_to_reg = 1'b0;
		 reg_to_mem = 1'b0;
		 alu_op = opcode[2:0];
		 alu_src = 1'b0;
		 sign_ext_sel = 1'b1;
		 end
           
           SRA : begin
		 data_reg = 1'b0;
		 call = 1'b0;
		 rtrn = 1'b1;
		 branch = {0, branch_cond[2:0]};
		 mem_to_reg = 1'b0;
		 reg_to_mem = 1'b0;
		 alu_op = opcode[2:0];
		 alu_src = 1'b0;
		 sign_ext = 1'b1;
		 end
           
           SRL : begin
		 data_reg = 1'b0;
		 call = 1'b0;
		 rtrn = 1'b1;
		 branch = {0, branch_cond[2:0]};
		 mem_to_reg = 1'b0;
		 reg_to_mem = 1'b0;
		 alu_op = opcode[2:0];
		 alu_src = 1'b0;
		 sign_ext_sel = 1'b1;
		 end
           
           SLL : begin
		 data_reg = 1'b0;
		 call = 1'b0;
		 rtrn = 1'b1;
		 branch = {0, branch_cond[2:0]};
		 mem_to_reg = 1'b0;
		 reg_to_mem = 1'b0;
		 alu_op = opcode[2:0];
		 alu_src = 1'b0;
		 sign_ext_sel = 1'b1;
		 end

	   LW :  begin
		 data_reg = 1'b1;
		 call = 1'b0;
		 rtrn = 1'b1;
		 branch = {0, branch_cond[2:0]};
		 mem_to_reg = 1'b1;
		 reg_to_mem = 1'b0;
		 alu_op = opcode[2:0];
		 alu_src = 1'b1;
		 sign_ext_sel = 1'b0;
		 end

	   SW :  begin
		 data_reg = 1'b1;
		 call = 1'b0;
		 rtrn = 1'b1;
		 branch = {0, branch_cond[2:0]};
		 mem_to_reg = 1'b0;
		 reg_to_mem = 1'b1;
		 alu_op = opcode[2:0];
		 alu_src = 1'b1;
		 sign_ext_sel = 1'b0;
		 end

	   LHB : begin
		 data_reg = 1'b0;
		 call = 1'b0;
		 rtrn = 1'b1;
		 branch = {0, branch_cond[2:0]};
		 mem_to_reg = 1'b0;
		 reg_to_mem = 1'b0;
		 alu_op = opcode[2:0];
		 alu_src = ;
		 sign_ext_sel = 1'b0;
		 end

	   LLB : begin
		 data_reg = 1'b0;
		 call = 1'b0;
		 rtrn = 1'b1;
		 branch = {0, branch_cond[2:0]};
		 mem_to_reg = 1'b0;
		 reg_to_mem = 1'b0;
		 alu_op = opcode[2:0];
		 alu_src = ;
		 sign_ext_sel = 1'b0;
		 end

	   B :   begin
		 data_reg = 1'b0;
		 call = 1'b0;
		 rtrn = 1'b1;
		 branch = {1, branch_cond[2:0]};
		 mem_to_reg = 1'b0;
		 reg_to_mem = 1'b0;
		 //do the specific ALU op for the given branch condition
		 /*
                 case(branch_cond[2:0])
                       EQ : alu_op = SUB[2:0];
		            if(data_one == data_two) flags[2] = 1;
                       LT : if(data_one < data_two) flags[1] = 0; flags[0] = 1;
                       GT : if(data_one > data_two) flags = 3'b000;
                       OV : {cout, result} = data_one + data_two;
		            if(cout == 1'b1) flags[1] = 1;
		            {cout, result} = data_one 
		            //see lecture on overflow
                       NE : if(data_one != data_two) flags[2] = 0;
                       GE : if(data_one >= data_two) flags[1] = 1; flags[0] = 0;
                       LE : if(data_one <= data_two) flags[2] = 1;
                       TR : //does not matter
	               default: 
    		 endcase
		 */
		 alu_op = SUB[2:0];
		 alu_src = 1'b1;
		 sign_ext_sel = 1'b0;
		 end

	   CALL : begin
		 data_reg = 1'b0;
		 call = 1'b1;
		 rtrn = 1'b1;
		 branch = {1, branch_cond[2:0]};					//FIX THIS
		 mem_to_reg = 1'b0;
		 reg_to_mem = 1'b0;
		 alu_op = opcode[2:0];
		 alu_src = ;
		 sign_ext_sel = ;
		 end

	   RET : begin
		 data_reg = 1'b0;
		 call = 1'b0;
		 rtrn = 1'b1;
		 branch = {1, branch_cond[2:0]};					//FIX THIS
		 mem_to_reg = 1'b0;
		 reg_to_mem = 1'b0;
		 alu_op = opcode[2:0];
		 alu_src = 1'b1;
		 sign_ext_sel = 1'b0;
		 end

	   ERR : 

	   default : 

       endcase
      
  end

endmodule