`include "defines.v"

module if_id(
	input wire clk,
	input wire rst,

	input wire[5:0] stall,

	input wire[`inst_addr_bus] if_pc,
	input wire[`inst_bus] if_inst,
	output reg[`inst_addr_bus] id_pc,
	output reg[`inst_bus] id_inst
);

always@(posedge clk)begin
	if(rst == `rst_enable)begin
		id_pc <= `zero_word;
		id_inst <= `zero_word;
	end else if(stall[1] == `stop && stall[2] == `no_stop)begin
		id_pc <= `zero_word;
		id_inst <= `zero_word;
	end else if(stall[1] == `no_stop)begin
		id_pc <= if_pc;
		id_inst <= if_inst;
	end
end

endmodule