`include "WISC-S15_top_level.sv"
`include "icache_def.sv"
//import icache_def::*;

module WISC_S15_top_level_tb();

reg clk,rst;

wire [15:0] pc;

wire hlt;

integer index, f, counter;

//////////////////////
// Instantiate CPU //
////////////////////
WISC_S15_top_level iCPU(.clk(clk), .rst(rst), .HALT(hlt));

initial begin
  clk = 0;
  counter = 0;
  $display("rst assert\n");
  rst = 1;
  @(posedge clk);
  @(negedge clk);
  rst = 0;
  $display("rst deassert\n");
end

initial begin
  f = $fopen("Branch_Results.txt","w");
end

always @(posedge (iCPU.IDU.reg_mem.we & !clk)) begin

     $fwrite(f, "/*****************************/\n");
     $fwrite(f, "/* Register:\t\t%d\n",iCPU.IDU.reg_mem.dst_addr);
     $fwrite(f, "/* Value:\t\t%h\n",iCPU.IDU.reg_mem.dst);
     $fwrite(f, "/*\n");
     $fwrite(f, "/* Clock cycle:\t%d\n",counter);
     $fwrite(f, "/*****************************/\n");
     $fwrite(f, "\n");
end

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

always @(posedge (iCPU.PCU.call & !clk)) begin

	$fwrite(f, "/*********************************************/\n");
     	$fwrite(f, "/* Function call\n");
     	$fwrite(f, "/* New PC Target:\t\t%h\n",iCPU.PCU.PC_update);
	$fwrite(f, "/*\n");
     	$fwrite(f, "/* Clock cycle:\t\t%d\n",counter);
     	$fwrite(f, "/*********************************************/\n");
     	$fwrite(f, "\n");

end

always @(posedge (iCPU.PCU.ret_in & !clk)) begin

	$fwrite(f, "/*********************************************/\n");
     	$fwrite(f, "/* Function return\n");
     	$fwrite(f, "/* New PC Target:\t\t%h\n",iCPU.PCU.PC_update);
	$fwrite(f, "/*\n");
     	$fwrite(f, "/* Clock cycle:\t\t%d\n",counter);
     	$fwrite(f, "/*********************************************/\n");
     	$fwrite(f, "\n");

end

initial begin

  @(posedge hlt)

     $fwrite(f, "/*****************************/\n");
     $fwrite(f, "/* Test Bench Complete\n");
     $fwrite(f, "/* Clock cycles:\t%d\n",counter);
     $fwrite(f, "/*\n");
     $fwrite(f, "/*\n");
     $fwrite(f, "/* Final Register Values:\n");
     $fwrite(f, "/*\n");
     for(index=1; index<16; index = index+1)
       $fwrite(f, "/*\tR%1h = %h\n",index,iCPU.IDU.reg_mem.mem[index]);

     $fwrite(f, "/*\n");
     $fwrite(f, "/*****************************/\n");
     #1;
     $fclose(f);
     $stop;
end 
  
always begin
  #1 clk = ~clk;
  	if (clk) counter++;
end

endmodule