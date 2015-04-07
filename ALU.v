// Author: Graham Nygard, Robert Wagner

module ALU(data_one, data_two, shift, load_half_imm, control, done, result, flags);

//combinational logic --change asynck

   //INPUTS
   input signed [15:0] data_one, data_two;   //data in
   input unsigned [3:0] shift;	//SRA, SRL, SLL shift amount
   input signed [7:0] load_half_imm; //LHB, LLB
   input [2:0] control;   //opcode control
   
   //OUTPUTS
   output reg done;   //ALU is done with operations
   output reg signed [15:0] result;
   output reg [2:0] flags;   //[Z, V, N]
   
   logic cout;
   
   //OPCODE CONTROL
   localparam   ADD   =   3'b000;
   localparam   SUB   =   3'b001;
   localparam   NAND  =   3'b010;
   localparam   XOR   =   3'b011;
   localparam   INC   =   3'b100;
   localparam   SRA   =   3'b101;
   localparam   SRL   =   3'b110;
   localparam   SLL   =   3'b111;   
 
   
   always_comb begin
    
    //Initalize all variables
    done = 0;
    flags = 3'b000;
    cout = 0;
    result = 0;

    case(control)
           
           /*
            zero: indicates whether all bits of the result bus are logic zero
            Arithmetic shift: the operand is treated as a two's complement integer, meaning that the most significant bit is a "sign" bit and is preserved.
            Logical shift: a logic zero is shifted into the operand. This is used to shift unsigned integers.
            Rotate: typically, carry-in is shifted into the operand.
           */
              
           ADD : begin
		 {cout, result} = data_one + data_two;
                 if(!(|result))
                    flags |= 3'b100;   //set zero (Z)
                 else //result != 0
                    flags &= 3'b011;   //clear zero (Z)
                 if(cout == 0)
                    flags &= 3'b101;   //clear overflow (V)
                 else //cout == 1
                    flags |= 3'b010;   //set overflow (V)
                 if(result[15] == 1)
                    flags |= 3'b001;   //set sign (N) to neg (1)
                 else
                    flags &= 3'b110;   //set sign (N) to pos (0)
		 end
           
           SUB : begin
		 {cout, result} = data_one - data_two;
                 if(!(|result))
                    flags |= 3'b100;   //set zero (Z)
                 else //result != 0
                    flags &= 3'b011;   //clear zero (Z)
                 if(cout == 0)
                    flags &= 3'b101;   //clear overflow (V)
                 else //cout == 1
                    flags |= 3'b010;   //set overflow (V)
                 if(result[15] == 1)
                    flags |= 3'b001;   //set sign (N) to neg (1)
                 else
                    flags &= 3'b110;   //set sign (N) to pos (0)
		 end
           
           NAND : begin
		 result = data_one &~ data_two;
                 if(!(|result))
                     flags |= 3'b100;   //set zero (Z)
                 else //result != 0
                     flags &= 3'b011;   //clear zero (Z)
                 flags &= 3'b101;   //clear overflow (V)
                 flags &= 3'b110;   //set sign (N) to pos (0)
		 end
           
           XOR : begin
		 result = data_one ^ data_two;
                 if(!(|result))
                     flags |= 3'b100;   //set zero (Z)
                 else //result != 0
                     flags &= 3'b011;   //clear zero (Z)
                 flags &= 3'b101;   //clear overflow (V)
                 flags &= 3'b110;   //set sign (N) to pos (0)
		 end
                             
           INC : begin
		 {cout, result} = data_one + data_two;            //FIX THIS
                 if(!(|result))
                    flags |= 3'b100;   //set zero (Z)
                 else //result != 0
                    flags &= 3'b011;   //clear zero (Z)
                 if(cout == 0)
                    flags &= 3'b101;   //clear overflow (V)
                 else //cout == 1
                    flags |= 3'b010;   //set overflow (V)
                 if(result[15] == 1)
                    flags |= 3'b001;   //set sign (N) to neg (1)
                 else
                    flags &= 3'b110;   //set sign (N) to pos (0)
		 end
           
           SRA : result = data_one >>> shift;
           //leave flags unchanged
           
           SRL : result = data_one >> shift;
           //leave flags unchanged
           
           SLL : result = data_one << shift;
           //leave flags unchanged
           
	   default: result = result;
            
       endcase
      
    done = 1; //all ALU operations are done

  end
   

endmodule