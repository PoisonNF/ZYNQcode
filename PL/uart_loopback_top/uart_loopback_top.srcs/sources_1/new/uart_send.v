module uart_send (
    input               sys_clk,
    input               sys_rst_n,

    input               uart_en,     //����ʹ��
    input [7:0]         uart_din,    //��Ҫ���͵�����
    output   reg        uart_txd,    //������
    output              uart_tx_busy //������æ

);

reg uart_en_now;
reg uart_en_last;
wire en_flag;

reg tx_flag;
reg [7:0]tx_data;         //��ʱ���ݼĴ���
reg [3:0]tx_cnt;
reg [15:0]clk_cnt;        //������

parameter CLK_FREQ = 50000000;
parameter UART_BPS = 115200;
parameter BPS_CNT = CLK_FREQ/UART_BPS;

assign uart_tx_busy = tx_flag;

//ץȡ������
assign en_flag = uart_en_now & ~uart_en_last;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        uart_en_now <= 1'd0;
        uart_en_last <= 1'd0;
    end
    else begin
        uart_en_now <= uart_en;
        uart_en_last <= uart_en_now;
    end 
end

//tx_flag �� tx_data
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        tx_flag <= 1'd0;
        tx_data <= 8'd0;
    end
    else if(en_flag)begin
        tx_flag <= 1'd1;
        tx_data <= uart_din;
    end
    else if(tx_cnt == 4'd9 && (clk_cnt == BPS_CNT -(BPS_CNT/16)))begin    //���������ʱ�ָ�
        tx_flag <= 1'd0;
        tx_data <= 8'd0;
    end
    else begin  //�����б��ֲ���
        tx_flag <= tx_flag;
        tx_data <= tx_data;
    end
end

//clk_cnt
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        clk_cnt <= 16'd0;
    else if(tx_flag)begin
        if(clk_cnt == BPS_CNT-1)  //����ﵽ���������������
            clk_cnt <= 16'd0;
        else
            clk_cnt <= clk_cnt + 16'd1;
    end
    else
        clk_cnt <= 16'd0;
end

//tx_cnt
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        tx_cnt <= 4'd0;
    else if(tx_flag)begin
        if(clk_cnt == BPS_CNT-1)    //�������������ʱ��tx_cnt��һ
            tx_cnt <= tx_cnt + 4'd1;
        else
            tx_cnt <= tx_cnt;
    end
    else
        tx_cnt <= 4'd0;
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        uart_txd <= 1'd1;
    else if(tx_flag)begin
        case (tx_cnt)
            4'd0: uart_txd <= 1'd0;         //��ʼλ���½���
            4'd1: uart_txd <= tx_data[0];   
            4'd2: uart_txd <= tx_data[1];
            4'd3: uart_txd <= tx_data[2];
            4'd4: uart_txd <= tx_data[3];
            4'd5: uart_txd <= tx_data[4];
            4'd6: uart_txd <= tx_data[5];
            4'd7: uart_txd <= tx_data[6];
            4'd8: uart_txd <= tx_data[7];
            4'd9: uart_txd <= 1'd1;         //��ʾ�������
            default: ;
        endcase
    end
    else
        uart_txd <= 1'd1;
end

endmodule