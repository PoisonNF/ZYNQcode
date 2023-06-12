`timescale 1ns / 1ps

module top_key_beep(
	input sys_clk,
	input sys_rst_n,
	
	input key,
	output beep
);

wire key_value;
wire key_flag;

key_judge u_key_judge(
	.sys_clk    (sys_clk),
	.sys_rst_n  (sys_rst_n),
      
	.key        (key),
	.key_value  (key_value),
	.key_flag    (key_flag)
);

key_control u_key_control(
	.sys_clk		(sys_clk),
	.sys_rst_n      (sys_rst_n),

	.key_value      (key_value),
	.key_flag       (key_flag),
	.beep           (beep)
);
    
endmodule

