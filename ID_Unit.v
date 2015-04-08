// Author: Graham Nygard, Robert Wagner

/* For a better understanding of these in/out parameters,
   reference the sketch of the ID unit. Inputs and outputs
   are labeled in descending order down the IF/ID register
   and the ID/EX register respectively */
module ID_Unit(clk, rst, 
	 mem_to_reg, reg_rs, reg_rt_arith, reg_rd_wb, reg_rd_data, cntrl_opcode, branch_cond_in, arith_imm_in, 
		load_save_reg_in, load_save_imm_in, call_in, PC_in, ID_EX_reg_rd, EX_MEM_reg_rd, MEM_WB_reg_rd, 
	mem_to_reg, reg_to_mem, alu_src, alu_op, branch, call, ret, read_data_1, read_data_2, branch_cond_out, 
		load_save_reg_out, arith_imm_out, load_save_imm_out, call_out, PC_out, sign_ext_out, hazard);

/////////////////////////////INPUTS//////////////////////////////////

input        clk;              // The global clock input
input        rst;              // The reset signal from PC

//REGFILE INPUT PARAMS
input        mem_to_reg;       // Regfile RegWrite when not reset
input [3:0]  reg_rs;           // Inst[7:4]   - Regfile source 1
input [3:0]  reg_rt_arith;     // Inst[3:0]   - Regfile source 2
input [3:0]  reg_rd_wb;        // Regfile write back register
input [15:0] reg_rd_data;      // Regfile write back data

//CONTROL PARAMS
input [3:0]  cntrl_opcode;      // Inst[15:12] - Instruction opcode
input [3:0]  branch_cond_in;    // Inst[11:8]  - Branch condition

//PIPELINE TO PIPELINE
input [3:0]  arith_imm_in;     // Inst[3:0]   - Imm of Arithmetic Inst
input [3:0]  load_save_reg_in; // Inst[11:8]  - Register for Load/Save
input [7:0]  load_save_imm_in; // Inst[7:0]   - Imm of Load/Save Inst
input [11:0] call_in;          // Inst[11:0]  - Call target
input [15:0] PC_in;            // Program counter

//HAZARD DETECTION REGISTERS
input [3:0] ID_EX_reg_rd;  // Corresponds to IDEX_reg's reg_rd_out
input [3:0] EX_MEM_reg_rd; // Corresponds to EXMEM_reg's reg_rd_out
input [3:0] MEM_WB_reg_rd; // Corresponds to MEMWB_reg's reg_rd_out

////////////////////////////END INPUTS///////////////////////////////

/////////////////////////////OUTPUTS/////////////////////////////////

//CONTROL SIGNALS 
output logic       mem_to_reg;        // LW signal to Memory unit  
output logic       reg_to_mem;        // SW signal to Memory unit
output logic       alu_src;           // ALU operand selection
output logic [2:0] alu_op;            // ALU control unit input

output logic      branch;            // PC Updater signal for branch   
output logic      call;              // PC Updater signal for call 
output logic      ret;               // PC Updater signal for ret 

//REGFILE OUTPUT PARAMS
output [15:0] read_data_1;       // Regfile Read_Bus_1
output [15:0] read_data_2;       // Regfile Read_Bus_2

//PIPE TO PIPE
output [2:0]  branch_cond_out;   // Branch condition
output [3:0]  load_save_reg_out; // Future Regfile dest
output [3:0]  arith_imm_out;     // Imm of Arithmetic Inst
output [7:0]  load_save_imm_out; // Imm of Load/Save Inst
output [11:0] call_out;          // Call target
output [15:0] PC_out;            // Program counter

//SIGN-EXT UNIT OUTPUT
output [15:0] sign_ext_out;      // Output of sign extension unit

//HAZARD SIGNALING FOR PIPE STALL
output hazard;

/////////////////////////END OUTPUTS/////////////////////////////////


////////////////////INTERNAL CONTROL OUTPUTS/////////////////////////

logic RegWrite;                  /* Signal for writing register */

logic WriteReg;                  /* Dest register of write data */
   
logic WriteData;                 /* Data to write to dest register */

logic DataReg;                   /* Control signal to Regfile to
                                    specifiy the contents of the 
                                    Data Segment Register for
                                    supplying read_data_1 */

logic StackReg;                  /* Control signal to RegFile to
                                    specify the contents of the
                                    Stack_Pointer Register for
                                    supplying read_data_1 */
                                    
logic reg_rt_src;                /* Control signal for selecting
                                    the source of the rt register. 
                                    This will be used to properly
                                    execute the Save Word instruction */
                                    
logic sign_ext_sel;              /* Control signal for selecting
                                    the which of the two immediate
                                    values (Arith, L/S) to sign
                                    extend */
                                    
logic [3:0] reg_rt;              // Regfile source 2

//CONTROL OUTPUTS FOR FUTURE PIPELINE
logic        c_mem_to_reg;          
logic        c_reg_to_mem;        
logic        c_alu_src;           
logic [2:0]  c_alu_op;            

logic        c_branch;               
logic        c_call;               
logic        c_ret;  

//ASSIGN PIPE TO PIPE WIRES              
assign branch_cond_out   = branch_cond_in;
assign load_save_reg_out = load_save_reg_in;
assign arith_imm_out     = arith_imm_in;
assign load_save_imm_out = load_save_imm_in;
assign call_out          = call_in;
assign PC_out            = PC_in;

//////////////////////////////////////////////////////////////////////
                                    
//MODULE INSTANTIATIONS
Reg_16bit_file reg_mem(.clk(clk), .RegWrite(RegWrite), .DataReg(DataReg),
                       .Call(Call), .Read_Reg_1(reg_rs), .Read_Reg_2(reg_rt),
                       .WriteReg(WriteReg), .Read_Bus_1(read_data_1),
                       .Read_Bus_2(read_data_2), .Write_Bus(WriteData));

Control_Logic control(.opcode(cntrl_opcode),
		                .data_reg(DataReg), .stack_reg(StackReg), .call(c_call),
		                .rtrn(c_ret), .branch(c_branch), .mem_to_reg(c_mem_to_reg),
		                .reg_to_mem(c_reg_to_mem), .alu_op(c_alu_op), .alu_src(c_alu_src),
		                .sign_ext_sel(sign_ext_sel));
                      
Sign_Ext_Unit sign_ext(.arith_imm(arith_imm_in), 
                       .load_save_imm(load_save_imm_in),
                       .sign_ext_sel(sign_ext_sel),
                       .sign_ext_out(sign_ext_out));

HDT_Unit hazard_unit(.IF_ID_reg_rs(reg_rs), .IF_ID_reg_rt(reg_rt_arith),
                     .IF_ID_reg_rd(load_save_reg_in),
                     .ID_EX_reg_rd(ID_EX_reg_rd), 
                     .EX_MEM_reg_rd(EX_MEM_reg_rd),
                     .MEM_WB_reg_rd(MEM_WB_reg_rd),
                     .hazard(hazard));

// Register rt selection
always_comb begin
    
    if (reg_rt_src)
        reg_rt = load_save_reg_in;

    else
        reg_rt = reg_rt_arith;
        
end

// Hazard Detection MUX
always_comb begin
    
    if (hazard) begin
        mem_to_reg = 1'b0;    
        reg_to_mem = 1'b0; 
        alu_src    = 1'b0;  
        alu_op     = 3'b000; 
        branch     = 1'b0;    
        call       = 1'b0;   
        ret        = 1'b0; 
    end
    
    else begin
        mem_to_reg = c_mem_to_reg;    
        reg_to_mem = c_reg_to_mem; 
        alu_src    = c_alu_src;  
        alu_op     = c_alu_op; 
        branch     = c_branch;    
        call       = c_call;   
        ret        = c_ret;
    end
    
end

// Reset Control MUX
always_comb begin
    
    // Reset stack pointer
    if (rst) begin
        
        RegWrite  = 1;       // Write to SP
        WriteReg  = 4'b1111; // SP register
        WriteData = 16'hFFFF; // Reset SP
        
    end
    
    else begin
    
        RegWrite  = mem_to_reg;  // Write to SP
        WriteReg  = reg_rd_wb;   // SP register
        WriteData = reg_rd_data; // Reset SP
        
    end
    
end
                
endmodule
