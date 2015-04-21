module WISC_S15_top_level_tb();

`include "WISC-S15_top_level.v"

reg clk,rst;

wire [15:0] pc;

//////////////////////
// Instantiate CPU //
////////////////////
WISC_S15_top_level iCPU(.clk(clk), .rst(rst), .hlt(hlt));

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
//  @(posedge hlt) $stop();
#100;
$stop;
end  

endmodule