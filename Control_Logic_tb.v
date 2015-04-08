module Control_Logic_tb();
	
reg clk;

//DUT Inputs
reg signed [15:0] stim1, stim2;
reg [3:0] shift_amt;
reg signed [7:0] load_half_imm;
reg [2:0] control;

//DUT 
reg cout;
reg [15:0] result;

//DUT OUTPUTS
wire done;
wire [15:0] result;
wire [2:0] flags;

reg passed;

ALU ALU_DUT(.data_one(stim1), .data_two(stim2), .shift(shift_amt), 
		.load_half_imm(load_half_imm), .control(control), 
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
	passed = 1'b0;
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

   
	$stop;
   
end

always begin
	#5 clk = ~clk;
end

endmodule