//enable
`define rst_enable 1'b1
`define rst_disable 1'b0
`define zero_word {32{1'b0}}
`define write_enable 1'b1
`define write_disable 1'b0
`define read_enable 1'b1
`define read_disable 1'b0
`define alu_op_bus 7:0
`define alu_sel_bus 2:0
`define inst_valid 1'b0
`define inst_invaild 1'b1
`define stop 1'b1
`define no_stop 1'b0
`define in_delay_slot 1'b1
`define not_in_delay_slot 1'b0
`define branch 1'b1
`define not_branch 1'b0
`define interrupt_assert 1'b1
`define interrupt_not_assert 1'b0
`define trap_assert 1'b1
`define trap_not_assert 1'b0
`define true_v 1'b1
`define false_v 1'b0
`define chip_enable 1'b1
`define chip_disable 1'b0

//op_code
`define exe_ori 6'b001101
`define exe_nop 6'b000000

//alu_op
`define exe_or_op 8'b00100101
`define exe_ori_op 8'b01011010
`define exe_nop_op 8'b00000000

//alu_sel
`define exe_res_logic 3'b001
`define exe_res_nop 3'b000

//length
`define inst_addr_bus 31:0
`define inst_bus 31:0
`define inst_mem_num 131071
`define inst_mem_num_log2 17
`define reg_addr_bus 4:0
`define reg_bus 31:0
`define reg_width 32
`define double_reg_width 64
`define double_reg_bus 63:0
`define reg_num 32
`define reg_num_log2 5
`define nop_reg_addr 5'b00000