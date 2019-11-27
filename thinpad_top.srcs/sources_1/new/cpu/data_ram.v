`include "defines.v"

module data_ram (
	input wire clk,
	input wire ce,
	input wire we,
	input wire[`data_addr_bus] addr,
	input wire[3:0] sel,
	input wire[`data_bus] data_i,
	output reg[`data_bus] data_o
);

reg[`byte_width] data_mem0[0:`data_mem_num-1];
reg[`byte_width] data_mem1[0:`data_mem_num-1];
reg[`byte_width] data_mem2[0:`data_mem_num-1];
reg[`byte_width] data_mem3[0:`data_mem_num-1];

always@(posedge clk)begin
	if(ce == `chip_disable)begin
	end else if(we == `write_enable)begin
		if(sel[3] == 1'b1)begin
			data_mem3[addr[`data_mem_num_log2+1:2]] <= data_i[31:24];
		end
		if(sel[2] == 1'b1)begin
			data_mem2[addr[`data_mem_num_log2+1:2]] <= data_i[23:16];
		end
		if(sel[1] == 1'b1)begin
			data_mem1[addr[`data_mem_num_log2+1:2]] <= data_i[15:8];
		end
		if(sel[0] == 1'b1)begin
			data_mem0[addr[`data_mem_num_log2+1:2]] <= data_i[7:0];
		end
	end
end

always@(*)begin
	if(ce == `chip_disable)begin
		data_o <= `zero_word;
	end else if(we == `write_disable)begin
		data_o <= {data_mem3[addr[`data_mem_num_log2+1:2]],
		           data_mem2[addr[`data_mem_num_log2+1:2]],
		           data_mem1[addr[`data_mem_num_log2+1:2]],
		           data_mem0[addr[`data_mem_num_log2+1:2]]};
	end else begin
		data_o <= `zero_word;
	end
end

endmodule