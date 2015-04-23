module unified_mem(clk,rst_n,addr,re,we,wdata,rd_data,rdy);

/////////////////////////////////////////////////////////////////////
// Unified memory with 4-clock access times for reads & writes.   //
// Organized as 16384 64-bit words (i.e. same width a cache line //
//////////////////////////////////////////////////////////////////
input clk,rst_n;
input re,we;
input [14:0] addr;			// 2 LSB's are dropped since accessing as four 16-bit words
input [31:0] wdata;

output reg [31:0] rd_data;
output reg rdy;				// deasserted when memory operation completed

reg [15:0] mem[0:65535];		// entire memory space at 16-bits wide

//////////////////////////
// Define states of SM //
////////////////////////
localparam IDLE 	= 2'b00;
localparam WRITE 	= 2'b01;
localparam READ    	= 2'b10;

reg [14:0] addr_capture;								// capture the address at start of read
reg [1:0] state,nxt_state;								// state register
reg [1:0] wait_state_cnt;								// counter for 4-clock access time
reg clr_cnt,int_we,int_re;								// state machine outputs

////////////////////////////////
// initial load of instr.hex //
//////////////////////////////
initial
  $readmemh("instr.hex",mem);
  
/////////////////////////////////////////////////
// Capture address at start of read or write  //
// operation to ensure address is held       //
// stable during entire access time.        //
/////////////////////////////////////////////
always @(posedge clk)
  if (re | we)
    addr_capture <= addr;			// this is actual address used to access memory

//////////////////////////
// Model memory writes //
////////////////////////
always @(clk,int_we)
  if (clk & int_we)				// write occurs on clock high during 4th clock cycle
    begin
          mem[{addr_capture,1’b0}] <= wdata[15:0];
	  mem[{addr_capture,1’b1}] <= wdata[31:16];
	end
	
/////////////////////////
// Model memory reads //
///////////////////////
always @(clk,int_re)
  if (clk & int_re)				// reads occur on clock high during 4th clock cycle
    rd_data = {mem[{addr_capture,1’b1}],mem[{addr_capture,1’b0}]};
	 
	
////////////////////////
// Infer state flops //
//////////////////////
always @(posedge clk, negedge rst_n)
  if (!rst_n)
    state <= IDLE;
  else
    state <= nxt_state;
	
/////////////////////////
// wait state counter //
///////////////////////
always @(posedge clk, negedge rst_n)
  if (!rst_n)
    wait_state_cnt <= 2'b00;
  else
    if (clr_cnt)
      wait_state_cnt <= 2'b00;
	else
      wait_state_cnt <= wait_state_cnt + 1;
	
always @(state,re,we,wait_state_cnt)
begin
////////////////////////////
// default outputs of SM //
//////////////////////////
clr_cnt = 1;		// hold count in reset
int_we = 0;		// wait till 4th clock
int_re = 0;		// wait till 4th clock
nxt_state = IDLE;
	
case (state)
	IDLE : if (we) begin
	       clr_cnt = 0;
	       rdy = 0;
	       nxt_state = WRITE;
	       end
	       else if (re) begin
	       clr_cnt = 0;
	       rdy = 0;
	       nxt_state = READ;
	       end
	       else rdy = 1;
	  
	WRITE : if (&wait_state_cnt) begin
	        int_we = 1;		// write completes and next state is IDLE
		rdy = 1;
		end
		else begin
		clr_cnt = 0;
		rdy = 0;
		nxt_state = WRITE;
		end
	  
	default : if (&wait_state_cnt) begin	// this state is READ
		  int_re = 1;	// read completes and next state is IDLE
		  rdy = 1;
		  end
		  else begin
		  clr_cnt = 0;
		  rdy = 0;
		  nxt_state = READ;
		  end
endcase
end

endmodule
	
	