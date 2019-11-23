`include "defines.v"

module mem(
	input wire rst,

	input wire[`reg_addr_bus] wd_i,
	input wire wreg_i,
	input wire[`reg_bus] wdata_i,
	input wire[`reg_bus] hi_i,
	input wire[`reg_bus] lo_i,
	input wire whilo_i,

	output reg[`reg_addr_bus] wd_o,
	output reg wreg_o,
	output reg[`reg_bus] wdata_o,
	output reg[`reg_bus] hi_o,
	output reg[`reg_bus] lo_o,
	output reg whilo_o
);

always@(*)begin
	if(rst == `rst_enable)begin
		wd_o <= `nop_reg_addr;
		wreg_o <= `write_disable;
		wdata_o <= `zero_word;
		hi_o <= `zero_word;
		lo_o <= `zero_word;
		whilo_o <= `write_disable;
	end else begin
		wd_o <= wd_i;
		wreg_o <= wreg_i;
		wdata_o <= wdata_i;
		hi_o <= hi_i;
		lo_o <= lo_i;
		whilo_o <= whilo_i;
	end
end

endmodule