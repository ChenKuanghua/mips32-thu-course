`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/22 00:43:57
// Design Name: 
// Module Name: top_min_spoc_tb
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


module top_min_spoc_tb();
reg CLOCK_50;
reg rst;
initial begin
    CLOCK_50 = 1'b0;
    forever #10 CLOCK_50 = ~CLOCK_50;
end

initial begin
    rst = 1'b1;
    #195 rst = 1'b0;
    #3000 $stop;
end

top_min_spoc top_min_spoc0(
    .clk(CLOCK_50),
    .rst(rst)
);
endmodule
