`timescale 1ns / 1ps

module ctrl(
    input               sys_clk,
    input               sys_rst_n,
    
    //来自频率计的信号
    input [19:0]        data_fx,  //被测信号频率输出
    input               tx_busy,
    input               measure_done,
    
    //给串口发送模块的信号
    output reg          send_en,    //串口模块发送使能
    output reg [7:0]    send_data   //发送的数据
    );
    
reg tx_ready;
//wire   [3:0]              data0    ;        // 十万位数
//wire   [3:0]              data1    ;        // 万位数
//wire   [3:0]              data2    ;        // 千位数
//wire   [3:0]              data3    ;        // 百位数
//wire   [3:0]              data4    ;        // 十位数
//wire   [3:0]              data5    ;        // 个位数

//assign  data5 = data_fx / 17'd100000;           // 十万位数
//assign  data4 = data_fx / 14'd10000 % 4'd10;    // 万位数
//assign  data3 = data_fx / 10'd1000 % 4'd10 ;    // 千位数
//assign  data2 = data_fx /  7'd100 % 4'd10  ;    // 百位数
//assign  data1 = data_fx /  4'd10 % 4'd10   ;    // 十位数
//assign  data0 = data_fx %  4'd10;               // 个位数

//将数据交给串口发送
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        send_en <= 1'd0;
        send_data <= 8'd0;
        tx_ready <= 1'b0;
    end
    else begin
        if(measure_done) begin //如果接收完成标志置1
            tx_ready <= 1'd1;
            send_data <= data_fx;     //数据挂载
            send_en <= 1'd0;
        end
        else if(~tx_busy && tx_ready) begin //如果发送不忙并且准备发送
            tx_ready <= 1'd0;
            send_en <= 1'd1;
        end
    end
end    
    
endmodule
