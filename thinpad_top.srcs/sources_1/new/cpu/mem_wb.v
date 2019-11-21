`include "defines.v"

module mem_wb(
	input wire clk,
	input wire rst,
	input wire[`reg_addr_bus] mem_wd,
	input wire mem_wreg,
	input wire[`reg_bus] mem_wdata,
	output reg[`reg_addr_bus] wb_wd,
	output reg wb_wreg,
	output reg[`reg_bus] wb_wdata
);

always@(posedge clk)begin
	if(rst == `rst_enable)begin
		wb_wd <= `nop_reg_addr;
		wb_wreg <= `write_disable;
		wb_wdata <= `zero_word;
	end else begin
		wb_wd <= mem_wd;
		wb_wreg <= mem_wreg;
		wb_wdata <= mem_wdata;
	end
end

endmodule