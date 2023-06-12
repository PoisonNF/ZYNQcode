module uart_loop (
    input               sys_clk,
    input               sys_rst_n,

    input               recv_done,
    input     [7:0]     recv_data,  

    input               tx_busy,
    output reg          send_en,
    output reg [7:0]    send_data  
);


reg recv_done_now;
reg recv_done_last;
wire recv_done_flag;

reg tx_ready;       //准备发送标志

//抓取上升沿
assign recv_done_flag = recv_done_now & ~recv_done_last;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        recv_done_now <= 1'd0;
        recv_done_last <= 1'd0;
    end
    else begin
        recv_done_now <= recv_done;
        recv_done_last <= recv_done_now;
    end 
end

//数据接收和发送
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        send_en <= 1'd0;
        send_data <= 8'd0;
        tx_ready <= 1'b0;
    end
    else begin
        if(recv_done_flag) begin //如果接收完成标志置1
            tx_ready <= 1'd1;
            send_data <= recv_data;     //数据挂载
            send_en <= 1'd0;
        end
        else if(~tx_busy && tx_ready) begin //如果发送不忙并且准备发送
            tx_ready <= 1'd0;
            send_en <= 1'd1;
        end
    end
end
    
endmodule