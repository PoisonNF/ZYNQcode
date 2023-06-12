module uart_recv(
    input               sys_clk,
    input               sys_rst_n,

    input               uart_rxd,
    output reg [7:0]    uart_data,
    output reg          uart_done
);

reg uart_rxd_now;
reg uart_rxd_last;
wire start_flag;

reg rx_flag;
reg [3:0]rx_cnt;          //接收的bit数
reg [15:0]clk_cnt;        //周期数

reg [7:0]rx_data;

parameter CLK_FREQ = 50000000;
parameter UART_BPS = 115200;
parameter BPS_CNT = CLK_FREQ/UART_BPS;

//抓取下降沿
assign start_flag = ~uart_rxd_now & uart_rxd_last;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        uart_rxd_now <= 1'd0;
        uart_rxd_last <= 1'd0;
    end
    else begin
        uart_rxd_now <= uart_rxd;
        uart_rxd_last <= uart_rxd_now;
    end 
end

//rx_flag
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        rx_flag <= 1'd0;
    else begin
        if(start_flag)  //start_flag置1时开始接收
            rx_flag <= 1'd1;
        else if(rx_cnt == 4'd9 && clk_cnt == BPS_CNT/2)//当接收完最后一位后将rx_flag归零
            rx_flag <= 1'd0;
        else            //都不满足，保持不动
            rx_flag <= rx_flag;
    end
end

//clk_cnt
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        clk_cnt <= 16'd0;
    else if(rx_flag)begin
        if(clk_cnt == BPS_CNT-1)  //如果达到最大周期数，清零
            clk_cnt <= 16'd0;
        else
            clk_cnt <= clk_cnt + 16'd1;
    end
    else
        clk_cnt <= 16'd0;
end

//rx_cnt
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        rx_cnt <= 4'd0;
    else if(rx_flag)begin
        if(clk_cnt == BPS_CNT-1)    //当数到最大周期时，rx_cnt加一
            rx_cnt <= rx_cnt + 4'd1;
        else
            rx_cnt <= rx_cnt;
    end
    else
        rx_cnt <= 4'd0;
end

//rx_data
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        rx_data <= 8'd0;
    else if(rx_flag)begin
        if(clk_cnt == BPS_CNT/2)begin   //中间值采样
            case (rx_cnt)
                4'd1: rx_data[0] <= uart_rxd_last;  //使用寄存过两次的值
                4'd2: rx_data[1] <= uart_rxd_last;
                4'd3: rx_data[2] <= uart_rxd_last;
                4'd4: rx_data[3] <= uart_rxd_last;
                4'd5: rx_data[4] <= uart_rxd_last;
                4'd6: rx_data[5] <= uart_rxd_last;
                4'd7: rx_data[6] <= uart_rxd_last;
                4'd8: rx_data[7] <= uart_rxd_last;
                default: ;
            endcase
        end
        else    //rx_flag置1，保持rx_data不动
            rx_data <= rx_data;
    end
    else
        rx_data <= 8'd0;
end

//uart_data 和 uart_done
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        uart_data <= 8'd0;
        uart_done <= 1'b0;
    end
    else if(rx_cnt == 4'd9)begin    //一帧接收完毕
        uart_data <= rx_data;       //数据传到uart_data中
        uart_done <= 1'b1;          //接收完成标志置1
    end
    else begin
        uart_data <= 8'd0;
        uart_done <= 1'b0;
    end
end      


endmodule