
/* top-level module  */


module mips_cpu_1(
	input 	logic 			clk,	
	input 	logic 			RSTn,
	
	output 	logic	[31:0]	pc_debug,
	output 	logic	[31:0]	data_debug
	
	
);

// control unit wires
logic mem2reg;
logic mem_write;
logic branch;
logic alu_src;
logic reg_dst;
logic reg_write;
logic [2:0] alu_control;

// instruction from instruction memory
logic [31:0] mips_instruction;

// sign immidiate
logic [31:0] sign_imm;

// input a3 for register file
logic [4:0] a3; 

// alu wires
logic [31:0] data_1;
logic [31:0] data_2;
logic [31:0] srcB;
logic [31:0] alu_result;
logic alu_zero;

// memory wires
logic [31:0] rd_mem;
logic [31:0] data_mem2rf;


// program counter
logic [31:0] pc;
logic [31:0] pc_branch; 
logic [31:0] pc_next;

assign pc_debug = pc; 			// debug
assign data_debug = rd_mem;	// debug

assign srcB = (alu_src) ? sign_imm : data_2;
assign a3 = (reg_dst) ? mips_instruction[15:11] : mips_instruction[20:16];
assign data_mem2rf = (mem2reg) ? rd_mem : alu_result; 

assign pc_branch = pc + 1 + sign_imm;
assign pc_next = ~(branch & alu_zero) ? (pc + 1): pc_branch;


always @(posedge clk, negedge RSTn) begin
	
	if(~RSTn) pc <= 32'b0;
	else pc <= pc_next;

end  


instruction_memory #(.INSTR_MEM_SIZE(128)) i_instr_mem
(
	.addr	(pc					),
	.rd	(mips_instruction	)
);


register_file i_reg_file 
(
	.clk		(clk							),
	.rstn		(RSTn							),
	
	.a1		(mips_instruction[25:21]),		
	.a2		(mips_instruction[20:16]),		
	.a3		(a3							),
	.we3		(reg_write					),
	.wd3		(data_mem2rf 				),
	.rd1		(data_1						),
	.rd2		(data_2						)
);



sign_extend i_sign_extend
(
	.imm			(mips_instruction[15:0]	),
	.signImm		(sign_imm					)	
);



control_unit i_control_unit
(
	.opcode				(mips_instruction[31:26]),
	.funct				(mips_instruction[5:0]	),
	.mem_to_reg			(mem2reg						),
	.mem_write			(mem_write					),
	.branch				(branch						),
	.alu_control		(alu_control				),
	.alu_src				(alu_src						),
	.reg_dst				(reg_dst						),
	.reg_write			(reg_write					)
);



alu i_alu
(
	.srcA					(data_1						),
	.srcB					(srcB							),
	.alu_control		(alu_control				),
	.zero_flag			(alu_zero					),
	.alu_result			(alu_result					)
);



data_memory #(.DATA_MEM_SIZE(16)) i_data_mem
(
	.clk			(clk				),
	.rstn			(RSTn				),
	.addr			(alu_result		),
	.we			(mem_write		),
	.wd			(data_2			),
	.rd			(rd_mem			)
);



endmodule 