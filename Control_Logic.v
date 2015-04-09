// Author: Graham Nygard, Robert Wagner

module Control_Logic(opcode,
	data_reg, call, rtrn, branch, mem_to_reg, reg_to_mem, alu_op, alu_src, 
		sign_ext_sel, reg_rt_src, RegWrite, load_half, half_spec);

//INPUTS
input 	[3:0] 		opcode;   	//4-bit instruction opcode

//OUTPUTS
output 	reg    		data_reg;	/* Control signal to Regfile to
                                    	specifiy the contents of the 
                                    	Data Segment Register for
                                    	supplying read_data_1 */
output 	reg		call;		/* Control signal to RegFile to
                                    	specify the contents of the
                                    	Stack_Pointer Register for
                                    	supplying read_data_1 */
output	reg		rtrn;
output 	reg		branch;   	// branching control; 0-2 sensitive, 3 pick 
output  reg    		mem_to_reg;     // LW signal to Memory unit 
output  reg   		reg_to_mem;     // SW signal to Memory unit
output 	reg [2:0] 	alu_op;         // ALU control unit input
output  reg    		alu_src;        // ALU operand seleciton
output 	reg		sign_ext_sel;   // sign extend select bit
output	reg		reg_rt_src;	// Read_reg_2 proper SW select
output	reg		RegWrite;
output	reg		load_half;	// Specifies the ALU result
output  reg		half_spec;	// (0 -> LHB, 1 -> LLB)
               
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
		 rtrn = 1'b0;
		 branch = 1'b0;
		 mem_to_reg = 1'b0;
		 reg_to_mem = 1'b0;
		 alu_op = opcode[2:0];
		 alu_src = 1'b0;
		 sign_ext_sel = 1'b0;
		 reg_rt_src = 1'b0;
		 RegWrite = 1'b0;
		 load_half = 1'b0;
		 half_spec = 1'b0;
		 end
           
           SUB : begin
		 data_reg = 1'b0;
		 call = 1'b0;
		 rtrn = 1'b0;
		 branch = 1'b0;
		 mem_to_reg = 1'b0;
		 reg_to_mem = 1'b0;
		 alu_op = opcode[2:0];
		 alu_src = 1'b0;
		 sign_ext_sel = 1'b0;
		 reg_rt_src = 1'b0;
		 RegWrite = 1'b0;
		 load_half = 1'b0;
		 half_spec = 1'b0;
		 end

           NAND : begin
		 data_reg = 1'b0;
		 call = 1'b0;
		 rtrn = 1'b0;
		 branch = 1'b0;
		 mem_to_reg = 1'b0;
		 reg_to_mem = 1'b0;
		 alu_op = opcode[2:0];
		 alu_src = 1'b0;
		 sign_ext_sel = 1'b0;
		 reg_rt_src = 1'b0;
		 RegWrite = 1'b0;
		 load_half = 1'b0;
		 half_spec = 1'b0;
		 end
           
           XOR : begin
		 data_reg = 1'b0;
		 call = 1'b0;
		 rtrn = 1'b0;
		 branch = 1'b0;
		 mem_to_reg = 1'b0;
		 reg_to_mem = 1'b0;
		 alu_op = opcode[2:0];
		 alu_src = 1'b0;
		 sign_ext_sel = 1'b0;
		 reg_rt_src = 1'b0;
		 RegWrite = 1'b0;
		 load_half = 1'b0;
		 half_spec = 1'b0;
		 end
                             
           INC : begin
		 data_reg = 1'b0;
		 call = 1'b0;
		 rtrn = 1'b0;
		 branch = 1'b0;
		 mem_to_reg = 1'b0;
		 reg_to_mem = 1'b0;
		 alu_op = opcode[2:0];
		 alu_src = 1'b1;
		 sign_ext_sel = 1'b1;
		 reg_rt_src = 1'b0;
		 RegWrite = 1'b0;
		 load_half = 1'b0;
		 half_spec = 1'b0;
		 end
           
           SRA : begin
		 data_reg = 1'b0;
		 call = 1'b0;
		 rtrn = 1'b0;
		 branch = 1'b0;
		 mem_to_reg = 1'b0;
		 reg_to_mem = 1'b0;
		 alu_op = opcode[2:0];
		 alu_src = 1'b0;
		 sign_ext_sel = 1'b0;
		 reg_rt_src = 1'b0;
		 RegWrite = 1'b0;
		 load_half = 1'b0;
		 half_spec = 1'b0;
		 end
           
           SRL : begin
		 data_reg = 1'b0;
		 call = 1'b0;
		 rtrn = 1'b0;
		 branch = 1'b0;
		 mem_to_reg = 1'b0;
		 reg_to_mem = 1'b0;
		 alu_op = opcode[2:0];
		 alu_src = 1'b0;
		 sign_ext_sel = 1'b0;
		 reg_rt_src = 1'b0;
		 RegWrite = 1'b0;
		 load_half = 1'b0;
		 half_spec = 1'b0;
		 end
           
           SLL : begin
		 data_reg = 1'b0;
		 call = 1'b0;
		 rtrn = 1'b0;
		 branch = 1'b0;
		 mem_to_reg = 1'b0;
		 reg_to_mem = 1'b0;
		 alu_op = opcode[2:0];
		 alu_src = 1'b0;
		 sign_ext_sel = 1'b0;
		 reg_rt_src = 1'b0;
		 RegWrite = 1'b0;
		 load_half = 1'b0;
		 half_spec = 1'b0;
		 end

	   LW :  begin
		 data_reg = 1'b1;
		 call = 1'b0;
		 rtrn = 1'b0;
		 branch = 1'b0;
		 mem_to_reg = 1'b1;
		 reg_to_mem = 1'b0;
		 alu_op = opcode[2:0];
		 alu_src = 1'b1;
		 sign_ext_sel = 1'b0;
		 reg_rt_src = 1'b0;
		 RegWrite = 1'b0;
		 load_half = 1'b0;
		 half_spec = 1'b0;
		 end

	   SW :  begin
		 data_reg = 1'b1;
		 call = 1'b0;
		 rtrn = 1'b0;
		 branch = 1'b0;
		 mem_to_reg = 1'b0;
		 reg_to_mem = 1'b1;
		 alu_op = opcode[2:0];
		 alu_src = 1'b1;
		 sign_ext_sel = 1'b0;
		 reg_rt_src = 1'b1;
		 RegWrite = 1'b0;
		 load_half = 1'b0;
		 half_spec = 1'b0;
		 end

	   LHB : begin
		 data_reg = 1'b0;
		 call = 1'b0;
		 rtrn = 1'b0;
		 branch = 1'b0;
		 mem_to_reg = 1'b0;
		 reg_to_mem = 1'b0;
		 alu_op = opcode[2:0];
		 alu_src = 1'b0;
		 sign_ext_sel = 1'b0;
		 reg_rt_src = 1'b1;
		 RegWrite = 1'b1;
		 load_half = 1'b1;
		 half_spec = 1'b0;
		 end

	   LLB : begin
		 data_reg = 1'b0;
		 call = 1'b0;
		 rtrn = 1'b0;
		 branch = 1'b0;
		 mem_to_reg = 1'b0;
		 reg_to_mem = 1'b0;
		 alu_op = opcode[2:0];
		 alu_src = 1'b0;
		 sign_ext_sel = 1'b0;
		 reg_rt_src = 1'b1;
		 RegWrite = 1'b1;
		 load_half = 1'b1;
		 half_spec = 1'b1;
		 end

	   B :   begin
		 data_reg = 1'b0;
		 call = 1'b0;
		 rtrn = 1'b0;
		 branch = 1'b1;
		 mem_to_reg = 1'b0;
		 reg_to_mem = 1'b0;
		 alu_op = 3'bzzz;
		 alu_src = 1'b0;
		 sign_ext_sel = 1'b0;
		 reg_rt_src = 1'b0;
		 RegWrite = 1'b0;
		 load_half = 1'b0;
		 half_spec = 1'b0;
		 end

	   CALL : begin
		 data_reg = 1'b0;
		 call = 1'b1;
		 rtrn = 1'b0;
		 branch = 1'b0;
		 mem_to_reg = 1'b0;
		 reg_to_mem = 1'b1;
		 alu_op = ADD[2:0];
		 alu_src = 1'b0;
		 sign_ext_sel = 1'b0;
		 reg_rt_src = 1'b0;
		 RegWrite = 1'b1;
		 load_half = 1'b0;
		 half_spec = 1'b0;
		 end

	   RET : begin
		 data_reg = 1'b0;
		 call = 1'b0;
		 rtrn = 1'b1;
		 branch = 1'b0;
		 mem_to_reg = 1'b0;
		 reg_to_mem = 1'b0;
		 alu_op = ADD[2:0];
		 alu_src = 1'b0;
		 sign_ext_sel = 1'b0;
		 reg_rt_src = 1'b0;
		 RegWrite = 1'b1;
		 load_half = 1'b0;
		 half_spec = 1'b0;
		 end

	   ERR : begin end

	   default: begin end

       endcase
      
  end

endmodule