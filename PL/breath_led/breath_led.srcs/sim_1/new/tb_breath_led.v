`timescale 1ns / 1ps

module tb_breath_led();

reg sys_clk;
reg sys_rst_n;

wire led;

breath_led u_breath_led(
	.sys_clk 	(sys_clk),
	.sys_rst_n 	(sys_rst_n),
	.led		(led)
);

initial begin
	sys_clk = 1'b0;
	sys_rst_n = 1'b0;
	#60 sys_rst_n = 1'b1;
end

always #10 sys_clk=~sys_clk;

endmodule
