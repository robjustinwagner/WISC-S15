// Author: Graham Nygard, Robert Wagner

module WB_Unit(clk, 
	mem_read_data, alu_result, mem_to_reg, reg_rd_in, /*ret_in*/, 
	write_back_data, reg_rd_out, RegWrite, /*ret_out*/);

//INPUTS
input        clk;
//input        ret_in;
input        mem_to_reg;
input [3:0]  reg_rd_in;
input [15:0] mem_read_data;
input [15:0] alu_result;

//OUTPUTS
//output logic        ret_out;         // Return signal for PC_Update
output logic        RegWrite;        // Regfile signal to write reg_rd_out
output logic [3:0]  reg_rd_out;      // Register to write return_data
output logic [15:0] write_back_data; // Data to write back

//INTERCONNECTS

assign ret_out = ret_in;
assign RegWrite = mem_to_reg;
assign reg_rd_out = reg_rd_in;

// Mux for selecting writeback data source
always_comb begin

   if (mem_to_reg)
      write_back_data = mem_read_data;
   else
      write_back_data = alu_result;

end


endmodule