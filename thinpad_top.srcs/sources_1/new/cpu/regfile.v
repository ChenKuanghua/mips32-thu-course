`include "defines.v"

module regfile(
	input wire clk,
	input wire rst,

	input wire we,
	input wire[`reg_addr_bus] waddr,
	input wire[`reg_bus] wdata,

	input wire re1,
	input wire[`reg_addr_bus] raddr1,
	output reg[`reg_bus] rdata1,

	input wire re2,
	input wire[`reg_addr_bus] raddr2,
	output reg[`reg_bus] rdata2
);

reg[`reg_bus] regs[0:`reg_num-1];

always@(posedge clk)begin
	if(rst == `rst_disable)begin
		if((we == `write_enable) && (waddr != `reg_num_log2'h0))begin
			regs[waddr] <= wdata;
		end
	end
end

always@(*)begin
	if(rst == `rst_enable)begin
		rdata1 <= `zero_word;
	end else if(raddr1 == `reg_num_log2'h0)begin
		rdata1 <= `zero_word;
	end else if((raddr1 == waddr) && (we == `write_enable) && (re1 == `read_enable))begin
		rdata1 <= wdata;
	end else if(re1 == `read_enable)begin
		rdata1 <= regs[raddr1];
	end else begin
		rdata1 <= `zero_word;
	end
end

always@(*)begin
	if(rst == `rst_enable)begin
		rdata2 <= `zero_word;
	end else if(raddr2 == `reg_num_log2'h0)begin
		rdata2 <= `zero_word;
	end else if((raddr2 == waddr) && (we == `write_enable) && (re2 == `read_enable))begin
		rdata2 <= wdata;
	end else if(re2 == `read_enable)begin
		rdata2 <= regs[raddr2];
	end else begin
		rdata2 <= `zero_word;
	end
end


endmodule