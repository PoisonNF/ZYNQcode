`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/23 17:17:47
// Design Name: 
// Module Name: key_control
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


module key_control(
    input      sys_clk,
    input      sys_rst_n,

    input      key_value,
    input      key_flag,
    output reg beep

    );

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        beep <= 1'b0;   //ÉÏµç²»Ïì
    else if(key_flag & key_value == 0)
        beep = ~ beep;
    else
        beep = beep;
end
endmodule
