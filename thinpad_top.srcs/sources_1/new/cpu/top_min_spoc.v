`include "defines.v"

module top_min_spoc(
	input wire clk,
	input wire rst
);

wire[`inst_addr_bus] inst_addr;
wire[`inst_bus] inst;
wire rom_ce;

top top0(
	.clk(clk),
	.rst(rst),
	.rom_addr_o(inst_addr),
	.rom_data_i(inst),
	.rom_ce_o(rom_ce)
);

inst_rom inst_rom0(
	.addr(inst_addr),
	.inst(inst),
	.ce(rom_ce)
);

endmodule
