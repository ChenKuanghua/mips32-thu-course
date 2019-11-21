`include "defines.v"

module ex(
	input wire rst,

	input wire[`alu_op_bus] aluop_i,
	input wire[`alu_sel_bus] alusel_i,
	input wire[`reg_bus] reg1_i,
	input wire[`reg_bus] reg2_i,
	input wire[`reg_addr_bus] wd_i,
	input wire wreg_i,

	output reg[`reg_addr_bus] wd_o,
	output reg wreg_o,
	output reg[`reg_bus] wdata_o
);

reg[`reg_bus] logic_out;

always@(*)begin
	if(rst == `rst_enable)begin
		logic_out <= `zero_word;
	end else begin
		case(aluop_i)
			`exe_or_op:begin
				logic_out <= reg1_i | reg2_i;
			end
			default:begin
				logic_out <= `zero_word;
			end
		endcase
	end
end

always@(*)begin
	wd_o <= wd_i;
	wreg_o <= wreg_i;
	case(alusel_i)
		`exe_res_logic:begin
			wdata_o <= logic_out;
		end
		default:begin
			wdata_o <= `zero_word;
		end
	endcase
end

endmodule