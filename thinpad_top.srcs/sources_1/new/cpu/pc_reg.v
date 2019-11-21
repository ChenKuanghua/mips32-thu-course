`include "defines.v"

module pc_reg(
	input wire clk,
	input wire rst,
	output reg[`inst_addr_bus] pc,
	output reg ce
);

always@(posedge clk)begin
	if(ce == `chip_disable)begin
		pc <= `zero_word;
	end else begin
		pc <= pc+4'h4;
	end
end

always@(posedge clk)begin
	if(rst == `rst_enable)begin
		ce <= `chip_disable;
	end else begin
		ce <= `chip_enable;
	end
end

endmodule