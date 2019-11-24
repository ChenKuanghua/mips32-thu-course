`include "defines.v"

module ex(
	input wire rst,

	input wire[`alu_op_bus] aluop_i,
	input wire[`alu_sel_bus] alusel_i,
	input wire[`reg_bus] reg1_i,
	input wire[`reg_bus] reg2_i,
	input wire[`reg_addr_bus] wd_i,
	input wire wreg_i,

	input wire[`reg_bus] hi_i,
	input wire[`reg_bus] lo_i,

	input wire[`reg_bus] wb_hi_i,
	input wire[`reg_bus] wb_lo_i,
	input wire wb_whilo_i,

	input wire[`reg_bus] mem_hi_i,
	input wire[`reg_bus] mem_lo_i,
	input wire mem_whilo_i,

	input wire[`double_reg_bus] hilo_tmp_i,
	input wire[1:0] cnt_i,

	input wire[`double_reg_bus] div_result_i,
	input wire div_ready_i,

	input wire[`reg_bus] link_address_i,
	input wire is_in_delayslot_i,

	output reg[`reg_addr_bus] wd_o,
	output reg wreg_o,
	output reg[`reg_bus] wdata_o,

	output reg[`reg_bus] hi_o,
	output reg[`reg_bus] lo_o,
	output reg whilo_o,

	output reg[`double_reg_bus] hilo_tmp_o,
	output reg[1:0] cnt_o,

	output reg[`reg_bus] div_opdata1_o,
	output reg[`reg_bus] div_opdata2_o,
	output reg div_start_o,
	output reg signed_div_o,

	output reg stallreq
);

reg[`reg_bus] logic_out;
reg[`reg_bus] shift_res;
reg[`reg_bus] move_res;
reg[`reg_bus] arithmetic_res;
reg[`double_reg_bus] mul_res;
reg[`reg_bus] HI;
reg[`reg_bus] LO;
wire[`reg_bus] reg2_i_mux;
wire[`reg_bus] reg1_i_not;
wire[`reg_bus] result_sum;
wire ov_sum;
wire reg1_eq_reg2;
wire reg1_lt_reg2;
wire[`reg_bus] opdata1_mult;
wire[`reg_bus] opdata2_mult;
wire[`double_reg_bus] hilo_tmp;
reg[`double_reg_bus] hilo_tmp1;
reg stallreq_for_madd_msub;
reg stallreq_for_div;

always@(*)begin
	if(rst == `rst_enable)begin
		logic_out <= `zero_word;
	end else begin
		case(aluop_i)
			`exe_or_op:begin
				logic_out <= reg1_i | reg2_i;
			end
			`exe_and_op:begin
				logic_out <= reg1_i & reg2_i;
			end
			`exe_nor_op:begin
				logic_out <= ~(reg1_i | reg2_i);
			end
			`exe_xor_op:begin
				logic_out <= reg1_i ^ reg2_i;
			end
			default:begin
				logic_out <= `zero_word;
			end
		endcase
	end
end

always@(*)begin
	if(rst == `rst_enable)begin
		shift_res <= `zero_word;
	end else begin
		case(aluop_i)
			`exe_sll_op:begin
				shift_res <= (reg2_i << reg1_i[4:0]);
			end
			`exe_srl_op:begin
				shift_res <= (reg2_i >> reg1_i[4:0]);
			end
			`exe_sra_op:begin
				shift_res <= ({32{reg2_i[31]}} << (6'd32-{1'b0, reg1_i[4:0]}))| reg2_i >> reg1_i[4:0];
			end
			default:begin
				shift_res <= `zero_word;
			end
		endcase
	end
end

assign reg2_i_mux = ((aluop_i == `exe_sub_op) || (aluop_i == `exe_subu_op) ||
					(aluop_i == `exe_slt_op))?(~reg2_i)+1:reg2_i;
assign result_sum = reg1_i + reg2_i_mux;
assign ov_sum = ((!reg1_i[31] && !reg2_i_mux[31]) && result_sum[31]) ||
				((reg1_i[31] && reg2_i_mux[31]) && (!result_sum[31])); 
assign reg1_lt_reg2 = ((aluop_i ==  `exe_slt_op))?
						((reg1_i[31] && !reg2_i[31]) || (!reg1_i[31] && !reg2_i[31] && result_sum[31])||
						(reg1_i[31] && reg2_i[31] && result_sum[31])) : (reg1_i < reg2_i);
assign reg1_i_not = ~reg1_i;

always@(*)begin
	if(rst == `rst_enable)begin
		{HI, LO} <= {`zero_word, `zero_word};
	end else if(mem_whilo_i == `write_enable)begin
		{HI, LO} <= {mem_hi_i, mem_lo_i};
	end else if(wb_whilo_i == `write_enable)begin
		{HI, LO} <= {wb_hi_i, wb_lo_i};
	end else begin
		{HI, LO} <= {hi_i, lo_i};
	end
end

always@(*)begin
	stallreq = stallreq_for_madd_msub || stallreq_for_div;
end

//MADD MADDU MSUB MSUBU
always@(*)begin
	if(rst == `rst_enable)begin
		hilo_tmp_o <= {`zero_word, `zero_word};
		cnt_o <= 2'b00;
		stallreq_for_madd_msub <= `no_stop;
	end else begin
		case(aluop_i)
			`exe_madd_op, `exe_maddu_op:begin
				if(cnt_i == 2'b00)begin
					hilo_tmp_o <= mul_res;
					cnt_o <= 2'b01;
					stallreq_for_madd_msub <= `stop;
					hilo_tmp1 <= {`zero_word, `zero_word};
				end else if(cnt_i == 2'b01)begin
					hilo_tmp_o <= {`zero_word, `zero_word};
					cnt_o <= 2'b10;
					hilo_tmp1 <= hilo_tmp_i+{HI, LO};
					stallreq_for_madd_msub <= `no_stop;
				end
			end
			`exe_msub_op, `exe_msubu_op:begin
				if(cnt_i == 2'b00)begin
					hilo_tmp_o <= ~mul_res+1;
					cnt_o <= 2'b01;
					stallreq_for_madd_msub <= `stop;
				end else if(cnt_i == 2'b01)begin
					hilo_tmp_o <= {`zero_word, `zero_word};
					cnt_o <= 2'b10;
					hilo_tmp1 <= hilo_tmp_i+{HI, LO};
					stallreq_for_madd_msub <= `no_stop;
				end
			end
			default:begin
				hilo_tmp_o <= {`zero_word, `zero_word};
				cnt_o <= 2'b00;
				stallreq_for_madd_msub <= `no_stop;
			end
		endcase
	end
end

//DIV DIVU
always@(*)begin
	if(rst == `rst_enable)begin
		stallreq_for_div <= `no_stop;
		div_opdata1_o <= `zero_word;
		div_opdata2_o <= `zero_word;
		div_start_o <= `div_stop;
		signed_div_o <= 1'b0;
	end else begin
		stallreq_for_div <= `no_stop;
		div_opdata1_o <= `zero_word;
		div_opdata2_o <= `zero_word;
		div_start_o <= `div_stop;
		signed_div_o <= 1'b0;
		case(aluop_i)
			`exe_div_op:begin
				if(div_ready_i == `div_result_not_ready)begin
					div_opdata1_o <= reg1_i;
					div_opdata2_o <= reg2_i;
					div_start_o <= `div_start;
					signed_div_o <= 1'b1;
					stallreq_for_div <= `stop;
				end else if(div_ready_i == `div_result_ready)begin
					div_opdata1_o <= reg1_i;
					div_opdata2_o <= reg2_i;
					div_start_o <= `div_stop;
					signed_div_o <= 1'b1;
					stallreq_for_div <= `no_stop;
				end else begin
					div_opdata1_o <= `zero_word;
					div_opdata2_o <= `zero_word;
					div_start_o <= `div_stop;
					signed_div_o <= 1'b0;
					stallreq_for_div <= `no_stop;
				end
			end
			`exe_divu_op:begin
				if(div_ready_i == `div_result_not_ready)begin
					div_opdata1_o <= reg1_i;
					div_opdata2_o <= reg2_i;
					div_start_o <= `div_start;
					signed_div_o <= 1'b0;
					stallreq_for_div <= `stop;
				end else if(div_ready_i == `div_result_ready)begin
					div_opdata1_o <= reg1_i;
					div_opdata2_o <= reg2_i;
					div_start_o <= `div_stop;
					signed_div_o <= 1'b0;
					stallreq_for_div <= `no_stop;
				end else begin
					div_opdata1_o <= `zero_word;
					div_opdata2_o <= `zero_word;
					div_start_o <= `div_stop;
					signed_div_o <= 1'b0;
					stallreq_for_div <= `no_stop;
				end
			end
			default:begin
			end
		endcase
	end
end

always@(*)begin
	if(rst == `rst_enable)begin
		arithmetic_res <= `zero_word;
	end else begin
		case(aluop_i)
			`exe_slt_op, `exe_sltu_op:begin
				arithmetic_res <= reg1_lt_reg2;
			end
			`exe_add_op, `exe_addu_op, `exe_addi_op, `exe_addiu_op:begin
				arithmetic_res <= result_sum;
			end
			`exe_sub_op, `exe_subu_op:begin
				arithmetic_res <= result_sum;
			end
			`exe_clz_op:begin
				arithmetic_res <= reg1_i[31]?0:reg1_i[30] ? 1 : reg1_i[29] ? 2 :
													 reg1_i[28] ? 3 : reg1_i[27] ? 4 : reg1_i[26] ? 5 :
													 reg1_i[25] ? 6 : reg1_i[24] ? 7 : reg1_i[23] ? 8 : 
													 reg1_i[22] ? 9 : reg1_i[21] ? 10 : reg1_i[20] ? 11 :
													 reg1_i[19] ? 12 : reg1_i[18] ? 13 : reg1_i[17] ? 14 : 
													 reg1_i[16] ? 15 : reg1_i[15] ? 16 : reg1_i[14] ? 17 : 
													 reg1_i[13] ? 18 : reg1_i[12] ? 19 : reg1_i[11] ? 20 :
													 reg1_i[10] ? 21 : reg1_i[9] ? 22 : reg1_i[8] ? 23 : 
													 reg1_i[7] ? 24 : reg1_i[6] ? 25 : reg1_i[5] ? 26 : 
													 reg1_i[4] ? 27 : reg1_i[3] ? 28 : reg1_i[2] ? 29 : 
													 reg1_i[1] ? 30 : reg1_i[0] ? 31 : 32 ;
			end
			`exe_clo_op:begin
				arithmetic_res <= (reg1_i_not[31] ? 0 : reg1_i_not[30] ? 1 : reg1_i_not[29] ? 2 :
													 reg1_i_not[28] ? 3 : reg1_i_not[27] ? 4 : reg1_i_not[26] ? 5 :
													 reg1_i_not[25] ? 6 : reg1_i_not[24] ? 7 : reg1_i_not[23] ? 8 : 
													 reg1_i_not[22] ? 9 : reg1_i_not[21] ? 10 : reg1_i_not[20] ? 11 :
													 reg1_i_not[19] ? 12 : reg1_i_not[18] ? 13 : reg1_i_not[17] ? 14 : 
													 reg1_i_not[16] ? 15 : reg1_i_not[15] ? 16 : reg1_i_not[14] ? 17 : 
													 reg1_i_not[13] ? 18 : reg1_i_not[12] ? 19 : reg1_i_not[11] ? 20 :
													 reg1_i_not[10] ? 21 : reg1_i_not[9] ? 22 : reg1_i_not[8] ? 23 : 
													 reg1_i_not[7] ? 24 : reg1_i_not[6] ? 25 : reg1_i_not[5] ? 26 : 
													 reg1_i_not[4] ? 27 : reg1_i_not[3] ? 28 : reg1_i_not[2] ? 29 : 
													 reg1_i_not[1] ? 30 : reg1_i_not[0] ? 31 : 32) ;
			end
			default:begin
				arithmetic_res <= `zero_word;
			end
		endcase
	end
end

assign opdata1_mult = (((aluop_i == `exe_mul_op) || (aluop_i == `exe_mult_op)
						|| (aluop_i == `exe_madd_op) || (aluop_i == `exe_msub_op)) && (reg1_i[31] == 1'b1)?(~reg1_i+1):reg1_i);
assign opdata2_mult = (((aluop_i == `exe_mul_op) || (aluop_i == `exe_mult_op)
						|| (aluop_i == `exe_madd_op) || (aluop_i == `exe_msub_op)) && (reg2_i[31] == 1'b1)?(~reg2_i+1):reg2_i);
assign hilo_tmp = opdata1_mult*opdata2_mult;

always@(*)begin
	if(rst == `rst_enable)begin
		mul_res <= {`zero_word, `zero_word};
	end else if((aluop_i == `exe_mult_op) || (aluop_i == `exe_mul_op) ||
				(aluop_i == `exe_madd_op) || (aluop_i == `exe_msub_op))begin
		if(reg1_i[31]^reg2_i[31] == 1'b1)begin
			mul_res <= ~hilo_tmp+1;
		end else begin
			mul_res <= hilo_tmp;
		end
	end else begin
		mul_res <= hilo_tmp;
	end
end

always@(*)begin
	if(rst == `rst_enable)begin
		move_res <= `zero_word;
	end else begin
		move_res <= `zero_word;
		case(aluop_i)
			`exe_mfhi_op:begin
				move_res <= HI;
			end
			`exe_mflo_op:begin
				move_res <= LO;
			end
			`exe_movz_op:begin
				move_res <= reg1_i;
			end
			`exe_movn_op:begin
				move_res <= reg1_i;
			end
			default:begin
			end
		endcase
	end
end

always@(*)begin
	if(rst == `rst_enable)begin
		whilo_o <= `write_disable;
		hi_o <= `zero_word;
		lo_o <= `zero_word;
	end else if((aluop_i == `exe_mult_op) || (aluop_i == `exe_multu_op))begin
		whilo_o <= `write_enable;
		hi_o <= mul_res[63:32];
		lo_o <= mul_res[31:0];
	end else if((aluop_i == `exe_madd_op) || (aluop_i == `exe_maddu_op))begin
		whilo_o <= `write_enable;
		hi_o <= hilo_tmp1[63:32];
		lo_o <= hilo_tmp1[31:0];
	end else if((aluop_i == `exe_msub_op) || (aluop_i == `exe_msubu_op))begin
		whilo_o <= `write_enable;
		hi_o <= hilo_tmp1[63:32];
		lo_o <= hilo_tmp1[31:0];
	end else if((aluop_i == `exe_div_op) || (aluop_i == `exe_divu_op))begin
		whilo_o <= `write_enable;
		hi_o <= div_result_i[63:32];
		lo_o <= div_result_i[31:0];
	end else if(aluop_i == `exe_mthi_op)begin
		whilo_o <= `write_enable;
		hi_o <= reg1_i;
		lo_o <= LO;
	end else if(aluop_i == `exe_mtlo_op)begin
		whilo_o <= `write_enable;
		hi_o <= HI;
		lo_o <= reg1_i;
	end else begin
		whilo_o <= `write_disable;
		hi_o <= `zero_word;
		lo_o <= `zero_word;
	end
end

always@(*)begin
	wd_o <= wd_i;
	if(((aluop_i == `exe_add_op) || (aluop_i == `exe_addi_op) ||
	   (aluop_i == `exe_sub_op)) && (ov_sum == 1'b1))begin
	   wreg_o <= `write_disable;
	end else begin
	   wreg_o <= wreg_i;
	end
	case(alusel_i)
		`exe_res_logic:begin
			wdata_o <= logic_out;
		end
		`exe_res_shift:begin
			wdata_o <= shift_res;
		end
		`exe_res_move:begin
			wdata_o <= move_res;
		end
		`exe_res_arithmetic:begin
			wdata_o <= arithmetic_res;
		end
		`exe_res_mul:begin
			wdata_o <= mul_res[31:0];
		end
		`exe_res_jump_branch:begin
			wdata_o <= link_address_i;
		end
		default:begin
			wdata_o <= `zero_word;
		end
	endcase
end

endmodule