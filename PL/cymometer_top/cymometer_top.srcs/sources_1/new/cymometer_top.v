`timescale 1ns / 1ps

module cymometer_top(
    input   sys_clk,
    input   sys_rst_n,

    input   clk_fx,       //被测信号
    output  clk_out,     //由clkIP产生的信号，可作为被测信号使用

    output  uart_txd     //串口发送
    );
    
wire [19:0] u_data_fx;
wire measure_done;
wire send_en;
wire send_busy;
wire [7:0] send_data;
wire locked;

clk_wiz_0 u_clk_wiz_0
   (
    // Clock out ports
    .clk_out1(clk_out),     // output clk_out1
    // Status and control signals
    .reset(sys_rst_n), // input reset
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(sys_clk));      // input clk_in1
    
cymometer u_cymometer(
    .clk_fs          (sys_clk),
    .rst_n           (sys_rst_n),

    .clk_fx          (clk_fx),
    .data_fx         (u_data_fx),
    .measure_done    (measure_done)
);

uart_send u_uart_send(
    .sys_clk         (sys_clk),
    .sys_rst_n       (sys_rst_n),
                    
    .uart_en         (send_en),
    .uart_din        (send_data),
    .uart_txd        (uart_txd),
    .uart_tx_busy    (send_busy)
);

ctrl u_ctrl(
    .sys_clk          (sys_clk),
    .sys_rst_n        (sys_rst_n),

    .data_fx          (u_data_fx),
    .tx_busy          (send_busy),
    .measure_done     (measure_done),

    .send_en          (send_en),
    .send_data        (send_data)
);

ila_0 u_ila_0 (
	.clk(sys_clk), // input wire clk


	.probe0(clk_out), // input wire [0:0]  probe0  
	.probe1(uart_txd), // input wire [0:0]  probe1 
	.probe2(measure_done), // input wire [0:0]  probe2 
	.probe3(send_en), // input wire [0:0]  probe3 
	.probe4(send_busy), // input wire [0:0]  probe4 
	.probe5(send_data), // input wire [7:0]  probe5 
	.probe6(u_data_fx) // input wire [19:0]  probe6
);


endmodule
