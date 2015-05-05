// Author: Graham Nygard, Robert Wagner

`include "Reg_16bit_file.sv"

module REg_16bit_file_tb();
	
reg clk, RegWrite;

reg [3:0] AddrA, AddrB, AddrC;
reg [4:0] i;
reg [15:0] BusC;

wire [15:0] BusA, BusB;

Reg_16bit_file RegisterFile(.clk(clk), .RegWrite(RegWrite),
                            .AddrA(AddrA), .AddrB(AddrB), .AddrC(AddrC),
                            .BusA(BusA), .BusB(BusB), .BusC(BusC));
                            
initial begin

   clk = 0;
   RegWrite = 0;
   AddrA = 4'b0000;
   AddrB = 4'b0000;
   AddrC = 4'b0000;
   
   #20;
   
   /* Write register data  */
   i = 0;
   while (i <= 15) begin      
      
      RegWrite = 1;
      #10 AddrC = i;
      i = i + 1;
      if (i == 16) BusC = 0;
      else         BusC = i;
    
   end
   /* End register data writing */
   
   #20;
   
   RegWrite = 0;
   
   #20;
   
   /* Read register data */
   i = 0;
   while (i <= 15) begin
      
      #10 AddrA = i;
      i = i + 1;
      AddrB = i;
    
   end
   /* End register data reading */
   
   $stop;
   
end

always begin
    #5 clk = ~clk;
end

endmodule