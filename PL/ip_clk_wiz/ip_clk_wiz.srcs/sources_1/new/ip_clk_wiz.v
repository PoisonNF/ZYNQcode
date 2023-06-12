`timescale 1ns / 1ps

module ip_clk_wiz(
    input sys_clk,
    input sys_rst_n,
    output  clk_out1,// 100mhz  K14
    output  clk_out2,// 100mhz 180œ‡Œª    M15
    output  clk_out3,// 25mhz   J14
    output  clk_out4,// 75mhz   L16
    output locked    // k18
    );
    
clk_wiz_0 instance_name
   (
    // Clock out ports
    .clk_out1(clk_out1),     // output clk_out1
    .clk_out2(clk_out2),     // output clk_out2
    .clk_out3(clk_out3),     // output clk_out3
    .clk_out4(clk_out4),     // output clk_out4
    // Status and control signals
    .resetn(sys_rst_n), // input resetn
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(sys_clk)
    );      // input clk_in1

endmodule
