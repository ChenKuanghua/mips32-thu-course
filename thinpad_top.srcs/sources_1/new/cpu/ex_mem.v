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

	input wire[`double_reg_bus] hilo_i,
	input wire[1:0] cnt_i,

	output reg[`reg_addr_bus] mem_wd,
	output reg mem_wreg,
	output reg[`reg_bus] mem_wdata,
	output reg[`reg_bus] mem_hi,
	output reg[`reg_bus] mem_lo,
	output reg mem_whilo,

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
	end else if(stall[3] == `stop && stall[4] == `no_stop)begin
		mem_wd <= `nop_reg_addr;
		mem_wreg <= `write_disable;
		mem_wdata <= `zero_word;
		mem_hi <= `zero_word;
		mem_lo <= `zero_word;
		mem_whilo <= `write_disable;
		hilo_o <= hilo_i;
		cnt_o <= cnt_i;
	end else if(stall[3] == `no_stop)begin
		mem_wd <= ex_wd;
		mem_wreg <= ex_wreg;
		mem_wdata <= ex_wdata;
		mem_hi <= ex_hi;
		mem_lo <= ex_lo;
		mem_whilo <= ex_whilo;
		hilo_o <= {`zero_word, `zero_word};
		cnt_o <= 2'b00;
	end else begin
		hilo_o <= hilo_i;
		cnt_o <= cnt_i;
	end
end

endmodule