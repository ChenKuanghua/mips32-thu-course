`include "defines.v"

module id(
	input wire rst,
	input wire[`inst_addr_bus] pc_i,
	input wire[`inst_bus] inst_i,

	input wire ex_wreg_i,
	input wire[`reg_bus] ex_wdata_i,
	input wire[`reg_addr_bus] ex_wd_i,

	input wire mem_wreg_i,
	input wire[`reg_bus] mem_wdata_i,
	input wire[`reg_addr_bus] mem_wd_i,

	input wire[`reg_bus] reg1_data_i,
	input wire[`reg_bus] reg2_data_i,

	output reg reg1_read_o,
	output reg reg2_read_o,
	output reg[`reg_addr_bus] reg1_addr_o,
	output reg[`reg_addr_bus] reg2_addr_o,

	output reg[`alu_op_bus] aluop_o,
	output reg[`alu_sel_bus] alusel_o,
	output reg[`reg_bus] reg1_o,
	output reg[`reg_bus] reg2_o,
	output reg[`reg_addr_bus] wd_o,
	output reg wreg_o
);

wire[5:0] op = inst_i[31:26];
wire[4:0] op2 = inst_i[10:6];
wire[5:0] op3 = inst_i[5:0];
wire[4:0] op4 = inst_i[20:16];
reg[`reg_bus] imm;
reg inst_valid;

always@(*)begin
	if(rst == `rst_enable)begin
		aluop_o <= `exe_nop_op;
		alusel_o <= `exe_res_nop;
		wd_o <= `nop_reg_addr;
		wreg_o <= `write_disable;
		inst_valid <= `inst_valid;
		reg1_read_o <= 1'b0;
		reg2_read_o <= 1'b0;
		reg1_addr_o <= `nop_reg_addr;
		reg2_addr_o <= `nop_reg_addr;
		imm <= `zero_word;
	end else begin
		aluop_o <= `exe_nop_op;
		alusel_o <= `exe_res_nop;
		wd_o <= inst_i[15:11];
		wreg_o <= `write_disable;
		inst_valid <= `inst_valid;
		reg1_read_o <= 1'b0;
		reg2_read_o <= 1'b0;
		reg1_addr_o <= inst_i[25:21];
		reg2_addr_o <= inst_i[20:16];
		imm <= `zero_word;
		case(op)
			`exe_special_inst:begin
				case(op2)
					5'b00000:begin
						case(op3)
							`exe_or:begin
								wreg_o <= `write_enable;
								aluop_o <= `exe_or_op;
								alusel_o <= `exe_res_logic;
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								inst_valid <= `inst_valid;
							end
							`exe_and:begin
								wreg_o <= `write_enable;
								aluop_o <= `exe_and_op;
								alusel_o <= `exe_res_logic;
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								inst_valid <= `inst_valid;
							end
							`exe_xor:begin
								wreg_o <= `write_enable;
								aluop_o <= `exe_xor_op;
								alusel_o <= `exe_res_logic;
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								inst_valid <= `inst_valid;
							end
							`exe_nor:begin
								wreg_o <= `write_enable;
								aluop_o <= `exe_nor_op;
								alusel_o <= `exe_res_logic;
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								inst_valid <= `inst_valid;
							end
							`exe_sllv:begin
								wreg_o <= `write_enable;
								aluop_o <= `exe_sll_op;
								alusel_o <= `exe_res_shift;
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								inst_valid <= `inst_valid;
							end
							`exe_srlv:begin
								wreg_o <= `write_enable;
								aluop_o <= `exe_srl_op;
								alusel_o <= `exe_res_shift;
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								inst_valid <= `inst_valid;
							end
							`exe_srav:begin
								wreg_o <= `write_enable;
								aluop_o <= `exe_sra_op;
								alusel_o <= `exe_res_shift;
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								inst_valid <= `inst_valid;
							end
							`exe_sync:begin
								wreg_o <= `write_disable;
								aluop_o <= `exe_nop_op;
								alusel_o <= `exe_res_nop;
								reg1_read_o <= 1'b0;
								reg2_read_o <= 1'b1;
								inst_valid <= `inst_valid;
							end
							default:begin
							end
						endcase
					end
					default:begin
					end
				endcase
			end
			`exe_ori:begin
				wreg_o <= `write_enable;
				aluop_o <= `exe_or_op;
				alusel_o <= `exe_res_logic;
				reg1_read_o <= 1'b1;
				reg2_read_o <= 1'b0;
				imm <= {16'h0, inst_i[15:0]};
				wd_o <= inst_i[20:16];
				inst_valid <= `inst_valid;
			end
			`exe_andi:begin
				wreg_o <= `write_enable;
				aluop_o <= `exe_and_op;
				alusel_o <= `exe_res_logic;
				reg1_read_o <= 1'b1;
				reg2_read_o <= 1'b0;
				imm <= {16'h0, inst_i[15:0]};
				wd_o <= inst_i[20:16];
				inst_valid <= `inst_valid;
			end
			`exe_xori:begin
				wreg_o <= `write_enable;
				aluop_o <= `exe_xor_op;
				alusel_o <= `exe_res_logic;
				reg1_read_o <= 1'b1;
				reg2_read_o <= 1'b0;
				imm <= {16'h0, inst_i[15:0]};
				wd_o <= inst_i[20:16];
				inst_valid <= `inst_valid;
			end
			`exe_lui:begin
				wreg_o <= `write_enable;
				aluop_o <= `exe_or_op;
				alusel_o <= `exe_res_logic;
				reg1_read_o <= 1'b1;
				reg2_read_o <= 1'b0;
				imm <= {inst_i[15:0], 16'h0};
				wd_o <= inst_i[20:16];
				inst_valid <= `inst_valid;
			end
			`exe_pref:begin
				wreg_o <= `write_enable;
				aluop_o <= `exe_nop_op;
				alusel_o <= `exe_res_nop;
				reg1_read_o <= 1'b0;
				reg2_read_o <= 1'b0;
				inst_valid <= `inst_valid;
			end
			default:begin
			end
		endcase

		if(inst_i[31:21] == 11'b00000000000)begin
			if(op3 == `exe_sll)begin
				wreg_o <= `write_enable;
				aluop_o <= `exe_sll_op;
				alusel_o <= `exe_res_shift;
				reg1_read_o <= 1'b0;
				reg2_read_o <= 1'b1;
				imm[4:0] <= inst_i[10:6];
				wd_o <= inst_i[15:11];
				inst_valid <= `inst_valid;
			end else if(op3 == `exe_srl)begin
				wreg_o <= `write_enable;
				aluop_o <= `exe_srl_op;
				alusel_o <= `exe_res_shift;
				reg1_read_o <= 1'b0;
				reg2_read_o <= 1'b1;
				imm[4:0] <= inst_i[10:6];
				wd_o <= inst_i[15:11];
				inst_valid <= `inst_valid;
			end else if(op3 == `exe_sra)begin
				wreg_o <= `write_enable;
				aluop_o <= `exe_sra_op;
				alusel_o <= `exe_res_shift;
				reg1_read_o <= 1'b0;
				reg2_read_o <= 1'b1;
				imm[4:0] <= inst_i[10:6];
				wd_o <= inst_i[15:11];
				inst_valid <= `inst_valid;
			end
		end
	end
end

always@(*)begin
	if(rst == `rst_enable)begin
		reg1_o <= `zero_word;
	end else if((reg1_read_o == 1'b1) && (ex_wreg_i == 1'b1)
				&& (ex_wd_i == reg1_addr_o))begin
		reg1_o <= ex_wdata_i;
	end else if((reg1_read_o == 1'b1) && (mem_wreg_i == 1'b1)
				&& (mem_wd_i == reg1_addr_o))begin
		reg1_o <= mem_wdata_i;
	end else if(reg1_read_o == 1'b1)begin
		reg1_o <= reg1_data_i;
	end else if(reg1_read_o == 1'b0)begin
		reg1_o <= imm;
	end else begin
		reg1_o <= `zero_word;
	end
end

always@(*)begin
	if(rst == `rst_enable)begin
		reg2_o <= `zero_word;
	end else if((reg2_read_o == 1'b1) && (ex_wreg_i == 1'b1)
				&& (ex_wd_i == reg2_addr_o))begin
		reg2_o <= ex_wdata_i;
	end else if((reg2_read_o == 1'b1) && (mem_wreg_i == 1'b1)
				&& (mem_wd_i == reg2_addr_o))begin
		reg2_o <= mem_wdata_i;
	end else if(reg2_read_o == 1'b1)begin
		reg2_o <= reg2_data_i;
	end else if(reg2_read_o == 1'b0)begin
		reg2_o <= imm;
	end else begin
		reg2_o <= `zero_word;
	end
end

endmodule // id