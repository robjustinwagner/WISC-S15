// Author: Graham Nygard, Robert Wagner

module Sign_Ext_Unit(arith_imm, load_save_imm,
                     sign_ext_sel, sign_ext_out);
                     
//INPUTS
input       sign_ext_sel;     // Selection of Arith imm or L/S imm
input [3:0] arith_imm;     // Immediate of Arithmetic Inst
input [7:0] load_save_imm; // Immediate of Load/Save Inst

//OUTPUT
output logic [15:0] sign_ext_out;

always @(sign_ext_sel) begin
    
    // Default to use Immediate of Load/Save
    if (!sign_ext_sel) begin
        assign sign_ext_out = {{8{load_save_imm[7]}}, load_save_imm};
    end
    
    // Otherwise, sign extend Immediate of Arith
    else begin
        assign sign_ext_out = {{12{arith_imm[3]}}, arith_imm};
    end

end


endmodule
        

