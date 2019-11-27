`include "defines.v"

module top(
	input wire clk,
	input wire rst,

	input wire[`reg_bus] rom_data_i,
	input wire[`reg_bus] rom_addr_o,
	output wire rom_ce_o,

	input wire[`reg_bus] ram_data_i,
	output wire[`reg_bus] ram_addr_o,
	output wire[`reg_bus] ram_data_o,
	output wire ram_we_o,
	output wire[3:0] ram_sel_o,
	output wire[3:0] ram_ce_o
);

wire[`inst_addr_bus] pc;
wire[`inst_addr_bus] id_pc_i;
wire[`inst_bus] id_inst_i;

wire[`alu_op_bus] id_aluop_o;
wire[`alu_sel_bus] id_alusel_o;
wire[`reg_bus] id_reg1_o;
wire[`reg_bus] id_reg2_o;
wire id_wreg_o;
wire[`reg_addr_bus] id_wd_o;
wire id_is_in_delayslot_o;
wire[`reg_bus] id_link_address_o;
wire[`reg_bus] id_inst_o;

wire[`alu_op_bus] ex_aluop_i;
wire[`alu_sel_bus] ex_alusel_i;
wire[`reg_bus] ex_reg1_i;
wire[`reg_bus] ex_reg2_i;
wire ex_wreg_i;
wire[`reg_addr_bus] ex_wd_i;
wire ex_is_in_delayslot_i;
wire[`reg_bus] ex_link_address_i;
wire[`reg_bus] ex_inst_i;

wire ex_wreg_o;
wire[`reg_addr_bus] ex_wd_o;
wire[`reg_bus] ex_wdata_o;
wire[`reg_bus] ex_hi_o;
wire[`reg_bus] ex_lo_o;
wire ex_whilo_o;
wire[`alu_op_bus] ex_aluop_o;
wire[`reg_bus] ex_mem_addr_o;
wire[`reg_bus] ex_reg1_o;
wire[`reg_bus] ex_reg2_o;

wire mem_wreg_i;
wire[`reg_addr_bus] mem_wd_i;
wire[`reg_bus] mem_wdata_i;
wire[`reg_bus] mem_hi_i;
wire[`reg_bus] mem_lo_i;
wire mem_whilo_i;
wire[`alu_op_bus] mem_aluop_i;
wire[`reg_bus] mem_mem_addr_i;
wire[`reg_bus] mem_reg1_i;
wire[`reg_bus] mem_reg2_i;

wire mem_wreg_o;
wire[`reg_addr_bus] mem_wd_o;
wire[`reg_bus] mem_wdata_o;
wire[`reg_bus] mem_hi_o;
wire[`reg_bus] mem_lo_o;
wire mem_whilo_o;

wire wb_wreg_i;
wire[`reg_addr_bus] wb_wd_i;
wire[`reg_bus] wb_wdata_i;
wire[`reg_bus] wb_hi_i;
wire[`reg_bus] wb_lo_i;
wire wb_whilo_i;

wire reg1_read;
wire reg2_read;
wire[`reg_bus] reg1_data;
wire[`reg_bus] reg2_data;
wire[`reg_addr_bus] reg1_addr;
wire[`reg_addr_bus] reg2_addr;

wire[`reg_bus] hi;
wire[`reg_bus] lo;

wire[`double_reg_bus] hilo_tmp_o;
wire[1:0] cnt_o;

wire[`double_reg_bus] hilo_tmp_i;
wire[1:0] cnt_i;

wire[`double_reg_bus] div_result;
wire div_ready;
wire[`reg_bus] div_opdata1;
wire[`reg_bus] div_opdata2;
wire div_start;
wire div_annul;
wire signed_div;

wire is_in_delayslot_i;
wire is_in_delayslot_o;
wire next_inst_in_delayslot_o;
wire id_branch_flag_o;
wire[`reg_bus] branch_target_address;

wire[5:0] stall;
wire stallreq_from_id;
wire stallreq_from_ex;

pc_reg pc_reg0(
	.clk(clk),
	.rst(rst),
	.stall(stall),
	.branch_flag_i(id_branch_flag_o),
	.branch_target_address_i(branch_target_address),
	.pc(pc),
	.ce(rom_ce_o)
);

assign rom_addr_o = pc;

if_id if_id0(
	.clk(clk),
	.rst(rst),
	.stall(stall),
	.if_pc(pc),
	.if_inst(rom_data_i),
	.id_pc(id_pc_i),
	.id_inst(id_inst_i)
);

id id0(
	.rst(rst),
	.pc_i(id_pc_i),
	.inst_i(id_inst_i),

	.ex_aluop_i(ex_aluop_o),

	.reg1_data_i(reg1_data),
	.reg2_data_i(reg2_data),

	.ex_wreg_i(ex_wreg_o),
	.ex_wdata_i(ex_wdata_o),
	.ex_wd_i(ex_wd_o),

	.mem_wreg_i(mem_wreg_o),
	.mem_wdata_i(mem_wdata_o),
	.mem_wd_i(mem_wd_o),

	.is_in_delayslot_i(is_in_delayslot_i),

	.reg1_read_o(reg1_read),
	.reg2_read_o(reg2_read),
	
	.reg1_addr_o(reg1_addr),
	.reg2_addr_o(reg2_addr),

	.aluop_o(id_aluop_o),
	.alusel_o(id_alusel_o),
	.reg1_o(id_reg1_o),
	.reg2_o(id_reg2_o),
	.wd_o(id_wd_o),
	.wreg_o(id_wreg_o),
	.inst_o(id_inst_o),

	.next_inst_in_delayslot_o(next_inst_in_delayslot_o),
	.branch_flag_o(id_branch_flag_o),
	.branch_target_address_o(branch_target_address),
	.link_addr_o(id_link_address_o),

	.is_in_delayslot_o(id_is_in_delayslot_o),

	.stallreq(stallreq_from_id)
);

regfile regfile1(
	.clk(clk),
	.rst(rst),
	.we(wb_wreg_i),
	.waddr(wb_wd_i),
	.wdata(wb_wdata_i),
	.re1(reg1_read),
	.raddr1(reg1_addr),
	.rdata1(reg1_data),
	.re2(reg2_read),
	.raddr2(reg2_addr),
	.rdata2(reg2_data)
);

id_ex id_ex0(
	.clk(clk),
	.rst(rst),

	.stall(stall),

	.id_aluop(id_aluop_o),
	.id_alusel(id_alusel_o),
	.id_reg1(id_reg1_o),
	.id_reg2(id_reg2_o),
	.id_wd(id_wd_o),
	.id_wreg(id_wreg_o),
	.id_link_address(id_link_address_o),
	.id_is_in_delayslot(id_is_in_delayslot_o),
	.next_inst_in_delayslot_i(next_inst_in_delayslot_o),
	.id_inst(id_inst_o),

	.ex_aluop(ex_aluop_i),
	.ex_alusel(ex_alusel_i),
	.ex_reg1(ex_reg1_i),
	.ex_reg2(ex_reg2_i),
	.ex_wd(ex_wd_i),
	.ex_wreg(ex_wreg_i),
	.ex_link_address(ex_link_address_i),
	.ex_is_in_delayslot(ex_is_in_delayslot_i),
	.is_in_delayslot_o(is_in_delayslot_i),
	.ex_inst(ex_inst_i)
);

ex ex0(
	.rst(rst),

	.aluop_i(ex_aluop_i),
	.alusel_i(ex_alusel_i),
	.reg1_i(ex_reg1_i),
	.reg2_i(ex_reg2_i),
	.wd_i(ex_wd_i),
	.wreg_i(ex_wreg_i),
	.hi_i(hi),
	.lo_i(lo),
	.inst_i(ex_inst_i),

	.wb_hi_i(wb_hi_i),
	.wb_lo_i(wb_lo_i),
	.wb_whilo_i(wb_whilo_i),
	.mem_hi_i(mem_hi_o),
	.mem_lo_i(mem_lo_o),
	.mem_whilo_i(mem_whilo_o),

	.hilo_tmp_i(hilo_tmp_i),
	.cnt_i(cnt_i),

	.div_result_i(div_result),
	.div_ready_i(div_ready),

	.link_address_i(ex_link_address_i),
	.is_in_delayslot_i(ex_is_in_delayslot_i),

	.wd_o(ex_wd_o),
	.wreg_o(ex_wreg_o),
	.wdata_o(ex_wdata_o),

	.hi_o(ex_hi_o),
	.lo_o(ex_lo_o),
	.whilo_o(ex_whilo_o),

	.hilo_tmp_o(hilo_tmp_o),
	.cnt_o(cnt_o),

	.div_opdata1_o(div_opdata1),
	.div_opdata2_o(div_opdata2),
	.div_start_o(div_start),
	.signed_div_o(signed_div),

	.aluop_o(ex_aluop_o),
	.mem_addr_o(ex_mem_addr_o),
	.reg2_o(ex_reg2_o),

	.stallreq(stallreq_from_ex)
);

ex_mem ex_mem0(
	.clk(clk),
	.rst(rst),

	.stall(stall),

	.ex_wd(ex_wd_o),
	.ex_wreg(ex_wreg_o),
	.ex_wdata(ex_wdata_o),
	.ex_hi(ex_hi_o),
	.ex_lo(ex_lo_o),
	.ex_whilo(ex_whilo_o),

	.ex_aluop(ex_aluop_o),
	.ex_mem_addr(ex_mem_addr_o),
	.ex_reg2(ex_reg2_o),

	.hilo_i(hilo_tmp_o),
	.cnt_i(cnt_o),

	.mem_wd(mem_wd_i),
	.mem_wreg(mem_wreg_i),
	.mem_wdata(mem_wdata_i),
	.mem_hi(mem_hi_i),
	.mem_lo(mem_lo_i),
	.mem_whilo(mem_whilo_i),

	.mem_aluop(mem_aluop_i),
	.mem_mem_addr(mem_mem_addr_i),
	.mem_reg2(mem_reg2_i),

	.hilo_o(hilo_tmp_i),
	.cnt_o(cnt_i)
);

mem mem0(
	.rst(rst),

	.wd_i(mem_wd_i),
	.wreg_i(mem_wreg_i),
	.wdata_i(mem_wdata_i),
	.hi_i(mem_hi_i),
	.lo_i(mem_lo_i),
	.whilo_i(mem_whilo_i),

	.aluop_i(mem_aluop_i),
	.mem_addr_i(mem_mem_addr_i),
	.reg2_i(mem_reg2_i),

	.mem_data_i(ram_data_i),

	.wd_o(mem_wd_o),
	.wreg_o(mem_wreg_o),
	.wdata_o(mem_wdata_o),
	.hi_o(mem_hi_o),
	.lo_o(mem_lo_o),
	.whilo_o(mem_whilo_o),
	
	.mem_addr_o(ram_addr_o),
	.mem_we_o(ram_we_o),
	.mem_sel_o(ram_sel_o),
	.mem_data_o(ram_data_o),
	.mem_ce_o(ram_ce_o)
);

mem_wb mem_wb0(
	.clk(clk),
	.rst(rst),

	.stall(stall),

	.mem_wd(mem_wd_o),
	.mem_wreg(mem_wreg_o),
	.mem_wdata(mem_wdata_o),
	.mem_hi(mem_hi_o),
	.mem_lo(mem_lo_o),
	.mem_whilo(mem_whilo_o),

	.wb_wd(wb_wd_i),
	.wb_wreg(wb_wreg_i),
	.wb_wdata(wb_wdata_i),
	.wb_hi(wb_hi_i),
	.wb_lo(wb_lo_i),
	.wb_whilo(wb_whilo_i)
);

hilo_reg hilo_reg0(
	.clk(clk),
	.rst(rst),

	.we(wb_whilo_i),
	.hi_i(wb_hi_i),
	.lo_i(wb_lo_i),

	.hi_o(hi),
	.lo_o(lo)
);

ctrl ctrl0(
	.rst(rst),

	.stallreq_from_id(stallreq_from_id),

	.stallreq_from_ex(stallreq_from_ex),

	.stall(stall)
);

div div0(
	.clk(clk),
	.rst(rst),

	.signed_div_i(signed_div),
	.opdata1_i(div_opdata1),
	.opdata2_i(div_opdata2),
	.start_i(div_start),
	.annul_i(1'b0),

	.result_o(div_result),
	.ready_o(div_ready)
);

endmodule




















