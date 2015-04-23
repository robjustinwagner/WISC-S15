// Author: Graham Nygard, Robert Wagner

module PC_Update(PC_in, PC_stack_pointer, alu_done, flags, call_target,
                 sign_ext, branch_cond, branch, call, ret, 
                    PC_update, PC_src, update_done);

// FROM ID/EX REG
input               branch;
input        [2:0]  branch_cond;

input               call;
input        [11:0] call_target;

input        [15:0] PC_in;
input signed [15:0] sign_ext;

// FROM ALU
input               alu_done;
input        [2:0]  flags;          // [Z, V, N]

// FROM MEM/WB REG
input               ret;              
input        [15:0] PC_stack_pointer;

//OUTPUTS
output logic [15:0] PC_update;
output logic        PC_src;
output logic        update_done;

logic math;

localparam   EQ   =   3'b000;
localparam   LT   =   3'b001;
localparam   GT   =   3'b010;
localparam   O    =   3'b011;
localparam   NE   =   3'b100;
localparam   GEQ  =   3'b101;
localparam   LEQ  =   3'b110;
localparam   T    =   3'b111;

//always @(posedge alu_done, posedge ret, posedge call) begin
always_comb begin
  
   //if (alu_done) begin
    
    if (branch) begin
        
        PC_update = PC_in + sign_ext;
        
        case(branch_cond)
            
            EQ : begin
                
                if (flags[2])
                   PC_src = 1;
                else
                   PC_src = 0;
            end
            
            LT : begin
                
                math = flags[0] & !flags[1];
                
                if (math)
                   PC_src = 1;
                else
                   PC_src = 0;
            end
            
            GT : begin
             
                math = !flags[0] & !flags[1] & !flags[2];
                
                if (math)
                   PC_src = 1;
                else
                   PC_src = 0;
            end
            
            O : begin
      
                if (flags[1])
                   PC_src = 1;
                else
                   PC_src = 0;
            end
            
            NE : begin
                
                if (!flags[2])
                   PC_src = 1;
                else
                   PC_src = 0;
            end
            
            GEQ : begin
                
                math = flags[1] | !flags[0];
                
                if (math)
                   PC_src = 1;
                else
                   PC_src = 0;
            end
            
            LEQ : begin
                
                math = flags[2] | (!flags[1] & flags[0]);
                
                if (math)
                   PC_src = 1;
                else
                   PC_src = 0;
            end
            
            default : begin //TRUE is defaulted
           
                PC_src = 1;
            end
            
        endcase // End of branch cases
        
    end // end branch
//end
    
    else if (call) begin
    
       // Needs to be incremented by 1 <-- project spec
       PC_update   = {PC_in[15:12], call_target};
       update_done = 1;   // Tell control unit to unhault pipe
       PC_src      = 1;
       
    end
    
   else if (ret) begin
        
       PC_update   = PC_stack_pointer;
       update_done = 1;   // Tell control unit to unhault pipe
       PC_src      = 1; 
       
    end
    
    else begin
        PC_update = 16'hxxxx;
        update_done = 0;
        PC_src = 0;
    end
    
end

endmodule
            
                
                
