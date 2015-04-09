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
reg [3:0] ctr;		//
reg [15:0] stim_cache;	//

ALU ALU_DUT(.data_one(stim1), .data_two(stim2), .shift(shift_amt), .control(control), 
	.done(done), .result(result), .flags(flags));
                            
initial begin

	clk = 0;
	
	#20;
	
	/* Begin ADD  */
	stim1 = -32768;
	stim2 = -32768;
	shift = 4'b0000;
	load_half_imm = 8'b00000000;
	control = 4'b0000;
	passed = 1'b1;
	#5
	while(stim1 <= 32767) begin
		while(stim2 <= 32767) begin
			#5			
			//test that each bit is correct
			//tmp1 --> C_in[i-1], eventually cout[15]
			//tmp2 --> cout[14] (for overflow)
			tmp1 = 1'b0;
			for(int i = 0; i < 16; i++) begin
				if(i == 15) begin
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
			end
			//check cout bit
			if(ALU_DUT.cout != tmp1) begin
				passed = 1'b0;
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
			if(tmp1 == 1'b0) begin
				if(flags[0] != 1'b0) begin
					passed = 1'b0;
				end
			end
			else begin
				if(flags[0] != 1'b1) begin
					passed = 1'b0;
				end
			end
			stim2 = stim2 + 1;
		end
		stim1 = stim1 + 1;
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
	
	/* Begin SUB  */
	stim1 = -32768;
	stim2 = -32768;
	shift = 4'b0000;
	load_half_imm = 8'b00000000;
	control = 4'b0000;
	passed = 1'b1;
	#5
	while(stim1 <= 32767) begin
		while(stim2 <= 32767) begin
			#5			
			//test that each bit is correct
			//tmp1 --> C_in[i-1], eventually cout[15]
			//tmp2 --> cout[14] (for overflow)
			tmp1 = 1'b0;
			for(int i = 0; i < 16; i++) begin
				if(i == 15) begin
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
			end
			//check cout bit
			if(ALU_DUT.cout != tmp1) begin
				passed = 1'b0;
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
			if(tmp1 == 1'b0) begin
				if(flags[0] != 1'b0) begin
					passed = 1'b0;
				end
			end
			else begin
				if(flags[0] != 1'b1) begin
					passed = 1'b0;
				end
			end
			stim2 = stim2 + 1;
		end
		stim1 = stim1 + 1;
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
	
	/* Begin NAND  */
	stim1 = -32768;
	stim2 = -32768;
	shift = 4'b0000;
	load_half_imm = 8'b00000000;
	control = 4'b0000;
	passed = 1'b1;
	#5
	while(stim1 <= 32767) begin
		while(stim2 <= 32767) begin
			#5 
			//test that each bit is correct
			for(int i = 0; i < 16; i++) begin
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
				if(ALU_DUT.result != tmp1) begin
				  	passed = 1'b0;
				end
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
			stim2 = stim2 + 1;
		end
		stim1 = stim1 + 1;
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
	control = 4'b0000;
	passed = 1'b1;
	#5
	while(stim1 <= 32767) begin
		while(stim2 <= 32767) begin
			#5			
			//test that each bit is correct
			//tmp1 --> C_in[i-1], eventually cout[15]
			//tmp2 --> cout[14] (for overflow)
			tmp1 = 1'b0;
			for(int i = 0; i < 16; i++) begin
				if(i == 15) begin
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
			end
			//check cout bit
			if(ALU_DUT.cout != tmp1) begin
				passed = 1'b0;
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
			if(tmp1 == 1'b0) begin
				if(flags[0] != 1'b0) begin
					passed = 1'b0;
				end
			end
			else begin
				if(flags[0] != 1'b1) begin
					passed = 1'b0;
				end
			end
			stim2 = stim2 + 1;
		end
		stim1 = stim1 + 1;
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
	
	/* Begin XOR  */
	stim1 = -32768;
	stim2 = -32768;
	shift = 4'b0000;
	load_half_imm = 8'b00000000;
	control = 4'b0000;
	passed = 1'b1;
	#5
	while(stim1 <= 32767) begin
		while(stim2 <= 32767) begin
			#5 
			//test that each bit is correct
			for(int i = 0; i < 16; i++) begin
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
				if(ALU_DUT.result != tmp1) begin
				  	passed = 1'b0;
				end
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
			stim2 = stim2 + 1;
		end
		stim1 = stim1 + 1;
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
	control = 4'b0000;
	passed = 1'b1;
	#5
	while(stim1 <= 32767) begin
		ctr = 4'b0000;
		shift = 4'b0000;
		stim_cache = stim1;
		while(ctr <= 15) begin
			#5 
			//test that each bit is correct
			for(int i = 0; i <= 15; i++) begin
				if((i+shift) > 15) begin	//if bit test is out-of-bounds, use 0
					tmp1 = stim_cache[15];
				end
				else begin			//otherwise, use expected bit.
					tmp1 = stim_cache[i+shift];
				end
				if(ALU_DUT.result[i] != tmp1) begin
				  	passed = 1'b0;
				end
			end
			//no flag test, leave flags alone
			stim1 = stim_cache;
			shift = shift + 1;
			ctr = ctr + 1;
		end
		stim1 = stim1 + 1;
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
	control = 4'b0000;
	passed = 1'b1;
	#5
	while(stim1 <= 32767) begin
		ctr = 4'b0000;
		shift = 4'b0000;
		stim_cache = stim1;
		while(ctr <= 15) begin
			#5 
			//test that each bit is correct
			for(int i = 0; i <= 15; i++) begin
				if((i+shift) > 15) begin	//if bit test is out-of-bounds, use 0
					tmp1 = 1'b0;
				end
				else begin			//otherwise, use expected bit.
					tmp1 = stim_cache[i+shift];
				end
				if(ALU_DUT.result[i] != tmp1) begin
				  	passed = 1'b0;
				end
			end
			//no flag test, leave flags alone
			stim1 = stim_cache;
			shift = shift + 1;
			ctr = ctr + 1;
		end
		stim1 = stim1 + 1;
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

	/* Begin SLL  */
	stim1 = -32768;
	stim2 = -32768;
	shift = 4'b0000;
	load_half_imm = 8'b00000000;
	control = 4'b0000;
	passed = 1'b1;
	#5
	while(stim1 <= 32767) begin
		ctr = 4'b0000;
		shift = 4'b0000;
		stim_cache = stim1;
		while(ctr <= 15) begin
			#5 
			//test that each bit is correct
			for(int i = 0; i <= 15; i++) begin
				if((i-shift) < 0) begin	//if bit test is out-of-bounds, use 0
					tmp1 = 1'b0;
				end
				else begin			//otherwise, use expected bit.
					tmp1 = stim_cache[i-shift];
				end
				if(ALU_DUT.result[i] != tmp1) begin
				  	passed = 1'b0;
				end
			end
			//no flag test, leave flags alone
			stim1 = stim_cache;
			shift = shift + 1;
			ctr = ctr + 1;
		end
		stim1 = stim1 + 1;
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

	$stop;
   
end

always begin
	#5 clk = ~clk;
end

endmodule
