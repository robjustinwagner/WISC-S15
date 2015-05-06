`include "Control_Logic.sv"

module Control_Logic_tb();
	
reg clk;

//DUT Inputs
wire [15:0] instruction;
reg [3:0] opcode;    //4-bit instruction opcode

//DUT OUTPUTS
wire data_reg;	/* Control signal to Regfile to
                     specifiy the contents of the 
                     Data Segment Register for
                     supplying read_data_1 */
wire call;		   /* Control signal to RegFile to
                     specify the contents of the
                     Stack_Pointer Register for
                     supplying read_data_1 */
wire rtrn;
wire stack_reg;
wire	branch;            // branching control; 0-2 sensitive, 3 pick 
wire mem_to_reg;      // LW signal to Memory unit 
wire	reg_to_mem;      // SW signal to Memory unit
wire	[2:0] alu_op;      // ALU control unit input
wire	alu_src;         // ALU operand seleciton
wire	sign_ext_sel;    // sign extend select bit
wire	reg_rt_src;      // Read_reg_2 proper SW select
wire	RegWrite;
wire	MemRead;
wire	MemWrite;
wire	load_half;      // Specifies the ALU result
wire	half_spec;      // (0 -> LHB, 1 -> LLB)
wire HALT;

reg passed;

assign instruction[15:12] = opcode;

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

Control_Logic Control_Logic_DUT(.*);
                            
initial begin

	clk = 0;
	
	#20;

	opcode = 4'b0000;
	passed = 1'b1;
	#5
	while(opcode < 15) begin
		#5
		//data_reg
		if(opcode == LW || opcode == SW) begin
			if(data_reg != 1'b1) begin
				passed = 1'b0;
			end
		end
		else begin
			if(data_reg != 1'b0) begin
				passed = 1'b0;
			end
		end
		//stack_reg
		if(opcode == CALL || opcode == RET) begin
		   if(stack_reg != 1'b1) begin
		          passed = 1'b0;
		       end
		end
		else begin
			if(stack_reg != 1'b0) begin
				passed = 1'b0;
			end
		end
		//call
		if(opcode == CALL) begin
			if(call != 1'b1) begin
				passed = 1'b0;
			end
		end
		else begin
			if(call != 1'b0) begin
				passed = 1'b0;
			end
		end
		//rtrn
		if(opcode == RET) begin
			if(rtrn != 1'b1) begin
				passed = 1'b0;
			end
		end
		else begin
			if(rtrn != 1'b0) begin
				passed = 1'b0;
			end
		end
		//branch
		if(opcode == B) begin
			if(branch != 1'b1) begin
				passed = 1'b0;
			end
		end
		else begin
			if(branch != 1'b0) begin
				passed = 1'b0;
			end
		end
		//mem_to_reg
		if(opcode == LW) begin
			if(mem_to_reg != 1'b1) begin
				passed = 1'b0;
			end
		end
		else begin
			if(mem_to_reg != 1'b0) begin
				passed = 1'b0;
			end
		end
		//reg_to_mem
		if(opcode == SW || opcode == CALL) begin
			if(reg_to_mem != 1'b1) begin
				passed = 1'b0;
			end
		end
		else begin
			if(reg_to_mem != 1'b0) begin
				passed = 1'b0;
			end
		end
		//alu_op
		if(opcode == CALL || opcode == RET || opcode == SW || opcode == LW) begin
			if(alu_op != ADD[2:0]) begin
				passed = 1'b0;
			end
		end
		else begin
			if(alu_op != opcode[2:0]) begin
				passed = 1'b0;
			end
		end
		//alu_src
		if(opcode == LW || opcode == SW || opcode == INC) begin
			if(alu_src != 1'b1) begin
				passed = 1'b0;
			end
		end
		else begin
			if(alu_src != 1'b0) begin
				passed = 1'b0;
			end
		end
		//sign_ext_sel
		if(opcode == LW || opcode == SW || opcode == B) begin
			if(sign_ext_sel != 1'b1) begin
				passed = 1'b0;
			end
		end
		else begin
			if(sign_ext_sel != 1'b0) begin
				passed = 1'b0;
			end
		end
		//reg_rt_src
		if(opcode == LHB || opcode == LLB || opcode == SW) begin
			if(reg_rt_src != 1'b1) begin
				passed = 1'b0;
			end
		end
		else begin
			if(reg_rt_src != 1'b0) begin
				passed = 1'b0;
			end
		end
		//RegWrite
		if(opcode == SW || opcode == B || opcode == ERR) begin
			if(RegWrite != 1'b0) begin
				passed = 1'b0;
			end
		end
		else begin
			if(RegWrite != 1'b1) begin
				passed = 1'b0;
			end
		end
		//MemRead
		if(opcode == LW || opcode == RET) begin
			if(MemRead != 1'b1) begin
				passed = 1'b0;
			end
		end
		else begin
			if(MemRead != 1'b0) begin
				passed = 1'b0;
			end
		end
		//MemWrite
		if(opcode == SW || opcode == CALL) begin
			if(MemWrite != 1'b1) begin
				passed = 1'b0;
			end
		end
		else begin
			if(MemWrite != 1'b0) begin
				passed = 1'b0;
			end
		end
		//load_half
		if(opcode == LLB || opcode == LHB) begin
			if(load_half != 1'b1) begin
				passed = 1'b0;
			end
		end
		else begin
			if(load_half != 1'b0) begin
				passed = 1'b0;
			end
		end
		//half_spec
		if(opcode == LLB) begin
			if(half_spec != 1'b1) begin
				passed = 1'b0;
			end
		end
		else begin
			if(half_spec != 1'b0) begin
				passed = 1'b0;
			end
		end
		//HALT
		if(opcode == ERR) begin
			if(HALT != 1'b1) begin
				passed = 1'b0;
			end
		end
		else begin
			if(HALT != 1'b0) begin
				passed = 1'b0;
			end
		end


		//update opcode
		opcode = opcode + 1;	
		//if at any point test fails, stop test
		if (!passed) begin 
			$display("CONTROL LOGIC TEST FAILED.");
			$stop;
		end
	end

	// TEST PASSED
	$display("CONTROL LOGIC TEST PASSED.");
   
	$stop;
   
end

always begin
	#5 clk = ~clk;
end

endmodule