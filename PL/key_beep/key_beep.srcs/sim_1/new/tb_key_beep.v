`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/23 20:44:07
// Design Name: 
// Module Name: tb_key_beep
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


module tb_key_beep();

reg sys_clk;
reg sys_rst_n;
reg key;

wire beep; 

top_key_beep u_top_key_beep(
	.sys_clk 	(sys_clk),
	.sys_rst_n 	(sys_rst_n),
	.key		(key),
	.beep		(beep)
);

initial begin
	sys_clk = 1'b0;
	sys_rst_n = 1'b0;
	key = 1'b1;
	
	#60 sys_rst_n = 1'b1;
	#40 key = 1'b0;
	#100 key = 1'b1;
	#40 key = 1'b0;
	#100 key = 1'b1;
	#40 key = 1'b0;
	#100 key = 1'b1;
	
	key = 1'b1;
	
	# 200 key = 1'b0;
end

always #10 sys_clk=~sys_clk;

endmodule
