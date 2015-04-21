// Author: Graham Nygard, Robert Wagner

`include "Reg_16bit_file.v"
`include "Control_Logic.v"
`include "HDT_Unit.v"

/* For a better understanding of these in/out parameters,
   reference the sketch of the ID unit. Inputs and outputs
   are labeled in descending order down the IF/ID register
   and the ID/EX register respectively */
module ID_Unit(clk, rst, PC_update, PC_hazard_in,
	RegWrite_in, reg_rs, reg_rt_arith, reg_rd_wb, reg_rd_data, cntrl_opcode, branch_cond_in, arith_imm_in, 
		load_save_reg_in, load_save_imm_in, call_target_in, PC_in, ID_EX_reg_rd, EX_MEM_reg_rd, MEM_WB_reg_rd,
	RegWrite_out, MemWrite_out, MemRead_out, mem_to_reg, alu_src, alu_op, branch, call, ret, load_half, half_spec, read_data_1, 
		read_data_2, branch_cond_out, load_save_reg_out, arith_imm_out, load_save_imm_out, call_target_out, PC_out, 
		sign_ext_out, data_hazard, PC_hazard_out);

/////////////////////////////INPUTS//////////////////////////////////

input        clk;              // The global clock input
input        rst;              // The reset signal from PC
input        PC_update;        // Signal for unhaulting pipe
input        PC_hazard_in;

//REGFILE INPUT PARAMS
input        RegWrite_in;      // Regfile RegWrite when not reset
input [3:0]  reg_rs;           // Inst[7:4]   - Regfile source 1
input [3:0]  reg_rt_arith;     // Inst[3:0]   - Regfile source 2
input [3:0]  reg_rd_wb;        // Regfile write back register
input [15:0] reg_rd_data;      // Regfile write back data

//CONTROL PARAMS
input [3:0]  cntrl_opcode;      // Inst[15:12] - Instruction opcode

//PIPELINE TO PIPELINE
input [2:0]  branch_cond_in;   // Inst[10:8]  - Branch condition
input [3:0]  arith_imm_in;     // Inst[3:0]   - Imm of Arithmetic Inst
input [3:0]  load_save_reg_in; // Inst[11:8]  - Register for Load/Save
input [7:0]  load_save_imm_in; // Inst[7:0]   - Imm of Load/Save Inst
input [11:0] call_target_in;   // Inst[11:0]  - Call target
input [15:0] PC_in;            // Program counter

//HAZARD DETECTION REGISTERS
input [3:0] ID_EX_reg_rd;      // Corresponds to IDEX_reg's reg_rd_out
input [3:0] EX_MEM_reg_rd;     // Corresponds to EXMEM_reg's reg_rd_out
input [3:0] MEM_WB_reg_rd;     // Corresponds to MEMWB_reg's reg_rd_out

////////////////////////////END INPUTS///////////////////////////////

/////////////////////////////OUTPUTS/////////////////////////////////

//CONTROL SIGNALS 
output logic       RegWrite_out;   // Initial output from control
output logic       MemWrite_out;   // SW signal to Memory unit
output logic       MemRead_out;    // LW signal to Memory unit
output logic       mem_to_reg;     // Writeback data specifier
output logic       alu_src;        // ALU operand selection
output logic [2:0] alu_op;         // ALU control unit input

output logic	branch;             // PC Updater signal for branch   
output logic	call;               // PC Updater signal for call 
output logic	ret;                // PC Updater signal for ret 

output	logic	load_half;	    // Specifies the ALU result
output	logic	half_spec;	    // (0 -> LHB, 1 -> LLB)

//REGFILE OUTPUT PARAMS
output logic [15:0] read_data_1;       // Regfile Read_Bus_1
output logic [15:0] read_data_2;       // Regfile Read_Bus_2

//PIPE TO PIPE
output logic [3:0]  arith_imm_out;     // Imm of Arithmetic Inst
output logic [7:0]  load_save_imm_out; // Imm of Load/Save Inst

output logic [2:0]        branch_cond_out;   // Branch condition
output logic [3:0]        load_save_reg_out; // Future Regfile dest
output logic [11:0]       call_target_out;   // Call target
output logic [15:0]       PC_out;            // Program counter

//SIGN-EXT UNIT OUTPUT
output logic [15:0] sign_ext_out;      // Output of sign extension unit

//HAZARD SIGNALING FOR PIPE STALL
output logic data_hazard;
output logic PC_hazard_out;

/////////////////////////END OUTPUTS/////////////////////////////////


////////////////////INTERNAL CONTROL OUTPUTS/////////////////////////

logic RegWrite;                  /* Signal for writing register */

logic [3:0]  WriteReg;                  /* Dest register of write data */
   
logic [15:0] WriteData;          /* Data to write to dest register */

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

//INTERNAL OUTPUTS

logic        [15:0] mem_read_data_1;
logic        [15:0] mem_read_data_2;

logic        c_mem_to_reg;          
logic        c_RegWrite;
logic        c_MemWrite;
logic        c_MemRead;        
logic        c_alu_src;           
logic [2:0]  c_alu_op; 

logic        c_load_half;

logic        c_branch;               
logic        c_call;               
logic        c_ret;  

assign PC_out = PC_in;

//////////////////////////////////////////////////////////////////////
                                    
//MODULE INSTANTIATIONS
Reg_16bit_file reg_mem(.clk(clk), .RegWrite(RegWrite), .DataReg(DataReg),
                       .StackReg(StackReg), .Read_Reg_1(reg_rs), .Read_Reg_2(reg_rt),
                       .Write_Reg(WriteReg), .Read_Bus_1(mem_read_data_1),
                       .Read_Bus_2(mem_read_data_2), .Write_Bus(WriteData));

Control_Logic control(.opcode(cntrl_opcode),
		               .data_reg(DataReg), .stack_reg(StackReg), .call(c_call), .rtrn(c_ret), .branch(c_branch), 
				         .mem_to_reg(c_mem_to_reg), .alu_op(c_alu_op), .alu_src(c_alu_src),
				         .sign_ext_sel(sign_ext_sel), .reg_rt_src(reg_rt_src), .RegWrite(c_RegWrite),
				         .MemWrite(c_MemWrite), .MemRead(c_MemRead), .load_half(c_load_half),
				         .half_spec(half_spec));

HDT_Unit hazard_unit(.IF_ID_reg_rs(reg_rs), .IF_ID_reg_rt(reg_rt_arith), .DataReg(DataReg),
                        .IF_ID_reg_rd(load_save_reg_in), .ID_EX_reg_rd(ID_EX_reg_rd), 
                        .EX_MEM_reg_rd(EX_MEM_reg_rd), .MEM_WB_reg_rd(MEM_WB_reg_rd),
                        .ret(c_ret), .call(c_call), .PC_update(PC_update),
                     .data_hazard(data_hazard), .PC_hazard(PC_hazard_out), .rst(rst), .clk(clk));

// Register rt selection
always_comb begin
    
    if (reg_rt_src)
        reg_rt = load_save_reg_in;

    else
        reg_rt = reg_rt_arith;
        
end

// Sign_Ext_Unit
always_comb begin
    
    // Default to use Immediate of Load/Save
    if (sign_ext_sel) begin
        sign_ext_out = {{8{load_save_imm_in[7]}}, load_save_imm_in};
    end
    
    // Otherwise, sign extend Immediate of Arith
    else begin
        sign_ext_out = {{12{arith_imm_in[3]}}, arith_imm_in};
    end

end

// Hazard Detection MUX
always_comb begin
    
    if (data_hazard | PC_hazard_in) begin //BAD STYLE, CHANGE FOR FINAL
        
        load_save_reg_out = 4'bzzzz;
            
        RegWrite_out   = 1'b0; 
        MemWrite_out   = 1'b0;
        MemRead_out    = 1'b0;
        mem_to_reg     = 1'b0;
        
        alu_src        = 1'b0;  
        alu_op         = 3'b111;
         
        branch         = 1'b0;    
        call           = 1'b0;   
        ret            = 1'b0; 
        
        load_half      = 1'b0;

        read_data_1    = 16'hzzzz;
        read_data_2    = 16'hzzzz;

        arith_imm_out  = 4'hz;
        load_save_imm_out = 8'hzz;

        branch_cond_out = 3'bzzz;
        load_save_reg_out = 4'bzzz;
        call_target_out   = 12'hzzz;
        //sign_ext_out      = 16'hzzzz;
        
    end
    
    else begin
        
        load_save_reg_out = load_save_reg_in;
        
        mem_to_reg     = c_mem_to_reg;    
        RegWrite_out   = c_RegWrite; 
        MemWrite_out   = c_MemWrite;
        MemRead_out    = c_MemRead;
        
        alu_src        = c_alu_src;  
        alu_op         = c_alu_op; 
        
        branch         = c_branch;    
        call           = c_call;   
        ret            = c_ret; 
        
        load_half      = c_load_half;
        
        read_data_1    = mem_read_data_1;
        read_data_2    = mem_read_data_2;

        arith_imm_out  = arith_imm_in;
        load_save_imm_out = load_save_imm_in;

    end
    
end

// Reset Control MUX
always_comb begin
    
    // Reset stack pointer
    if (rst) begin
        
        RegWrite  = 1;        // Write to SP
        WriteReg  = 4'b1111;  // SP register
        WriteData = 16'hFFFF; // Reset SP
        
    end
    
    else begin
    
        RegWrite  = RegWrite_in;
        WriteReg  = reg_rd_wb;
        WriteData = reg_rd_data;
        
    end
    
end
                
endmodule
