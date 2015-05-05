`include "WISC-S15_top_level.v"
`include "icache_def.v"
//import icache_def::*;

module WISC_S15_top_level_tb();

reg clk,rst;

wire [15:0] pc;

wire hlt;

//////////////////////
// Instantiate CPU //
////////////////////
WISC_S15_top_level iCPU(.clk(clk), .rst(rst), .HALT(hlt));

initial begin
  clk = 0;
  $display("rst assert\n");
  rst = 1;
  @(posedge clk);
  @(negedge clk);
  rst = 0;
  $display("rst deassert\n");
end 
  
always
  #1 clk = ~clk;
  
initial begin
@(posedge hlt);
#1;
$stop;
end  

endmodule