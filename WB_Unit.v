// Author: Graham Nygard, Robert Wagner

module WB_Unit(mem_to_reg, mem_read_data, alu_result, reg_rd_in, HALT_in,
	            reg_rd_out, write_back_data, HALT_out);

////////////////////////////INPUTS////////////////////////////////

input mem_to_reg;
input [15:0] mem_read_data;
input [15:0] alu_result;
input [3:0]  reg_rd_in;

input HALT_in;

//////////////////////////////////////////////////////////////////

////////////////////////////OUTPUTS///////////////////////////////

output logic [3:0]  reg_rd_out;      // Register to write return data
output logic [15:0] write_back_data; // Data to write back

output logic HALT_out;

//////////////////////////////////////////////////////////////////

assign reg_rd_out = reg_rd_in;

// Mux for selecting writeback data source
always_comb begin

   if (mem_to_reg)
      write_back_data = mem_read_data;
   else
      write_back_data = alu_result;

end

assign HALT_out = HALT_in;

endmodule
