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
reg [3:0]rx_cnt;          //���յ�bit��
reg [15:0]clk_cnt;        //������

reg [7:0]rx_data;

parameter CLK_FREQ = 50000000;
parameter UART_BPS = 115200;
parameter BPS_CNT = CLK_FREQ/UART_BPS;

//ץȡ�½���
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
        if(start_flag)  //start_flag��1ʱ��ʼ����
            rx_flag <= 1'd1;
        else if(rx_cnt == 4'd9 && clk_cnt == BPS_CNT/2)//�����������һλ��rx_flag����
            rx_flag <= 1'd0;
        else            //�������㣬���ֲ���
            rx_flag <= rx_flag;
    end
end

//clk_cnt
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        clk_cnt <= 16'd0;
    else if(rx_flag)begin
        if(clk_cnt == BPS_CNT-1)  //����ﵽ���������������
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
        if(clk_cnt == BPS_CNT-1)    //�������������ʱ��rx_cnt��һ
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
        if(clk_cnt == BPS_CNT/2)begin   //�м�ֵ����
            case (rx_cnt)
                4'd1: rx_data[0] <= uart_rxd_last;  //ʹ�üĴ�����ε�ֵ
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
        else    //rx_flag��1������rx_data����
            rx_data <= rx_data;
    end
    else
        rx_data <= 8'd0;
end

//uart_data �� uart_done
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        uart_data <= 8'd0;
        uart_done <= 1'b0;
    end
    else if(rx_cnt == 4'd9)begin    //һ֡�������
        uart_data <= rx_data;       //���ݴ���uart_data��
        uart_done <= 1'b1;          //������ɱ�־��1
    end
    else begin
        uart_data <= 8'd0;
        uart_done <= 1'b0;
    end
end      


endmodule