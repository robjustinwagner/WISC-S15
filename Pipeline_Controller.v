// Author: Graham Nygard, Robert Wagner

module pipeline_controller(clk, data_mem_access, en);

//INPUTS
input clk;
input data_mem_access;

logic [1:0] counter = 2'b11;

//OUTPUTS
output en;

//Enable the pipeline when the counter reaches its maximum value
assign en = &counter;

always @(posedge clk) begin
   counter <= counter + 1;
/*
   if(data_mem_access) begin
   end
   else begin
      en <= 1;
   end
end

always @(negedge clk) begin
   en <= 0;
end

always @(counter) begin
   */
end

endmodule