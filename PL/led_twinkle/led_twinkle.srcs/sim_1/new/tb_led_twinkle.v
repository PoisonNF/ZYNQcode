`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/16 13:46:28
// Design Name: 
// Module Name: tb_led_twinkle
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


module tb_led_twinkle();

reg sys_clk;
reg sys_rst_n;

wire [1:0] led;

initial begin
	sys_clk = 1'b0;
	sys_rst_n = 1'b0;
	#200
	sys_rst_n = 1'b1;
end

always #10 sys_clk = ~sys_clk;

led_twinkle u_led_twinkle(
	.sys_clk  	 (sys_clk),
	.sys_rst_n   (sys_rst_n),
	
	.led         (led)
);

endmodule
