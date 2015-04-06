// Author: Graham Nygard, Robert Wagner

/* For a better understanding of these in/out parameters,
   reference the sketch of the ID unit. Inputs and outputs
   are labeled in descending order down the IF/ID register
   and the ID/EX register respectively */
module ID_Unit(clk, cntrl_opcode, branch_cond, reg_rs, reg_rt,
               reg_rd_in, reg_rd_out, RegWrite, reg_rd_wb,
               reg_rd_data, arith_imm_in, load_save_imm_in,
               call_in, PC_in, PC_out, mem_to_reg, reg_to_mem,
               alu_op, alu_src, branch, read_data_1, read_data_2,
               arith_imm_out, sign_ext_out, load_save_imm_out,
               call_out);

/* INPUTS */
input        clk;              // The global clock input

//REGFILE INPUT PARAMS
input        RegWrite;         // Regfile RegWrite
input [3:0]  reg_rs;           // Inst[7:4]   - Regfile source 1
input [3:0]  reg_rt;           // Inst[3:0]   - Regfile source 2
input [3:0]  reg_rd_wb;        // Regfile write back register
input [15:0] reg_rd_data;      // Regfile write back data

//CONTROL PARAMS
input [3:0]  cntrl_opcode;      // Inst[15:12] - Instruction pcode
input [3:0]  branch_cond;       // Inst[11:8]  - Branch condition

//PIPELINE TO PIPELINE
input [3:0]  arith_imm_in;     // Inst[3:0]   - Imm of Arithmetic Inst
input [3:0]  reg_rd_in;        // Inst[11:8]  - Regfile future dest
input [7:0]  load_save_imm_in; // Inst[7:0]   - Imm of Load/Save Inst
input [11:0] call_in;          // Inst[11:0]  - Call target
input [15:0] PC_in;            // Program counter

/* OUTPUTS */

//CONTROL OUTPUTS 
output        mem_to_reg;        // LW signal to Memory unit  
output        reg_to_mem;        // SW signal to Memory unit
output        alu_src;           // ALU operand selection
output [2:0]  alu_op;            // ALU control unit input
output [2:0]  branch;            // Branch condition

//REGFILE OUTPUT PARAMS
output [15:0] read_data_1;       // Regfile Read_Bus_1
output [15:0] read_data_2;       // Regfile Read_Bus_2

//PIPELINE TO PIPELINE
output [3:0]  reg_rd_out;        // Future Regfile dest
output [3:0]  arith_imm_out;     // Imm of Arithmetic Inst
output [7:0]  load_save_imm_out; // Imm of Load/Save Inst
output [11:0] call_out;          // Call target
output [15:0] PC_out;            // Program counter

//SIGN-EXT UNIT OUTPUT
output [15:0] sign_ext_out;      // Output of sign extension unit


//INTERNAL CONTROL OUTPUTS
logic DataReg;                   /* Control signal to Regfile to
                                    specifiy the contents of the 
                                    Data Segment Register for
                                    supplying read_data_1 */

logic Call;                      /* Control signal to RegFile to
                                    specify the contents of the
                                    Stack_Pointer Register for
                                    supplying read_data_1 */
                                    
logic sign_ext_sel;              /* Control signal for selecting
                                    the which of the two immediate
                                    values (Arith, L/S) to sign
                                    extend */
                                    
//MODULE INSTANTIATIONS
Reg_16bit_file reg_mem(.clk(clk), .RegWrite(RegWrite), .DataReg(DataReg),
                       .Call(Call), .Read_Reg_1(reg_rs), .Read_Reg_2(reg_rt),
                       .WriteReg(reg_rd_wb), .Read_Bus_1(read_data_1),
                       .Read_Bus_2(read_data_2), .Write_Bus(reg_rd_data));

Control_Logic control(.opcode(cntrl_opcode), .branch_cond(branch_cond), 
                      .mem_to_reg(mem_to_reg), .reg_to_mem(reg_to_mem),
                      .alu_op(alu_op), .alu_src(alu_src), .branch(branch),
                      .data_reg(DataReg), .call(Call));
                      
Sign_Ext_Unit sign_ext(.arith_imm(arith_imm_in), 
                       .load_save_imm(load_save_imm_in),
                       .sign_ext_sel(sign_ext_sel),
                       .sign_ext_out(sign_ext_out));

HDT_Unit hazard_unit();


endmodule