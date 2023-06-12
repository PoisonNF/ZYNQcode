`timescale 1ns / 1ps

module tb_uart_loopback_top();

reg sys_clk;
reg sys_rst_n;
reg uart_rxd;

wire uart_txd;

parameter utime = 1000; //波特率设置为1m

uart_loopback_top u_uart_loopback_top(
    .sys_clk       (sys_clk),
    .sys_rst_n     (sys_rst_n),

    .uart_rxd      (uart_rxd),
    .uart_txd      (uart_txd)
);

initial begin
	sys_clk = 1'b0;
	sys_rst_n = 1'b0;
	#60 sys_rst_n = 1'b1;

    //起始信号
    #100 uart_rxd = 1'b1;
    #utime uart_rxd = 1'b0;

    //8位数据 eb
    #utime uart_rxd = 1'b1;  //1
    #utime uart_rxd = 1'b1;
    #utime uart_rxd = 1'b0;
    #utime uart_rxd = 1'b1;
    
    #utime uart_rxd = 1'b0;
    #utime uart_rxd = 1'b1;
    #utime uart_rxd = 1'b1;
    #utime uart_rxd = 1'b1;

    //停止位
    #utime uart_rxd = 1'b1;
    
    
    //起始信号
    #1000 uart_rxd = 1'b1;
    #utime uart_rxd = 1'b0;

    //8位数据 aa
    #utime uart_rxd = 1'b0;  //1
    #utime uart_rxd = 1'b1;
    #utime uart_rxd = 1'b0;
    #utime uart_rxd = 1'b1;
    
    #utime uart_rxd = 1'b0;
    #utime uart_rxd = 1'b1;
    #utime uart_rxd = 1'b0;
    #utime uart_rxd = 1'b1;

    //停止位
    #utime uart_rxd = 1'b1;

end

always #10 sys_clk=~sys_clk;

endmodule
