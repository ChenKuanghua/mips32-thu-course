`include "defines.v"

module mem(
	input wire rst,

	input wire[`reg_addr_bus] wd_i,
	input wire wreg_i,
	input wire[`reg_bus] wdata_i,
	input wire[`reg_bus] hi_i,
	input wire[`reg_bus] lo_i,
	input wire whilo_i,

	input wire[`alu_op_bus] aluop_i,
	input wire[`reg_bus] mem_addr_i,
	input wire[`reg_bus] reg2_i,

	input wire[`reg_bus] mem_data_i,

	output reg[`reg_addr_bus] wd_o,
	output reg wreg_o,
	output reg[`reg_bus] wdata_o,
	output reg[`reg_bus] hi_o,
	output reg[`reg_bus] lo_o,
	output reg whilo_o,

	output reg[`reg_bus] mem_addr_o,
	output wire mem_we_o,
	output reg[3:0] mem_sel_o,
	output reg[`reg_bus] mem_data_o,
	output reg mem_ce_o
);

wire[`reg_bus] zero32;
reg mem_we;

assign mem_we_o = mem_we;
assign zero32 = `zero_word;

always@(*)begin
	if(rst == `rst_enable)begin
		wd_o <= `nop_reg_addr;
		wreg_o <= `write_disable;
		wdata_o <= `zero_word;
		hi_o <= `zero_word;
		lo_o <= `zero_word;
		whilo_o <= `write_disable;
		mem_addr_o <= `zero_word;
		mem_we <= `write_disable;
		mem_sel_o <= 4'b0000;
		mem_data_o <= `zero_word;
		mem_ce_o <= `chip_disable;
	end else begin
		wd_o <= wd_i;
		wreg_o <= wreg_i;
		wdata_o <= wdata_i;
		hi_o <= hi_i;
		lo_o <= lo_i;
		whilo_o <= whilo_i;
		mem_we <= `write_disable;
		mem_addr_o <= `zero_word;
		mem_sel_o <= 4'b1111;
		mem_ce_o <= `chip_disable;
		case(aluop_i)
			`exe_lb_op:begin
				mem_addr_o <= mem_addr_i;
				mem_we <= `write_disable;
				mem_ce_o <= `chip_enable;
				case(mem_addr_i[1:0])
					2'b00:begin
						wdata_o <= {{24{mem_data_o[31]}}, mem_data_i[31:24]};
						mem_sel_o <= 4'b1000;
					end
					2'b01:begin
						wdata_o <= {{24{mem_data_i[23]}}, mem_data_i[23:16]};
						mem_sel_o <= 4'b0100;
					end
					2'b10:begin
						wdata_o <= {{24{mem_data_i[15]}}, mem_data_i[15:8]};
						mem_sel_o <= 4'b0010;
					end
					2'b11:begin
						wdata_o <= {{24{mem_data_i[7]}}, mem_data_i[7:0]};
					end
					default:begin
						wdata_o <= `zero_word;
					end
				endcase
			end
			`exe_lbu_op:begin
				mem_addr_o <= mem_addr_i;
				mem_we <= `write_disable;
				mem_ce_o <= `chip_enable;
				case(mem_addr_i[1:0])
					2'b00:begin
						wdata_o <= {{24{1'b0}}, mem_data_i[31:24]};
						mem_sel_o <= 4'b1000;
					end
					2'b01:begin
						wdata_o <= {{24{1'b0}}, mem_data_i[23:16]};
						mem_sel_o <= 4'b0100;
					end
					2'b10:begin
						wdata_o <= {{24{1'b0}}, mem_data_i[15:8]};
						mem_sel_o <= 4'b0010;
					end
					2'b11:begin
						wdata_o <= {{24{1'b0}}, mem_data_i[7:0]};
						mem_sel_o <= 4'b0001;
					end
					default:begin
						wdata_o <= `zero_word;
					end
				endcase
			end
			`exe_lh_op:begin
				mem_addr_o <= mem_addr_i;
				mem_we <= `write_disable;
				mem_ce_o <= `chip_enable;
				case(mem_addr_i[1:0])
					2'b00:begin
						wdata_o <= {{16{mem_data_i[31]}}, mem_data_i[31:16]};
						mem_sel_o <= 4'b1100;
					end
					2'b10:begin
						wdata_o <= {{16{mem_data_i[15]}}, mem_data_i[15:0]};
						mem_sel_o <= 4'b0011;
					end
					default:begin
						wdata_o <= `zero_word;
					end
				endcase
			end
			`exe_lhu_op:begin
				mem_addr_o <= mem_addr_i;
				mem_we <= `write_disable;
				mem_ce_o <= `chip_enable;
				case(mem_addr_i[1:0])
					2'b00:begin
						wdata_o <= {{16{1'b0}}, mem_data_i[31:16]};
						mem_sel_o <= 4'b1100;
					end
					2'b10:begin
						wdata_o <= {{16{1'b0}}, mem_data_i[15:0]};
						mem_sel_o <= 4'b0011;
					end
					default:begin
						wdata_o <= `zero_word;
					end
				endcase
			end
			`exe_lw_op:begin
				mem_addr_o <= mem_addr_i;
				mem_we <= `write_disable;
				wdata_o <= mem_data_i;
				mem_sel_o <= 4'b1111;
				mem_ce_o <= `chip_enable;
			end
			`exe_lwl_op:begin
				mem_addr_o <= {mem_addr_i[31:2], 2'b00};
				mem_we <= `write_disable;
				mem_sel_o <= 4'b1111;
				mem_ce_o <= `chip_enable;
				case(mem_addr_i[1:0])
					2'b00:begin
						wdata_o <= mem_data_i[31:0];
					end
					2'b01:begin
						wdata_o <= {mem_data_i[23:0], reg2_i[7:0]};
					end
					2'b10:begin
						wdata_o <= {mem_data_i[15:0], reg2_i[15:0]};
					end
					2'b11:begin
						wdata_o <= {mem_data_i[7:0], reg2_i[23:0]};
					end
					default:begin
						wdata_o <= `zero_word;
					end
				endcase
			end
			`exe_lwr_op:begin
				mem_addr_o <= {mem_addr_i[31:2], 2'b00};
				mem_we <= `write_disable;
				mem_sel_o <= 4'b1111;
				mem_ce_o <= `chip_enable;
				case(mem_addr_i[1:0])
					2'b00:begin
						wdata_o <= {reg2_i[31:8], mem_data_i[31:24]};
					end
					2'b01:begin
						wdata_o <= {reg2_i[31:16], mem_data_i[31:16]};
					end
					2'b10:begin
						wdata_o <= {reg2_i[31:24], mem_data_i[31:8]};
					end
					2'b11:begin
						wdata_o <= mem_data_i;
					end
					default:begin
						wdata_o <= `zero_word;
					end
				endcase
			end
			`exe_sb_op:begin
				mem_addr_o <= mem_addr_i;
				mem_we <= `write_enable;
				mem_data_o <= {reg2_i[7:0], reg2_i[7:0], reg2_i[7:0], reg2_i[7:0]};
				mem_ce_o <= `chip_enable;
				case(mem_addr_i[1:0])
					2'b00:begin
						mem_sel_o <= 4'b1000;
					end
					2'b01:begin
						mem_sel_o <= 4'b0100;
					end
					2'b10:begin
						mem_sel_o <= 4'b0010;
					end
					2'b11:begin
						mem_sel_o <= 4'b0001;
					end
					default:begin
						mem_sel_o <= 4'b0000;
					end
				endcase
			end
			`exe_sh_op:begin
				mem_addr_o <= mem_addr_i;
				mem_we <= `write_enable;
				mem_data_o <= {reg2_i[15:0], reg2_i[15:0]};
				mem_ce_o <= `chip_enable;
				case(mem_addr_i[1:0])
					2'b00:begin
						mem_sel_o <= 4'b1100;
					end
					2'b10:begin
						mem_sel_o <= 4'b0011;
					end
					default:begin
						mem_sel_o <= 4'b0000;
					end
				endcase
			end
			`exe_sw_op:begin
				mem_addr_o <= mem_addr_i;
				mem_we <= `write_enable;
				mem_data_o <= reg2_i;
				mem_sel_o <= 4'b1111;
				mem_ce_o <= `chip_enable;
			end
			`exe_swl_op:begin
				mem_addr_o <= {mem_addr_i[31:2], 2'b00};
				mem_we <= `write_enable;
				mem_ce_o <= `chip_enable;
				case(mem_addr_i[1:0])
					2'b00:begin
						mem_sel_o <= 4'b1111;
						mem_data_o <= reg2_i;
					end
					2'b01:begin
						mem_sel_o <= 4'b0111;
						mem_data_o <= {zero32[7:0], reg2_i[31:8]};
					end
					2'b10:begin
						mem_sel_o <= 4'b0011;
						mem_data_o <= {zero32[15:0], reg2_i[31:16]};
					end
					2'b11:begin
						mem_sel_o <= 4'b0001;
						mem_data_o <= {zero32[23:0], reg2_i[31:24]};
					end
					default:begin
						mem_sel_o <= 4'b0000;
					end
				endcase
			end
			`exe_swr_op:begin
				mem_addr_o <= {mem_addr_i[31:2], 2'b00};
				mem_we <= `write_enable;
				mem_ce_o <= `chip_enable;
				case(mem_addr_i[1:0])
					2'b00:begin
						mem_sel_o <= 4'b1000;
						mem_data_o <= {reg2_i[7:0], zero32[23:0]};
					end
					2'b01:begin
						mem_sel_o <= 4'b1100;
						mem_data_o <= {reg2_i[15:0], zero32[15:0]};
					end
					2'b10:begin
						mem_sel_o <= 4'b1110;
						mem_data_o <= {reg2_i[23:0], zero32[7:0]};
					end
					2'b11:begin
						mem_sel_o <= 4'b1111;
						mem_data_o <= reg2_i[31:0];
					end
					default:begin
						mem_sel_o <= 4'b0000;
					end
				endcase
			end
			default:begin
			end
		endcase
	end
end

endmodule