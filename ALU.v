// Author: Graham Nygard, Robert Wagner

module ALU(data_one, data_two, control, zero, result, flags)

//combinational logic --change asynch

   //INPUTS
   input [15:0] data_one, data_two;   //data in
   input [3:0] control;   //opcode contro
   
   //OUTPUTS
   output reg zero;   //branching
   output reg [15:0] result;
   output reg [2:0] flags;   //[Z, V, N]
   
   logic cout;
   
   localparam   ADD   =   4'b0000;
   localparam   SUB   =   4'b0001;
   localparam   NAND  =   4'b0010;
   localparam   XOR   =   4'b0011;
   localparam   INC   =   4'b0100;
   localparam   SRA   =   4'b0101;
   localparam   SRL   =   4'b0110;
   localparam   SLL   =   4'b0111;
   localparam   LW    =   4'b1000;
   localparam   SW    =   4'b1001;
   localparam   LHB   =   4'b1010;
   localparam   LLB   =   4'b1011;
   localparam   B     =   4'b1100;
   localparam   CALL  =   4'b1101;
   localparam   RET   =   4'b1110;
   localparam   ERR   =   4'b1111;
   
   
   always_comb begin
    
    //Initalize all variables HERE
    cout = 0;
    result = 0;
    
    case(control)
           
             /*
              zero: indicates whether all bits of the result bus are logic zero
              Arithmetic shift: the operand is treated as a two's complement integer, meaning that the most significant bit is a "sign" bit and is preserved.
              Logical shift: a logic zero is shifted into the operand. This is used to shift unsigned integers.
              Rotate: typically, carry-in is shifted into the operand.
              */
              
           ADD : {cout, result} = data_one + data_two;
                 if(!(|result))
                    flags | 3'b100;   //set zero (Z)
                 else //result != 0
                    flags & 3'b011;   //clear zero (Z)
                 if(cout == 0)
                    flags & 3'b101;   //clear overflow (V)
                 else //cout == 1
                    flags | 3'b010;   //set overflow (V)
                 if(result[15] == 1)
                    flags | 3'b001;   //set sign (N) to neg (1)
                 else
                    flags & 3'b110;   //set sign (N) to pos (0)
           
           SUB : {cout, result} = data_one - data_two;
                 if(!(|result))
                    flags | 3'b100;   //set zero (Z)
                 else //result != 0
                    flags & 3'b011;   //clear zero (Z)
                 if(cout == 0)
                    flags & 3'b101;   //clear overflow (V)
                 else //cout == 1
                    flags | 3'b010;   //set overflow (V)
                 if(result[15] == 1)
                    flags | 3'b001;   //set sign (N) to neg (1)
                 else
                    flags & 3'b110;   //set sign (N) to pos (0)
           
           NAND : result = data_one &~ data_two;
                  if(!(|result))
                     flags | 3'b100;   //set zero (Z)
                  else //result != 0
                     flags & 3'b011;   //clear zero (Z)
                  flags & 3'b101;   //clear overflow (V)
                  flags & 3'b110;   //set sign (N) to pos (0)
           
           XOR : result = data_one ^ data_two;
                 if(!(|result))
                     flags | 3'b100;   //set zero (Z)
                 else //result != 0
                     flags & 3'b011;   //clear zero (Z)
                 flags & 3'b101;   //clear overflow (V)
                 flags & 3'b110;   //set sign (N) to pos (0)
                             
           INC : {cout, result} = data_one + data_two;            //FIX THIS
                 if(!(|result))
                    flags | 3'b100;   //set zero (Z)
                 else //result != 0
                    flags & 3'b011;   //clear zero (Z)
                 if(cout == 0)
                    flags & 3'b101;   //clear overflow (V)
                 else //cout == 1
                    flags | 3'b010;   //set overflow (V)
                 if(result[15] == 1)
                    flags | 3'b001;   //set sign (N) to neg (1)
                 else
                    flags & 3'b110;   //set sign (N) to pos (0)
           
           SRA : result = data_one >>> data_two;
           //leave flags unchanged
           
           SRL : result = data_one >> data_two;
           //leave flags unchanged
           
           SLL : result = data_one << data_two;
           //leave flags unchanged
           
           LW : result = ;                           //FIX THIS
           
           SW : result = ;                           //FIX THIS
           
           
           LHB : result = out11;
           
           LLB : result = out12; 
           
           B : result = out13;
           
           CALL : result = out14;
           
           RET : result = out15; 
           
           ERR : result = result;   //error case, don't change result
            
       endcase
      
  end
   

endmodule