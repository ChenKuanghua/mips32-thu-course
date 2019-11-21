`include "defines.v"

module ex_mem(
	input wire clk,
	input wire rst,

	input wire[`reg_addr_bus] ex_wd,
	input wire ex_wreg,
	input wire[`reg_bus] ex_wdata,

	output reg[`reg_addr_bus] mem_wd,
	output reg mem_wreg,
	output reg[`reg_bus] mem_wdata
);

always@(posedge clk)begin
	if(rst == `rst_enable)begin
		mem_wd <=  `nop_reg_addr;
		mem_wreg <=  `write_disable;
		mem_wdata <= `zero_word;
	end else begin
		mem_wd <= ex_wd;
		mem_wreg <= ex_wreg;
		mem_wdata <= ex_wdata;
	end
end

endmodule