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
`define exe_and 6'b100100
`define exe_or  6'b100101
`define exe_xor 6'b100110
`define exe_nor 6'b100111
`define exe_andi 6'b001100
`define exe_xori 6'b001110
`define exe_lui 6'b001111
`define exe_ori 6'b001101

`define exe_sll 6'b000000
`define exe_sllv 6'b000100
`define exe_srl 6'b000010
`define exe_srlv 6'b000110
`define exe_sra 6'b000011
`define exe_srav 6'b000111
`define exe_sync 6'b001111
`define exe_pref 6'b110011

`define exe_movz 6'b001010
`define exe_movn 6'b001011
`define exe_mfhi 6'b010000
`define exe_mthi 6'b010001
`define exe_mflo 6'b010010
`define exe_mtlo 6'b010011

`define exe_slt 6'b101010 
`define exe_sltu 6'b101011
`define exe_slti 6'b001010 
`define exe_sltiu 6'b001011 
`define exe_add 6'b100000 
`define exe_addu 6'b100001 
`define exe_sub 6'b100010 
`define exe_subu 6'b100011 
`define exe_addi 6'b001000 
`define exe_addiu 6'b001001 
`define exe_clz 6'b100000 
`define exe_clo 6'b100001 

`define exe_mult 6'b011000 
`define exe_multu 6'b011001 
`define exe_mul 6'b000010 

`define exe_nop 6'b000000
`define ssnop 32'b00000000000000000000000001000000

`define exe_special_inst 6'b000000
`define exe_regimm_inst 6'b000001
`define exe_special2_inst 6'b011100

//alu_op
`define exe_and_op 8'b00100100
`define exe_or_op 8'b00100101
`define exe_xor_op 8'b00100110
`define exe_nor_op 8'b00100111
`define exe_andi_op 8'b01011001
`define exe_ori_op 8'b01011010
`define exe_xori_op 8'b01011011
`define exe_lui_op 8'b01011100

`define exe_sll_op 8'b01111100
`define exe_sllv_op 8'b00000100
`define exe_srl_op 8'b00000010
`define exe_srlv_op 8'b00000110
`define exe_sra_op 8'b00000011
`define exe_srav_op 8'b00000111

`define exe_movz_op 8'b00001010
`define exe_movn_op 8'b00001011 
`define exe_mfhi_op 8'b00010000 
`define exe_mthi_op 8'b00010001 
`define exe_mflo_op 8'b00010010 
`define exe_mtlo_op 8'b00010011 

`define exe_slt_op 8'b00001010 
`define exe_sltu_op 8'b00101011 
`define exe_slti_op 8'b01010111 
`define exe_sltiu_op 8'b01011000 
`define exe_add_op 8'b00100000 
`define exe_addu_op 8'b00100001 
`define exe_sub_op 8'b00100010
`define exe_subu_op 8'b00100011 
`define exe_addi_op 8'b01010101 
`define exe_addiu_op 8'b01010110 
`define exe_clz_op 8'b10110000 
`define exe_clo_op 8'b10110001 

`define exe_mult_op 8'b00011000
`define exe_multu_op 8'b00011001
`define exe_mul_op 8'b10101001

`define exe_nop_op 8'b00000000

//alu_sel
`define exe_res_logic 3'b001
`define exe_res_shift 3'b010
`define exe_res_move 3'b011
`define exe_res_arithmetic 3'b100 
`define exe_res_mul 3'b101

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