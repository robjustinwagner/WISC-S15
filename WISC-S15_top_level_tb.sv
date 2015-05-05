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
  f = $fopen("LwStall_Results.txt","w");
end

always @(posedge (iCPU.IDU.reg_mem.we & !clk)) begin

     $fwrite(f, "/*****************************/\n");
     $fwrite(f, "/* Register:\t%d\n",iCPU.IDU.reg_mem.dst_addr);
     $fwrite(f, "/* Value:\t%h\n",iCPU.IDU.reg_mem.dst);
     $fwrite(f, "/* Clock cycle:\t%d\n",counter);
     $fwrite(f, "/*****************************/\n");
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