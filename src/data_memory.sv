module data_memory
#(
	parameter DATA_MEM_SIZE = 64
)
(
	input logic 				clk,
	input logic 				rstn,
	
	input logic		[31:0]	addr,
	input logic					we,
	input logic		[31:0]	wd,
	
	output logic	[31:0]	rd
	
);

 
logic [31:0] data_mem [DATA_MEM_SIZE - 1 : 0];

always @(posedge clk, negedge rstn) begin
	
	if(~rstn) begin
		for(int i = 0; i < DATA_MEM_SIZE; i = i + 1) data_mem[i] <= 32'b0;
	end
	
	else begin
		if(we == 1) data_mem[addr] <= wd;
	end
end
 
assign rd = data_mem[addr]; 


endmodule 