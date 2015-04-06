// Author: Graham Nygard, Robert Wagner

module Reg_16bit(clk, en, d, q);
    
    input clk, en;
    input [15:0] d;
    
    output reg [15:0] q;
    
    always @(posedge clk) begin  
        if (en)
           q <= d;    
        else
           q <= q;
    end
    
endmodule