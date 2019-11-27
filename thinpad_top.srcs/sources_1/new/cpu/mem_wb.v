`include "defines.v"

module mem_wb(
	input wire clk,
	input wire rst,

	input wire[5:0] stall,
	
	input wire[`reg_addr_bus] mem_wd,
	input wire mem_wreg,
	input wire[`reg_bus] mem_wdata,
	input wire[`reg_bus] mem_hi,
	input wire[`reg_bus] mem_lo,
	input wire mem_whilo,
	
	input wire mem_LLbit_we,
	input wire mem_LLbit_value,

	output reg[`reg_addr_bus] wb_wd,
	output reg wb_wreg,
	output reg[`reg_bus] wb_wdata,
	output reg[`reg_bus] wb_hi,
	output reg[`reg_bus] wb_lo,
	output reg wb_whilo,

	output reg wb_LLbit_we,
	output reg wb_LLbit_value
);

always@(posedge clk)begin
	if(rst == `rst_enable)begin
		wb_wd <= `nop_reg_addr;
		wb_wreg <= `write_disable;
		wb_wdata <= `zero_word;
		wb_hi <= `zero_word;
		wb_lo <= `zero_word;
		wb_whilo <= `write_disable;
		wb_LLbit_we <= 1'b0;
		wb_LLbit_value <= 1'b0;
	end else if(stall[4] == `stop && stall[5] == `no_stop)begin
		wb_wd <= `nop_reg_addr;
		wb_wreg <= `write_disable;
		wb_wdata <= `zero_word;
		wb_hi <= `zero_word;
		wb_lo <= `zero_word;
		wb_whilo <= `write_disable;
		wb_LLbit_we <= 1'b0;
		wb_LLbit_value <= 1'b0;
	end else if(stall[4] == `no_stop)begin
		wb_wd <= mem_wd;
		wb_wreg <= mem_wreg;
		wb_wdata <= mem_wdata;
		wb_hi <= mem_hi;
		wb_lo <= mem_lo;
		wb_whilo <= mem_whilo;
		wb_LLbit_we <= mem_LLbit_we;
		wb_LLbit_value <= mem_LLbit_value;
	end
end

endmodule