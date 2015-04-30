// Author: Graham Nygard, Robert Wagner

module Flag_reg(clk, en, d, q);
    
    input clk, en;
    
    /* Z (zero), V (overflow), N (sign) */
    input [2:0] d;
    
    output reg [2:0] q;
    
    always @(negedge clk) begin  
        if (en)
           q <= d;    
        else
           q <= q;
    end
    
endmodule
