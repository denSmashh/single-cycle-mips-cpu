`timescale 1ns / 1ns

//`include "cmd.vh"

module mips_cpu_1_tb ();

logic clk; initial clk = 0;
logic reset_n;

logic [31:0] pc_db;
logic [31:0] data_db;


mips_cpu_1 i_cpu (
	.clk(clk),	
	.RSTn(reset_n),
	
	.pc_debug(pc_db),
	.data_debug(data_db)
);


// register file reset

integer i;
initial begin
	for(i = 0; i < 32; i = i + 1) 
			i_cpu.i_reg_file.mem_reg[i] = 0;
end

// instruction memory reset (all instruction 0x0)
initial begin
	for(i = 0; i < 32; i = i + 1) 
			i_cpu.i_instr_mem.mem[i] = 0;
end


// load machine code
initial begin

		i_cpu.i_instr_mem.mem[0] = 'h20030080;		// addi 0x0 0x3 0b0000000010000000	(write decimal 128 in register $3   )
		i_cpu.i_instr_mem.mem[1] = 'h2004000F;		// addi 0x0 0x4 0b0000000000001111  (write decimal 16  in register $4   )
		i_cpu.i_instr_mem.mem[2] = 'hAC040000;		// sw   0x0 0x4 0b0000000000000000	(store in mem[0x0+0x0] register $4  )   
		i_cpu.i_instr_mem.mem[3] = 'h8C050000;		// lw   0x5 0x0 0b0000000000000000	(write in register $5 mem[0x0+0x0]  )
		i_cpu.i_instr_mem.mem[4] = 'h10830010;		// beq  0x4 0x5 0x000c (if $4 == $5, branch in 12 steps; *true condition)
		i_cpu.i_instr_mem.mem[5] = 'h00000000;		// nop (no operations)
		i_cpu.i_instr_mem.mem[6] = 'h00000000;		// nop (no operations)
		i_cpu.i_instr_mem.mem[7] = 'h10A4000C;		// beq (if $4 == $3, branch in 128 steps; *false condition)
		
end


always #10 clk = ~clk;


initial begin

reset_n = 1; #1;
reset_n = 0; #5;
reset_n = 1; 


end


endmodule
