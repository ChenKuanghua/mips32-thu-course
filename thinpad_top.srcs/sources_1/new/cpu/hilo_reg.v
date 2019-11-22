`include "defines.v"

module hilo_reg(
	input wire clk,
	input wire rst,

	input wire we,
	input wire[`reg_bus] hi_i,
	input wire[`reg_bus] lo_i,

	output reg[`reg_bus] hi_o,
	output reg[`reg_bus] lo_o
);

always@(posedge clk)begin
	if(rst == `rst_enable)begin
		hi_o <= `zero_word;
		lo_o <= `zero_word;
	end else if(we == `write_enable)begin
		hi_o <= hi_i;
		lo_o <= lo_i;
	end
end

endmodule // hilo_reg
