`include "cmd.vh"

module control_unit (
	
	input logic	[5:0] 	opcode,
	input logic	[5:0]		funct,
	
	output logic 			mem_to_reg,
	output logic 			mem_write,
	output logic 			branch,
	output logic [2:0] 	alu_control,
	output logic 			alu_src,
	output logic 			reg_dst,
	output logic 			reg_write
	
);

logic [1:0] alu_op;

always @(*) begin
	
	casez (opcode)
		
		`R_TYPE_OP: begin reg_write = 1; reg_dst = 1; alu_src = 0; branch = 0; mem_write = 0; mem_to_reg = 0; alu_op = 2'b10; end
		
		`LW_OP	 : begin reg_write = 1; reg_dst = 0; alu_src = 1; branch = 0; mem_write = 0; mem_to_reg = 1; alu_op = 2'b00; end
	
		`ADDI_OP	 : begin reg_write = 1; reg_dst = 0; alu_src = 1; branch = 0; mem_write = 0; mem_to_reg = 0; alu_op = 2'b00; end
		
		`SW_OP	 : begin reg_write = 0; alu_src = 1; branch = 0; mem_write = 1; alu_op = 2'b00; end
		
		`BEQ_OP	 : begin reg_write = 0; alu_src = 0; branch = 1; mem_write = 0; alu_op = 2'b01; end
				
		//`J_OP	 	 : begin reg_write = 0; mem_write = 0;  end
	
		default: ;
		
	endcase 
end

always @(*) begin
	casez ({alu_op,funct}) 
		
		{2'b00, 6'b??????}: alu_control = `ALU_ADD;
		{2'b?1, 6'b??????}: alu_control = `ALU_SUB;
		{2'b1?, `ADD_F} 	: alu_control = `ALU_ADD;
		{2'b1?, `SUB_F} 	: alu_control = `ALU_SUB;
		{2'b1?, `AND_F} 	: alu_control = `ALU_AND;
		{2'b1?, `OR_F }  	: alu_control = `ALU_OR ;
		{2'b1?, `SLT_F} 	: alu_control = `ALU_SLT;
		
		default				: alu_control = `ALU_ADD;
	
	endcase
end


endmodule