`include "ALU.sv"

module ALU_tb();
	
reg clk;

//DUT Inputs
reg signed [15:0] stim1, stim2;
reg [3:0] shift;
reg signed [7:0] load_half_imm;
reg [2:0] control;

//DUT OUTPUTS
wire done;
wire [15:0] result;
wire [2:0] flags;

reg passed;
reg tmp1;		//temporary variables
reg tmp2;		//
reg unsigned [4:0] i;	//
reg [4:0] ctr;		//
reg [15:0] stim_cache;	//

   localparam   ADD   =   3'b000;
   localparam   SUB   =   3'b001;
   localparam   NAND  =   3'b010;
   localparam   XOR   =   3'b011;
   localparam   INC   =   3'b100;
   localparam   SRA   =   3'b101;
   localparam   SRL   =   3'b110;
   localparam   SLL   =   3'b111;  

ALU ALU_DUT(.data_one(stim1), .data_two(stim2), .shift(shift), .control(control), 
	.done(done), .result(result), .flags(flags));
                            
initial begin

	clk = 0;
	
	#20;
	
	/* Begin ADD */
	stim1 = -32768;
	stim2 = -32768;
	shift = 4'b0000;
	load_half_imm = 8'b00000000;
	control = ADD;
	passed = 1'b1;
	#1
	while(stim1 <= 32694) begin
		stim2 = -32768;
		#1
		while(stim2 <= 32694) begin		
			//test that each bit is correct
			//tmp1 --> C_in[i-1], eventually cout[15]
			//tmp2 --> cout[14] (for overflow)
			tmp1 = 1'b0;
			i = 5'b00000;
			#1
			while(i < 16) begin
				#1
				if(i == 5'b01111) begin
					tmp2 = tmp1;
				end
				case({stim1[i], stim2[i], tmp1})
		
				3'b000: begin
						tmp1 = 1'b0;
						if(ALU_DUT.result[i] != 1'b0) begin
					 	 	passed = 1'b0;
						end
					end
				3'b001: begin
						tmp1 = 1'b0;
						if(ALU_DUT.result[i] != 1'b1) begin
					 	 	passed = 1'b0;
						end
					end
				3'b010: begin
						tmp1 = 1'b0;
						if(ALU_DUT.result[i] != 1'b1) begin
					 	 	passed = 1'b0;
						end
					end
				3'b011: begin
						tmp1 = 1'b1;
						if(ALU_DUT.result[i] != 1'b0) begin
					 	 	passed = 1'b0;
						end
					end
				3'b100: begin
						tmp1 = 1'b0;
						if(ALU_DUT.result[i] != 1'b1) begin
					 	 	passed = 1'b0;
						end
					end
				3'b101: begin
						tmp1 = 1'b1;
						if(ALU_DUT.result[i] != 1'b0) begin
					 	 	passed = 1'b0;
						end
					end
				3'b110: begin
						tmp1 = 1'b1;
						if(ALU_DUT.result[i] != 1'b0) begin
					 	 	passed = 1'b0;
						end
					end
				3'b111: begin
						tmp1 = 1'b1;
						if(ALU_DUT.result[i] != 1'b1) begin
						  	passed = 1'b0;
						end
					end
				
				endcase
			i = i + 1;
			end
			//test flags
			#5
			//zero
			if(ALU_DUT.result == 0) begin
				if(flags[2] != 1'b1) begin
					passed = 1'b0;
				end
			end
			else begin
				if(flags[2] != 1'b0) begin
					passed = 1'b0;
				end
			end
			//overflow
			if((tmp1 ^ tmp2) == 1'b0) begin
				if(flags[1] != 1'b0) begin
					passed = 1'b0;
				end
			end
			else begin
				if(flags[1] != 1'b1) begin
					passed = 1'b0;
				end
			end
			//sign
			if(ALU_DUT.result[15] == 1'b0) begin
				if(flags[0] != 1'b0) begin
					passed = 1'b0;
				end
			end
			else begin
				if(flags[0] != 1'b1) begin
					passed = 1'b0;
				end
			end
			stim2 = stim2 + 73;
		end
		stim1 = stim1 + 73;
	end
	if (passed) begin 
		$display("ADD TEST PASSED.");
	end
	else begin 
		$display("ADD TEST FAILED.");
		$display("ENDING TEST PREMATURELY...");
		$stop;
	end
	/* End ADD */

	#20;
	
	/* Begin SUB */
	stim1 = -32768;
	stim2 = -32768;
	shift = 4'b0000;
	load_half_imm = 8'b00000000;
	control = SUB;
	passed = 1'b1;
	#1
	while(stim1 <= 32694) begin
		stim2 = -32768;
		#1
		while(stim2 <= 32694) begin		
			//test that each bit is correct
			//tmp1 --> C_in[i-1], eventually cout[15]
			//tmp2 --> cout[14] (for overflow)
			tmp1 = 1'b0;
			i = 5'b00000;
			#1
			while(i < 16) begin
				#1
				if(i == 5'b01111) begin
					tmp2 = tmp1;
				end
				case({stim1[i], stim2[i], tmp1})
		
				3'b000: begin
						tmp1 = 1'b0;
						if(ALU_DUT.result[i] != 1'b0) begin
					 	 	passed = 1'b0;
						end
					end
				3'b001: begin
						tmp1 = 1'b1;
						if(ALU_DUT.result[i] != 1'b1) begin
					 	 	passed = 1'b0;
						end
					end
				3'b010: begin
						tmp1 = 1'b1;
						if(ALU_DUT.result[i] != 1'b1) begin
					 	 	passed = 1'b0;
						end
					end
				3'b011: begin
						tmp1 = 1'b1;
						if(ALU_DUT.result[i] != 1'b0) begin
					 	 	passed = 1'b0;
						end
					end
				3'b100: begin
						tmp1 = 1'b0;
						if(ALU_DUT.result[i] != 1'b1) begin
					 	 	passed = 1'b0;
						end
					end
				3'b101: begin
						tmp1 = 1'b0;
						if(ALU_DUT.result[i] != 1'b0) begin
					 	 	passed = 1'b0;
						end
					end
				3'b110: begin
						tmp1 = 1'b0;
						if(ALU_DUT.result[i] != 1'b0) begin
					 	 	passed = 1'b0;
						end
					end
				3'b111: begin
						tmp1 = 1'b1;
						if(ALU_DUT.result[i] != 1'b1) begin
						  	passed = 1'b0;
						end
					end
				
				endcase
			i = i + 1;
			end
			//test flags
			#5
			//zero
			if(ALU_DUT.result == 0) begin
				if(flags[2] != 1'b1) begin
					passed = 1'b0;
				end
			end
			else begin
				if(flags[2] != 1'b0) begin
					passed = 1'b0;
				end
			end
			//overflow
			case({stim1[15], stim2[15]})
			2'b00:	begin
					if(flags[1] != 1'b0) begin
						passed = 1'b0;
					end
				end
			2'b01: 	begin
					if(result[15] == 1'b1) begin	//if overflow
						if(flags[1] != 1'b1) begin	//flag must be set
							passed = 1'b0;
						end
					end
					else begin			//if not overflow
						if(flags[1] != 1'b0) begin	//flag must be clear
							passed = 1'b0;
						end
					end

				end
			2'b10:	begin
					if(result[15] == 1'b0) begin	//if overflow
						if(flags[1] != 1'b1) begin	//flag must be set
							passed = 1'b0;
						end
					end
					else begin
						if(flags[1] != 1'b0) begin	//if not overflow
							passed = 1'b0;		//flag must be clear
						end
					end
				end
			2'b11:	begin
					if(flags[1] != 1'b0) begin
						passed = 1'b0;
					end
				end
		 	endcase
			//sign
			if(ALU_DUT.result[15] == 1'b0) begin
				if(flags[0] != 1'b0) begin
					passed = 1'b0;
				end
			end
			else begin
				if(flags[0] != 1'b1) begin
					passed = 1'b0;
				end
			end
			stim2 = stim2 + 73;
		end
		stim1 = stim1 + 73;
	end
	if (passed) begin 
		$display("SUB TEST PASSED.");
	end
	else begin 
		$display("SUB TEST FAILED.");
		$display("ENDING TEST PREMATURELY...");
		$stop;
	end
	/* End SUB */

	#20;
	
	/* Begin NAND */
	stim1 = -32768;
	stim2 = -32768;
	shift = 4'b0000;
	load_half_imm = 8'b00000000;
	control = NAND;
	passed = 1'b1;
	#1
	while(stim1 <= 32694) begin
		stim2 = -32768;
		#1
		while(stim2 <= 32694) begin
			tmp1 = 1'b0;
			i = 5'b00000;
			//test that each bit is correct
			#1
			while(i < 16) begin
				#1
				if(stim1[i] == 1'b0 && stim2[i] == 1'b0) begin
					tmp1 = 1'b1;
				end
				else if(stim1[i] == 1'b0 && stim2[i] == 1'b1) begin
					tmp1 = 1'b1;
				end
				else if(stim1[i] == 1'b1 && stim2[i] == 1'b0) begin
					tmp1 = 1'b1;
				end
				else if(stim1[i] == 1'b1 && stim2[i] == 1'b1) begin
					tmp1 = 1'b0;
				end
				//if bit is incorrect
				if(ALU_DUT.result[i] != tmp1) begin
				  	passed = 1'b0;
				end
			i = i + 1;
			end
			//test flags
			#5
			//zero
			if(ALU_DUT.result == 0) begin
				if(flags[2] != 1'b1) begin
					passed = 1'b0;
				end
			end
			else begin
				if(flags[2] != 1'b0) begin
					passed = 1'b0;
				end
			end
			//overflow & sign
			if(flags[1] != 1'b0 || flags[0] != 1'b0) begin
				passed = 1'b0;
			end
			stim2 = stim2 + 73;
		end
		stim1 = stim1 + 73;
	end
	if (passed) begin 
		$display("NAND TEST PASSED.");
	end
	else begin 
		$display("NAND TEST FAILED.");
		$display("ENDING TEST PREMATURELY...");
		$stop;
	end
	/* End NAND */

	#20;

	/* Begin INC */
	stim1 = -32768;
	stim2 = -32768;
	shift = 4'b0000;
	load_half_imm = 8'b00000000;
	control = INC;
	passed = 1'b1;
	#1
	while(stim1 <= 32694) begin
		stim2 = -32768;
		#1
		while(stim2 <= 32694) begin		
			//test that each bit is correct
			//tmp1 --> C_in[i-1], eventually cout[15]
			//tmp2 --> cout[14] (for overflow)
			tmp1 = 1'b0;
			i = 5'b00000;
			#1
			while(i < 16) begin
				#1
				if(i == 5'b01111) begin
					tmp2 = tmp1;
				end
				case({stim1[i], stim2[i], tmp1})
		
				3'b000: begin
						tmp1 = 1'b0;
						if(ALU_DUT.result[i] != 1'b0) begin
					 	 	passed = 1'b0;
						end
					end
				3'b001: begin
						tmp1 = 1'b0;
						if(ALU_DUT.result[i] != 1'b1) begin
					 	 	passed = 1'b0;
						end
					end
				3'b010: begin
						tmp1 = 1'b0;
						if(ALU_DUT.result[i] != 1'b1) begin
					 	 	passed = 1'b0;
						end
					end
				3'b011: begin
						tmp1 = 1'b1;
						if(ALU_DUT.result[i] != 1'b0) begin
					 	 	passed = 1'b0;
						end
					end
				3'b100: begin
						tmp1 = 1'b0;
						if(ALU_DUT.result[i] != 1'b1) begin
					 	 	passed = 1'b0;
						end
					end
				3'b101: begin
						tmp1 = 1'b1;
						if(ALU_DUT.result[i] != 1'b0) begin
					 	 	passed = 1'b0;
						end
					end
				3'b110: begin
						tmp1 = 1'b1;
						if(ALU_DUT.result[i] != 1'b0) begin
					 	 	passed = 1'b0;
						end
					end
				3'b111: begin
						tmp1 = 1'b1;
						if(ALU_DUT.result[i] != 1'b1) begin
						  	passed = 1'b0;
						end
					end
				
				endcase
			i = i + 1;
			end
			//test flags
			#5
			//zero
			if(ALU_DUT.result == 0) begin
				if(flags[2] != 1'b1) begin
					passed = 1'b0;
				end
			end
			else begin
				if(flags[2] != 1'b0) begin
					passed = 1'b0;
				end
			end
			//overflow
			if((tmp1 ^ tmp2) == 1'b0) begin
				if(flags[1] != 1'b0) begin
					passed = 1'b0;
				end
			end
			else begin
				if(flags[1] != 1'b1) begin
					passed = 1'b0;
				end
			end
			//sign
			if(ALU_DUT.result[15] == 1'b0) begin
				if(flags[0] != 1'b0) begin
					passed = 1'b0;
				end
			end
			else begin
				if(flags[0] != 1'b1) begin
					passed = 1'b0;
				end
			end
			stim2 = stim2 + 73;
		end
		stim1 = stim1 + 73;
	end
	if (passed) begin 
		$display("INC TEST PASSED.");
	end
	else begin 
		$display("INC TEST FAILED.");
		$display("ENDING TEST PREMATURELY...");
		$stop;
	end
	/* End INC */

	#20;
	
	/* Begin XOR */
	stim1 = -32768;
	stim2 = -32768;
	shift = 4'b0000;
	load_half_imm = 8'b00000000;
	control = XOR;
	passed = 1'b1;
	#1
	while(stim1 <= 32694) begin
		stim2 = -32768;
		#1
		while(stim2 <= 32694) begin
			tmp1 = 1'b0;
			i = 5'b00000;
			//test that each bit is correct
			#1
			while(i < 16) begin
				#1
				if(stim1[i] == 1'b0 && stim2[i] == 1'b0) begin
					tmp1 = 1'b0;
				end
				else if(stim1[i] == 1'b0 && stim2[i] == 1'b1) begin
					tmp1 = 1'b1;
				end
				else if(stim1[i] == 1'b1 && stim2[i] == 1'b0) begin
					tmp1 = 1'b1;
				end
				else if(stim1[i] == 1'b1 && stim2[i] == 1'b1) begin
					tmp1 = 1'b0;
				end
				//if bit is incorrect
				if(ALU_DUT.result[i] != tmp1) begin
				  	passed = 1'b0;
				end
			i = i + 1;
			end
			//test flags
			#5
			//zero
			if(ALU_DUT.result == 0) begin
				if(flags[2] != 1'b1) begin
					passed = 1'b0;
				end
			end
			else begin
				if(flags[2] != 1'b0) begin
					passed = 1'b0;
				end
			end
			stim2 = stim2 + 73;
		end
		stim1 = stim1 + 73;
	end
	if (passed) begin 
		$display("XOR TEST PASSED.");
	end
	else begin 
		$display("XOR TEST FAILED.");
		$display("ENDING TEST PREMATURELY...");
		$stop;
	end
	/* End XOR */
   
	#20

	/* Begin SRA  */
	stim1 = -32768;
	stim2 = -32768;
	shift = 4'b0000;
	load_half_imm = 8'b00000000;
	control = SRA;
	passed = 1'b1;
	#1
	while(stim1 <= 32694) begin
		ctr = 4'b0000;
		shift = 4'b0000;
		stim_cache = stim1;
		#1
		while(ctr <= 15) begin
			tmp1 = 1'b0;
			i = 5'b00000;
			//test that each bit is correct
			#1
			while(i < 16) begin
				#1
				if((i+shift) > 15) begin	//if bit test is out-of-bounds, use 0
					tmp1 = stim_cache[15];
				end
				else begin			//otherwise, use expected bit.
					tmp1 = stim_cache[i+shift];
				end
				if(ALU_DUT.result[i] != tmp1) begin
				  	passed = 1'b0;
				end
			i = i + 1;
			end
			//no flag test, leave flags alone
			stim1 = stim_cache;
			shift = shift + 1;
			ctr = ctr + 1;
		end
		stim1 = stim1 + 73;
	end
	if (passed) begin 
		$display("SRA TEST PASSED.");
	end
	else begin 
		$display("SRA TEST FAILED.");
		$display("ENDING TEST PREMATURELY...");
		$stop;
	end
	/* End SRA */

	#20

	/* Begin SRL  */
	stim1 = -32768;
	stim2 = -32768;
	shift = 4'b0000;
	load_half_imm = 8'b00000000;
	control = SRL;
	passed = 1'b1;
	#1
	while(stim1 <= 32694) begin
		ctr = 4'b0000;
		shift = 4'b0000;
		stim_cache = stim1;
		#1
		while(ctr <= 15) begin
			tmp1 = 1'b0;
			i = 5'b00000;
			//test that each bit is correct
			#1
			while(i < 16) begin
				#1
				if((i+shift) > 15) begin	//if bit test is out-of-bounds, use 0
					tmp1 = 1'b0;
				end
				else begin			//otherwise, use expected bit.
					tmp1 = stim_cache[i+shift];
				end
				if(ALU_DUT.result[i] != tmp1) begin
				  	passed = 1'b0;
				end
			i = i + 1;
			end
			//no flag test, leave flags alone
			stim1 = stim_cache;
			shift = shift + 1;
			ctr = ctr + 1;
		end
		stim1 = stim1 + 73;
	end
	if (passed) begin 
		$display("SRL TEST PASSED.");
	end
	else begin 
		$display("SRL TEST FAILED.");
		$display("ENDING TEST PREMATURELY...");
		$stop;
	end
	/* End SRL */

	#20;

	/* Begin SLL  */
	stim1 = -32768;
	stim2 = -32768;
	shift = 4'b0000;
	load_half_imm = 8'b00000000;
	control = SLL;
	passed = 1'b1;
	#1
	while(stim1 <= 32694) begin
		ctr = 4'b0000;
		shift = 4'b0000;
		stim_cache = stim1;
		#1
		while(ctr <= 15) begin
			tmp1 = 1'b0;
			i = 5'b00000;
			//test that each bit is correct
			#1
			while(i < 16) begin
				#1
				if((i-shift) < 0) begin	//if bit test is out-of-bounds, use 0
					tmp1 = 1'b0;
				end
				else begin			//otherwise, use expected bit.
					tmp1 = stim_cache[i-shift];
				end
				if(ALU_DUT.result[i] != tmp1) begin
				  	passed = 1'b0;
				end
			i = i + 1;
			end
			//no flag test, leave flags alone.
			stim1 = stim_cache;
			shift = shift + 1;
			ctr = ctr + 1;
		end
		stim1 = stim1 + 73;
	end
	if (passed) begin 
		$display("SLL TEST PASSED.");
	end
	else begin 
		$display("SLL TEST FAILED.");
		$display("ENDING TEST PREMATURELY...");
		$stop;
	end
	/* End SLL */

	// TEST PASSED
	$display("ALU TEST PASSED.");
   
	$stop;
   
end

always begin
	#1 clk = ~clk;
end

endmodule
