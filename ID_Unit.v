// Author: Graham Nygard, Robert Wagner

/* For a better understanding of these in/out parameters,
   reference the sketch of the ID unit. Inputs and outputs
   are labeled in descending order down the IF/ID register
   and the ID/EX register respectively */
module ID_Unit(clk, cntrl_input, reg_rs, reg_rt, reg_rd,
               arith_imm_in, load_save_imm_in, call_in,
               PC_in, PC_out, mem_to_reg, reg_to_mem, alu_op,
               alu_src, branch, read_data_1, read_data_2,
               arith_imm_out, sign_ext, load_save_imm_out,
               call_out);

//INPUTS
input clk;
input RegWrite;                // Regfile RegWrite
input [3:0]  cntrl_input;      // Inst[15:12] - Control unit input
input [3:0]  reg_rs;           // Inst[7:4]   - Regfile source
input [3:0]  reg_rt;           // Inst[3:0]   - Regfile source/dest
input [3:0]  reg_rd;           // Inst[11:8]  - Regfile dest
input [3:0]  arith_imm_in;     // Inst[3:0]   - Imm of Arithmetic Inst
input [7:0]  load_save_imm_in; // Inst[7:0]   - Imm of Load/Save Inst
input [11:0] call_in;          // Inst[11:0]  - Call target
input [15:0] PC_in;            // Program counter

//OUTPUT 
output        mem_to_reg;        // LW signal to Memory unit  
output        reg_to_mem;        // SW signal to Memory unit
output        alu_src;           // ALU operand seleciton
output [3:0]  alu_op;            // ALU control unit input
output [3:0]  branch;            // Branch condition
output [3:0]  arith_imm_out;     // Imm of Arithmetic Inst
output [7:0]  load_save_imm_out; // Imm of Load/Save Inst
output [11:0] call_out;          // Call target
output [15:0] read_data_1;       // Regfile Read_Bus_1
output [15:0] read_data_2;       // Regfile Read_Bus_2
output [15:0] sign_ext;          // Output of sign extension unit
output [15:0] PC_out;            // Program counter

//INTERNAL CONTROL
logic DataReg;                   /* Control signal to Regfile to
                                    specifiy the contents of the 
                                    Data Segment Register for
                                    supplying read_data_1 */

logic Call;                      /* Control signal to RegFile to
                                    specify the contents of the
                                    Stack_Pointer Register for
                                    supplying read_data_1 */
                                    
logic WriteDest;


//WRITE REGISTER MUX



//MODULE INSTANTIATIONS
Reg_16bit_file reg_mem(clk, RegWrite, DataReg, Call,
                       Read_Reg_1, Read_Reg_2, Write_Reg,
                       Read_Bus_1, Read_Bus_2, Write_Bus);

Control_Logic control(cntrl_input, mem_to_reg, reg_to_mem,
                      alu_op, alu_src, branch,);
                      
Sign_Ext_Unit sign_ext(arith_imm_in, load_save_imm_in);

HDT_Unit hazard_unit();


endmodule