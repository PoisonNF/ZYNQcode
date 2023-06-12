`timescale 1ns / 1ps

module tb_cymometer();

reg sys_clk;
reg sys_rst_n;
reg clk_fx;

wire uart_txd;
wire clk_out;

cymometer_top u_cymometer_top(

    .sys_clk          (sys_clk),
    .sys_rst_n        (sys_rst_n),

    .clk_fx           (clk_fx),
    .clk_out          (clk_out),

    .uart_txd         (uart_txd)
 );
 
 initial begin
    sys_clk = 1'b0;
	sys_rst_n = 1'b0;
	clk_fx = 1'b0;
	#60 sys_rst_n = 1'b1;
 
 end
 
always #10 sys_clk=~sys_clk;
always #1000 clk_fx=~clk_fx;
 
endmodule
