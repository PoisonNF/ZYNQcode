module uart_send (
    input               sys_clk,
    input               sys_rst_n,

    input               uart_en,     //发送使能
    input [7:0]         uart_din,    //需要发送的数据
    output   reg        uart_txd,    //发送线
    output              uart_tx_busy //发送正忙

);

reg uart_en_now;
reg uart_en_last;
wire en_flag;

reg tx_flag;
reg [7:0]tx_data;         //临时数据寄存器
reg [3:0]tx_cnt;
reg [15:0]clk_cnt;        //周期数

parameter CLK_FREQ = 50000000;
parameter UART_BPS = 115200;
parameter BPS_CNT = CLK_FREQ/UART_BPS;

assign uart_tx_busy = tx_flag;

//抓取上升沿
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

//tx_flag 和 tx_data
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        tx_flag <= 1'd0;
        tx_data <= 8'd0;
    end
    else if(en_flag)begin
        tx_flag <= 1'd1;
        tx_data <= uart_din;
    end
    else if(tx_cnt == 4'd9 && (clk_cnt == BPS_CNT -(BPS_CNT/16)))begin    //当发送完成时恢复
        tx_flag <= 1'd0;
        tx_data <= 8'd0;
    end
    else begin  //发送中保持不变
        tx_flag <= tx_flag;
        tx_data <= tx_data;
    end
end

//clk_cnt
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        clk_cnt <= 16'd0;
    else if(tx_flag)begin
        if(clk_cnt == BPS_CNT-1)  //如果达到最大周期数，清零
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
        if(clk_cnt == BPS_CNT-1)    //当数到最大周期时，tx_cnt加一
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
            4'd0: uart_txd <= 1'd0;         //起始位，下降沿
            4'd1: uart_txd <= tx_data[0];   
            4'd2: uart_txd <= tx_data[1];
            4'd3: uart_txd <= tx_data[2];
            4'd4: uart_txd <= tx_data[3];
            4'd5: uart_txd <= tx_data[4];
            4'd6: uart_txd <= tx_data[5];
            4'd7: uart_txd <= tx_data[6];
            4'd8: uart_txd <= tx_data[7];
            4'd9: uart_txd <= 1'd1;         //表示发送完成
            default: ;
        endcase
    end
    else
        uart_txd <= 1'd1;
end

endmodule