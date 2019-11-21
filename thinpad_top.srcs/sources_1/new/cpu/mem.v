`include "defines.v"

module mem(
	input wire rst,

	input wire[`reg_addr_bus] wd_i,
	input wire wreg_i,
	input wire[`reg_bus] wdata_i,

	output reg[`reg_addr_bus] wd_o,
	output reg wreg_o,
	output reg[`reg_bus] wdata_o
);

always@(*)begin
	if(rst == `rst_enable)begin
		wd_o <= `nop_reg_addr;
		wreg_o <= `write_disable;
		wdata_o <= `zero_word;
	end else begin
		wd_o <= wd_i;
		wreg_o <= wreg_i;
		wdata_o <= wdata_i;
	end
end

endmodule