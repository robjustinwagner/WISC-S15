// Author: Graham Nygard, Robert Wagner

/* This module defines the regeister interface
   for accessing the 16-bit registers used by
   our processor. */
module Reg_16bit_file(clk, RegWrite, DataReg, StackReg,
                       Read_Reg_1, Read_Reg_2, Write_Reg,
                       Write_Bus,
                      Read_Bus_1, Read_Bus_2);
                 
  input clk;
  input RegWrite; // Writes data to a register when high  
  input DataReg;  // Specifies Data_Segment for Read_Reg_1 
  input StackReg; // Specified Stack_Pointer for Read_Reg_1 
  
  /* Input address buses */
  input [3:0] Read_Reg_1;
  input [3:0] Read_Reg_2;
  input [3:0] Write_Reg;
  
  /* Input Write Data */
  input [15:0] Write_Bus;
 
  /* Output Read Data */	
  output reg [15:0] Read_Bus_1;
  output reg [15:0] Read_Bus_2;
    
  localparam   REG_0     =    4'b0000;
  localparam   REG_1     =    4'b0001;
  localparam   REG_2     =    4'b0010;
  localparam   REG_3     =    4'b0011;
  localparam   REG_4     =    4'b0100;
  localparam   REG_5     =    4'b0101;
  localparam   REG_6     =    4'b0110;
  localparam   REG_7     =    4'b0111;
  localparam   REG_8     =    4'b1000;
  localparam   REG_9     =    4'b1001;
  localparam   REG_10    =    4'b1010;
  localparam   REG_11    =    4'b1011;
  localparam   REG_12    =    4'b1100;
  localparam   REG_13    =    4'b1101;
  localparam   REG_14    =    4'b1110;
  localparam   REG_15    =    4'b1111;
  
  /* Outputs from each specific register */
  wire [15:0] out1,out2,out3,out4,
              out5,out6,out7,out8,
              out9,out10,out11,out12,
              out13,out14,out15,out16;
             
  /* Register Write Selection */
  reg [15:0] RegWriteSel;
    
  // General Purpose Registers   
  Reg_16bit reg0(.clk(clk), .en(RegWriteSel[0]), .d(Write_Bus), .q(out1));
  Reg_16bit reg1(.clk(clk), .en(RegWriteSel[1]), .d(Write_Bus), .q(out2));
  Reg_16bit reg2(.clk(clk), .en(RegWriteSel[2]), .d(Write_Bus), .q(out3));
  Reg_16bit reg3(.clk(clk), .en(RegWriteSel[3]), .d(Write_Bus), .q(out4));
  Reg_16bit reg4(.clk(clk), .en(RegWriteSel[4]), .d(Write_Bus), .q(out5));
  Reg_16bit reg5(.clk(clk), .en(RegWriteSel[5]), .d(Write_Bus), .q(out6));
  Reg_16bit reg6(.clk(clk), .en(RegWriteSel[6]), .d(Write_Bus), .q(out7));
  Reg_16bit reg7(.clk(clk), .en(RegWriteSel[7]), .d(Write_Bus), .q(out8));
  Reg_16bit reg8(.clk(clk), .en(RegWriteSel[8]), .d(Write_Bus), .q(out9));
  Reg_16bit reg9(.clk(clk), .en(RegWriteSel[9]), .d(Write_Bus), .q(out10));
  Reg_16bit reg10(.clk(clk), .en(RegWriteSel[10]), .d(Write_Bus), .q(out11));
  Reg_16bit reg11(.clk(clk), .en(RegWriteSel[11]), .d(Write_Bus), .q(out12));
  Reg_16bit reg12(.clk(clk), .en(RegWriteSel[12]), .d(Write_Bus), .q(out13));
  Reg_16bit reg13(.clk(clk), .en(RegWriteSel[13]), .d(Write_Bus), .q(out14));
  
  // Special Registers
  Reg_16bit Data_Segment(.clk(clk), .en(RegWriteSel[14]), .d(Write_Bus), .q(out15));
  Reg_16bit Stack_Pointer(.clk(clk), .en(RegWriteSel[15]), .d(Write_Bus), .q(out16));
  
  /* Read data from the specified registers locations */
  always @(negedge clk) begin
    
       // The instruction requires the use of the Stack_Pointer reg
       if (StackReg) begin
           Read_Bus_1 = out16;
           Read_Bus_2 = 16'h0000;
       end
       
       else begin
           
          // The instruction requires the use of the Data_Segment reg
          if (DataReg) begin
              Read_Bus_1 = out15;
          end
       
          // The instruction does not require the use of special registers       
          else begin
          
             case(Read_Reg_1)
           
                 REG_0 : Read_Bus_1 = out1;
                 REG_1 : Read_Bus_1 = out2;
                 REG_2 : Read_Bus_1 = out3;
                 REG_3 : Read_Bus_1 = out4;
                 REG_4 : Read_Bus_1 = out5;
                 REG_5 : Read_Bus_1 = out6;
                 REG_6 : Read_Bus_1 = out7;
                 REG_7 : Read_Bus_1 = out8;
                 REG_8 : Read_Bus_1 = out9;
                 REG_9 : Read_Bus_1 = out10;
                 REG_10 : Read_Bus_1 = out11;
                 REG_11 : Read_Bus_1 = out12;
                 REG_12 : Read_Bus_1 = out13;
                 REG_13 : Read_Bus_1 = out14;
                 REG_14 : Read_Bus_1 = out15;
                 REG_15 : Read_Bus_1 = out16;
            
             endcase
          
          end
       
          case(Read_Reg_2)
           
              REG_0 : Read_Bus_2 = out1;
              REG_1 : Read_Bus_2 = out2;
              REG_2 : Read_Bus_2 = out3;
              REG_3 : Read_Bus_2 = out4;
              REG_4 : Read_Bus_2 = out5;
              REG_5 : Read_Bus_2 = out6;
              REG_6 : Read_Bus_2 = out7;
              REG_7 : Read_Bus_2 = out8;
              REG_8 : Read_Bus_2 = out9;
              REG_9 : Read_Bus_2 = out10;
              REG_10 : Read_Bus_2 = out11;
              REG_11 : Read_Bus_2 = out12;
              REG_12 : Read_Bus_2 = out13;
              REG_13 : Read_Bus_2 = out14;
              REG_14 : Read_Bus_2 = out15;
              REG_15 : Read_Bus_2 = out16;
            
          endcase
          
      end
      
  end
  
  /* Write data to the specified location */
  always @(posedge clk) begin
      
      if (RegWrite) begin
      
         case(Write_Reg)
           
           REG_0 : RegWriteSel = 16'h0001;
           REG_1 : RegWriteSel = 16'h0002;
           REG_2 : RegWriteSel = 16'h0004;
           REG_3 : RegWriteSel = 16'h0008;
           REG_4 : RegWriteSel = 16'h0010;
           REG_5 : RegWriteSel = 16'h0020;
           REG_6 : RegWriteSel = 16'h0040;
           REG_7 : RegWriteSel = 16'h0080;
           REG_8 : RegWriteSel = 16'h0100;
           REG_9 : RegWriteSel = 16'h0200;
           REG_10 : RegWriteSel = 16'h0400;
           REG_11 : RegWriteSel = 16'h0800;
           REG_12 : RegWriteSel = 16'h1000;
           REG_13 : RegWriteSel = 16'h2000;
           REG_14 : RegWriteSel = 16'h4000;
           REG_15 : RegWriteSel = 16'h8000;
            
          endcase
       
      end
      
      /* Ensure that no register is written
         when RegWrite is not active */
      else begin
          
          RegWriteSel = 16'h0000;
          
      end
      
  end

endmodule