`include "defines.v"

module id_ex(
	input wire clk,
	input wire rst,

	input wire[5:0] stall,

	input wire[`alu_op_bus] id_aluop,
	input wire[`alu_sel_bus] id_alusel,
	input wire[`reg_bus] id_reg1,
	input wire[`reg_bus] id_reg2,
	input wire[`reg_addr_bus] id_wd,
	input wire id_wreg,

	input wire[`reg_bus] id_link_address,
	input wire id_is_in_delayslot,
	input wire next_inst_in_delayslot_i,
	input wire[`reg_bus] id_inst,

	output reg[`alu_op_bus] ex_aluop,
	output reg[`alu_sel_bus] ex_alusel,
	output reg[`reg_bus] ex_reg1,
	output reg[`reg_bus] ex_reg2,
	output reg[`reg_addr_bus] ex_wd,
	output reg ex_wreg,

	output reg[`reg_bus] ex_link_address,
	output reg ex_is_in_delayslot,
	output reg is_in_delayslot_o,
	output reg[`reg_bus] ex_inst
);

always@(posedge clk)begin
	if(rst == `rst_enable)begin
		ex_aluop <= `exe_nop_op;
		ex_alusel <= `exe_res_nop;
		ex_reg1 <= `zero_word;
		ex_reg2 <= `zero_word;
		ex_wd <= `nop_reg_addr;
		ex_wreg <= `write_disable;
		ex_link_address <= `zero_word;
		ex_is_in_delayslot <= `not_in_delay_slot;
		is_in_delayslot_o <= `not_in_delay_slot;
		ex_inst <= `zero_word;
	end else if(stall[2] == `stop && stall[3] == `no_stop)begin
		ex_aluop <= `exe_nop_op;
		ex_alusel <= `exe_res_nop;
		ex_reg1 <= `zero_word;
		ex_reg2 <= `zero_word;
		ex_wd <= `nop_reg_addr;
		ex_wreg <= `write_disable;
		ex_link_address <= `zero_word;
		ex_is_in_delayslot <= `not_in_delay_slot;
		ex_inst <= `zero_word;
	end else if(stall[2] == `no_stop)begin
		ex_aluop <= id_aluop;
		ex_alusel <= id_alusel;
		ex_reg1 <= id_reg1;
		ex_reg2 <= id_reg2;
		ex_wd <= id_wd;
		ex_wreg <= id_wreg;
		ex_link_address <= id_link_address;
		ex_is_in_delayslot <= id_is_in_delayslot;
		is_in_delayslot_o <= next_inst_in_delayslot_i;
		ex_inst <= id_inst;
	end
end

endmodule