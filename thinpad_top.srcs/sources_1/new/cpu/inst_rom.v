`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/22 00:34:33
// Design Name: 
// Module Name: inst_rom
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "defines.v"

module inst_rom(
    input wire ce,
    input wire[`inst_addr_bus] addr,
    output reg[`inst_bus] inst
);
//reg[`inst_bus] inst_mem[0:`inst_mem_num-1];
reg[`inst_bus] inst_mem[0:8];
initial $readmemh("C:/Users/andy/Desktop/inst_rom.data", inst_mem);

always@(*)begin
    if(ce == `chip_disable)begin
        inst <= `zero_word;
    end else begin
        inst <= inst_mem[addr[`inst_mem_num_log2+1:2]];
    end
end

endmodule
