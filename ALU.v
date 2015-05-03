// Author: Graham Nygard, Robert Wagner

module ALU(data_one, data_two, shift, control, done, result, flags);

//combinational logic --change asynck

   //INPUTS
   input signed [15:0] data_one, data_two;   //data in
   input unsigned [3:0] shift;	//SRA, SRL, SLL shift amount
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
    done = 1'b0;
    flags = flags;
    cout = 1'b0;
    //result = 16'bzzzz;

    case(control)
              
           ADD : begin
		          {cout, result} = data_one + data_two;
		           //ZERO
                 if(!(|result))
                    flags |= 3'b100;   //set zero (Z)
                 else //result != 0
                    flags &= 3'b011;   //clear zero (Z)
		           //OVERFLOW
		           case({data_one[15], data_two[15]})
			            2'b00:	begin
					         if(result[15] == 1'b1) begin
						          flags |= 3'b010;   //set overflow (V)
					         end
					         else begin
						          flags &= 3'b101;   //clear overflow (V)
					         end
				         end
			            2'b01: 	begin
					         flags &= 3'b101;   //clear overflow (V)
				         end
			            2'b10:	begin
					         flags &= 3'b101;   //clear overflow (V)
				         end
			            2'b11:	begin
					         if(result[15] == 1'b0) begin
						         flags |= 3'b010;   //set overflow (V)
					         end
					         else begin
						         flags &= 3'b101;   //clear overflow (V)
					         end
				         end
		           endcase
		           //SIGN
                 if(result[15] == 1) begin
                    flags |= 3'b001;   //set sign (N) to neg (1)
                 end
                 else begin
                    flags &= 3'b110;   //set sign (N) to pos (0)
                 end
                 
                 done = 1'b1; //all ALU operations are done
		     end
           
           SUB : begin
		           {cout, result} = data_one - data_two;
		           //ZERO
                 if(!(|result)) begin
                    flags |= 3'b100;   //set zero (Z)
                 end
                 else begin //result != 0
                    flags &= 3'b011;   //clear zero (Z)
                 end
		           //OVERFLOW
                 case({data_one[15], data_two[15]})
			            2'b00:	begin
					         flags &= 3'b101;   //clear overflow (V)
				         end
			            2'b01: 	begin
					            if(result[15] == 1'b1) begin
						            flags |= 3'b010;   //set overflow (V)
					            end
					            else begin
						            flags &= 3'b101;   //clear overflow (V)
					            end
				         end
			            2'b10:	begin
					            if(result[15] == 1'b0) begin
						            flags |= 3'b010;   //set overflow (V)
					            end
					            else begin
						            flags &= 3'b101;   //clear overflow (V)
					            end
				         end
			            2'b11:	begin
					            flags &= 3'b101;   //clear overflow (V)
				         end
		           endcase
		          //SIGN
                 if(result[15] == 1) begin
                    flags |= 3'b001;   //set sign (N) to neg (1)
                 end 
                 else begin
                    flags &= 3'b110;   //set sign (N) to pos (0)
                 end
                 
                 done = 1'b1; //all ALU operations are done
		     end
           
           NAND : begin
		           result = ~(data_one & data_two);
		           //FLAGS
                 if(!(|result)) begin
                     flags |= 3'b100;   //set zero (Z)
                 end
                 else begin//result != 0
                     flags &= 3'b011;   //clear zero (Z)
                     flags &= 3'b101;   //clear overflow (V)
                     flags &= 3'b110;   //set sign (N) to pos (0)
                 end
		     end
           
           XOR : begin
		           result = data_one ^ data_two;
		           //FLAGS
                 if(!(|result)) begin
                     flags |= 3'b100;   //set zero (Z)
                 end
                 else begin//result != 0
                     flags &= 3'b011;   //clear zero (Z)
                     flags &= 3'b101;   //clear overflow (V)
                     flags &= 3'b110;   //set sign (N) to pos (0)
                 end
		     end
                             
           INC : begin
		           {cout, result} = data_one + data_two;
		 
		           //ZERO
                 if(!(|result))
                    flags |= 3'b100;   //set zero (Z)
                 else //result != 0
                    flags &= 3'b011;   //clear zero (Z)
		           //OVERFLOW
		           case({data_one[15], data_two[15]})
			         
			           2'b00:	begin
					            if(result[15] == 1'b1) begin
						            flags |= 3'b010;   //set overflow (V)
					            end
					            else begin
						            flags &= 3'b101;   //clear overflow (V)
					            end
				        end
			           2'b01: 	begin
					            flags &= 3'b101;   //clear overflow (V)
				        end
			           2'b10:	begin
					            flags &= 3'b101;   //clear overflow (V)
				        end
			           2'b11:	begin
					            if(result[15] == 1'b0) begin
						            flags |= 3'b010;   //set overflow (V)
					            end
					            else begin
						            flags &= 3'b101;   //clear overflow (V)
					            end
				        end
				        
		           endcase
		           //SIGN
                 if(result[15] == 1)
                    flags |= 3'b001;   //set sign (N) to neg (1)
                 else
                    flags &= 3'b110;   //set sign (N) to pos (0)
                    
                 done = 1'b1; //all ALU operations are done
		    end
           
          SRA : begin
             result = data_one >>> shift;		//TODO: MANUALLY IMPLEMENT THIS FOR BETTER AREA
             done = 1'bx; //all ALU operations are done
          //leave flags unchanged
          end
           
          SRL : begin
             result = data_one >> shift;		//TODO: MANUALLY IMPLEMENT THIS FOR BETTER AREA
             done = 1'bx; //all ALU operations are done
          //leave flags unchanged
          end
           
          SLL : begin
            result = data_one << shift;			//TODO: MANUALLY IMPLEMENT THIS FOR BETTER AREA
            done = 1'bx; //all ALU operations are done
          //leave flags unchanged
          end
           
	       default: result = result;
            
      endcase

  end

endmodule