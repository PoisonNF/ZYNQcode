`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/13 18:55:53
// Design Name: 
// Module Name: led_twinkle
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


module led_twinkle(
    input          sys_clk  ,  //系统时钟
    input          sys_rst_n,  //系统复位，低电平有效

    output  [1:0]  led         //LED灯
);

//reg define
reg  [25:0]  cnt ;

//*****************************************************
//**                    main code
//*****************************************************

//对计数器的值进行判断，以输出LED的状态
assign led = (cnt < 26'd2500_0000) ? 2'b01 : 2'b10 ;
//assign led = (cnt < 26'd5)         ? 2'b01 : 2'b10 ;  //仅用于仿真

//计数器在0~5000_000之间进行计数
always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        cnt <= 26'd0;
    else if(cnt < 26'd5000_0000)
//else if(cnt < 26'd10 - 1)  //仅用于仿真
        cnt <= cnt + 1'b1;
    else
        cnt <= 26'd0;
end

//ila_0 your_instance_name (
//	.clk(sys_clk), // input wire clk


//	.probe0(sys_rst_n), // input wire [0:0]  probe0  
//	.probe1(led), // input wire [1:0]  probe1 
//	.probe2(cnt) // input wire [25:0]  probe2
//);

endmodule
