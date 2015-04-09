module ALU_tb();
	
reg clk;

//DUT Inputs
reg signed [15:0] stim1, stim2;
reg [3:0] shift_amt;
reg signed [7:0] load_half_imm;
reg [2:0] control;

//DUT OUTPUTS
wire done;
wire [15:0] result;
wire [2:0] flags;

reg passed;
reg tmp;

ALU ALU_DUT(.data_one(stim1), .data_two(stim2), .shift(shift_amt), 
		.load_half_imm(load_half_imm), .control(control), 
	.done(done), .result(result), .flags(flags));
                            
initial begin

	clk = 0;
	
	#20;
	
	/* Begin ADD  */					//FIX THIS
	stim1 = -32768;
	stim2 = -32768;
	shift = 4'b0000;
	load_half_imm = 8'b00000000;
	control = 4'b0000;
	passed = 1'b1;
	#5
	for (stim1 <= 32767) begin
		for(stim2 <= 32767) begin
			#5 
			{cout, result} = stim1 + stim2;
			if(ALU_DUT.cout != cout 
			|| ALU_DUT.result != result) begin
			  
			end
			//test correct cout, result
			//test flags
			stim2 = stim2 + 1;
		end
		stim1 = stim1 + 1;
	end
	if (passed) begin 
		$display("ADD TEST PASSED.");
	end
	else begin 
		$display("ADD TEST FAILED.");
		$stop;
	end
	/* End ADD */

	#20;
	
	/* Begin XOR  */
	stim1 = -32768;
	stim2 = -32768;
	shift = 4'b0000;
	load_half_imm = 8'b00000000;
	control = 4'b0000;
	passed = 1'b1;
	#5
	for (stim1 <= 32767) begin
		for(stim2 <= 32767) begin
			#5 
			//test that each bit is correct
			for(int i = 0; i < 16; i++) begin
				if(stim1[i] == 1'b0 && stim2[i] == 1'b0) begin
					tmp = 1'b0;
				end
				else if(stim1[i] == 1'b0 && stim2[i] == 1'b1) begin
					tmp = 1'b1;
				end
				else if(stim1[i] == 1'b1 && stim2[i] == 1'b0) begin
					tmp = 1'b1;
				end
				else if(stim1[i] == 1'b1 && stim2[i] == 1'b1) begin
					tmp = 1'b0;
				end
				//if bit is incorrect
				if(ALU_DUT.result != tmp) begin
				  	passed = 1'b0;
				end
			end
			//test flags
			#5
			if(ALU_DUT.result == 0) begin
				if(flags[2] != 1) begin
					passed = 1'b0;
				end
			end
			else begin
				if(flags[2] != 0) begin
					passed = 1'b0;
				end
			end
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
		$stop;
	end
	/* End ADD */
   
	$stop;
   
end

always begin
	#5 clk = ~clk;
end

endmodule
