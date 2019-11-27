`include "defines.v"

module ex_mem(
	input wire clk,
	input wire rst,

	input wire[5:0] stall,

	input wire[`reg_addr_bus] ex_wd,
	input wire ex_wreg,
	input wire[`reg_bus] ex_wdata,
	input wire[`reg_bus] ex_hi,
	input wire[`reg_bus] ex_lo,
	input ex_whilo,

	input wire[`alu_op_bus] ex_aluop,
	input wire[`reg_bus] ex_mem_addr,
	input wire[`reg_bus] ex_reg2,

	input wire[`double_reg_bus] hilo_i,
	input wire[1:0] cnt_i,

	output reg[`reg_addr_bus] mem_wd,
	output reg mem_wreg,
	output reg[`reg_bus] mem_wdata,
	output reg[`reg_bus] mem_hi,
	output reg[`reg_bus] mem_lo,
	output reg mem_whilo,

	output reg[`alu_op_bus] mem_aluop,
	output reg[`reg_bus] mem_mem_addr,
	output reg[`reg_bus] mem_reg2,

	output reg[`double_reg_bus] hilo_o,
	output reg[1:0] cnt_o
);

always@(posedge clk)begin
	if(rst == `rst_enable)begin
		mem_wd <=  `nop_reg_addr;
		mem_wreg <=  `write_disable;
		mem_wdata <= `zero_word;
		mem_hi <= `zero_word;
		mem_lo <= `zero_word;
		mem_whilo <= `write_disable;
		hilo_o <= {`zero_word, `zero_word};
		cnt_o <= 2'b00;
		mem_aluop <= `exe_nop_op;
		mem_mem_addr <= `zero_word;
		mem_reg2 <= `zero_word;
	end else if(stall[3] == `stop && stall[4] == `no_stop)begin
		mem_wd <= `nop_reg_addr;
		mem_wreg <= `write_disable;
		mem_wdata <= `zero_word;
		mem_hi <= `zero_word;
		mem_lo <= `zero_word;
		mem_whilo <= `write_disable;
		hilo_o <= hilo_i;
		cnt_o <= cnt_i;
		mem_aluop <= `exe_nop_op;
		mem_mem_addr <= `zero_word;
		mem_reg2 <= `zero_word;
	end else if(stall[3] == `no_stop)begin
		mem_wd <= ex_wd;
		mem_wreg <= ex_wreg;
		mem_wdata <= ex_wdata;
		mem_hi <= ex_hi;
		mem_lo <= ex_lo;
		mem_whilo <= ex_whilo;
		hilo_o <= {`zero_word, `zero_word};
		cnt_o <= 2'b00;
		mem_aluop <= ex_aluop;
		mem_mem_addr <= ex_mem_addr;
		mem_reg2 <= ex_reg2;
	end else begin
		hilo_o <= hilo_i;
		cnt_o <= cnt_i;
	end
end

endmodule