`include "WISC-S15_top_level.sv"
`include "icache_def.sv"

module WISC_S15_top_level_tb();

reg clk,rst;

wire [15:0] pc;

// Halt signal asserted at the end of the program
wire hlt;

integer index;
integer f;		// File descriptor 
integer counter;	// Clock cycle counter

/* Varialbe for tracking the amount 
   of branches and cache hits/misses */
integer branch, cache_hit, cache_miss;

//////////////////////
// Instantiate CPU //
////////////////////
WISC_S15_top_level iCPU(.clk(clk), .rst(rst), .HALT(hlt));

initial begin
  clk = 0;
  counter = 0;
  branch = 0;
  cache_hit = 0;
  cache_miss = 0;
  $display("rst assert\n");
  rst = 1;
  @(posedge clk);
  @(negedge clk);
  rst = 0;
  $display("rst deassert\n");
end

initial begin
  f = $fopen("LwStall_Results.txt","w");
end

// Register file updates 
always @(posedge (iCPU.IDU.reg_mem.we & !clk)) begin

     $fwrite(f, "/*****************************/\n");
     $fwrite(f, "/* Register:\t\t%d\n",iCPU.IDU.reg_mem.dst_addr);
     $fwrite(f, "/* Value:\t\t%h\n",iCPU.IDU.reg_mem.dst);
     $fwrite(f, "/*\n");
     $fwrite(f, "/* Clock cycle:\t%d\n",counter);
     $fwrite(f, "/*****************************/\n");
     $fwrite(f, "\n");
end

// Information regarding delayed branches
always @(posedge (iCPU.PCU.branch & !clk)) begin

     if (iCPU.PCU.PC_src) begin
     	$fwrite(f, "/*********************************************/\n");
     	$fwrite(f, "/* Branch taken @ PC:\t\t%h\n",iCPU.PC_out_1);
	$fwrite(f, "/* After instruction:\t\t%h\n",iCPU.MEMU.main_mem.mem[iCPU.PC_out_1]);
	$fwrite(f, "/*\n");
	$fwrite(f, "/* New PC Target:\t\t%h\n",iCPU.IFU.PC_branch);
	$fwrite(f, "/* Next instruction:\t\t%h\n",iCPU.MEMU.main_mem.mem[iCPU.PCU.PC_update]);
	$fwrite(f, "/*\n");
     	$fwrite(f, "/* Clock cycle:\t\t%d\n",counter);
     	$fwrite(f, "/*********************************************/\n");
     	$fwrite(f, "\n");

	branch++;

     end

     else begin
     	$fwrite(f, "/*********************************************/\n");
     	$fwrite(f, "/* Branch not taken @ PC:\t%h\n",iCPU.PC_out_1);
     	$fwrite(f, "/* After instruction:\t\t%h\n",iCPU.MEMU.main_mem.mem[iCPU.PC_out_1]);
	$fwrite(f, "/*\n");
     	$fwrite(f, "/* Clock cycle:\t\t%d\n",counter);
     	$fwrite(f, "/*********************************************/\n");
     	$fwrite(f, "\n");
     end

end

// Information regarding function calls and their targets
always @(posedge (iCPU.PCU.call & !clk)) begin

	$fwrite(f, "/*********************************************/\n");
     	$fwrite(f, "/* Function call\n");
	$fwrite(f, "/*\n");
     	$fwrite(f, "/* New PC Target:\t\t%h\n",iCPU.PCU.PC_update);
	$fwrite(f, "/* Next instruction:\t\t%h\n",iCPU.MEMU.main_mem.mem[iCPU.PCU.PC_update]);
	$fwrite(f, "/*\n");
     	$fwrite(f, "/* Clock cycle:\t\t%d\n",counter);
     	$fwrite(f, "/*********************************************/\n");
     	$fwrite(f, "\n");

end

// Information regarding function returns and their targets
always @(posedge (iCPU.PCU.ret_in & !clk)) begin

	$fwrite(f, "/*********************************************/\n");
     	$fwrite(f, "/* Function return\n");
	$fwrite(f, "/*\n");
     	$fwrite(f, "/* New PC Target:\t\t%h\n",iCPU.PCU.PC_update);
	$fwrite(f, "/* Next instruction:\t\t%h\n",iCPU.MEMU.main_mem.mem[iCPU.PCU.PC_update]);
	$fwrite(f, "/*\n");
     	$fwrite(f, "/* Clock cycle:\t\t%d\n",counter);
     	$fwrite(f, "/*********************************************/\n");
     	$fwrite(f, "\n");

end

// Tallies the amount of cache misses
always @(posedge (iCPU.IFU.cc.ctag.tag_req.we & !clk)) begin

	cache_miss++;

end

// Tallies the amount of cache hits
always @(posedge (iCPU.IFU.cpu_res.ready & !iCPU.IFU.hazard)) begin

	cache_hit++;

end

// Gives the final results of the test simulation
initial begin

  @(posedge hlt)

     $fwrite(f, "/*****************************/\n");
     $fwrite(f, "/* Test Bench Complete\n");
     $fwrite(f, "/* Clock cycles:\t%d\n", (counter - 2)); // Our halt instruction takes 2 extra clock cycles to end the simulation
     $fwrite(f, "/*\n");
     $fwrite(f, "/*\n");
     $fwrite(f, "/* Final Register Values:\n");
     $fwrite(f, "/*\n");
     for(index=1; index<16; index = index+1)
       $fwrite(f, "/*\tR%1h = %h\n",index,iCPU.IDU.reg_mem.mem[index]);

     $fwrite(f, "/*\n");
     $fwrite(f, "/* Branches taken: %d\n",branch);
     $fwrite(f, "/*\n");
     $fwrite(f, "/* Cache misses: %d\n",cache_miss);
     $fwrite(f, "/*\n");
     $fwrite(f, "/* Cache hits: %d\n",cache_hit);
     $fwrite(f, "/*\n");
     $fwrite(f, "/*****************************/\n");
     
     // Close the file descriptor and end the simulation
     $fclose(f);
     $stop;
end 
  
always begin
  #1 clk = ~clk;
  	if (clk) counter++;
end

endmodule