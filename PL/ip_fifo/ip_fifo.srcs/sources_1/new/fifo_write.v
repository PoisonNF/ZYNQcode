`timescale 1ns / 1ps

module fifo_write(
    input           clk,
    input           rst_n,

    input           almost_empty,
    input           almost_full,

    output reg      fifo_wr_en,
    output reg [7:0]fifo_wr_data
    );

reg almost_empty_now;
reg almost_empty_last;
wire pose_flag;

reg [1:0] state;    //状态机
reg [3:0] dly_cnt;  //延时寄存器



//检测上升沿模块
assign pose_flag = (~almost_empty_last & almost_empty_now);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        almost_empty_now <= 1'b0;
        almost_empty_last <= 1'b0;
    end
    else begin
        almost_empty_now <= almost_empty;       //保存当前值
        almost_empty_last <= almost_empty_now;  //保存上次的值
    end
end

//写模块
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin //复位全部清空
        fifo_wr_en <= 1'b0;
        fifo_wr_data <= 8'b0;
        state <= 2'd0;
        dly_cnt <= 4'b0;
    end
    else begin  
        case (state)
            2'd0:begin      //0状态：起始
                if(pose_flag)
                    state <= 2'd1;  //当检测到上升沿时，跳到1状态
                else
                    state <= state; //没有检测到上升沿，保持0状态
            end
            2'd1:begin      //1状态：保持10个周期，确保fifo可写
                if(dly_cnt == 4'd10)begin   //如果到达10个周期进入2状态
                    dly_cnt <= 4'd0;
                    state <= 2'd2;
                    fifo_wr_en <= 1'b1;    //写使能
                end
                else
                    dly_cnt <= dly_cnt + 4'd1;  //否则加一数值
            end 
            2'd2:begin
                if(almost_full)begin        //如果写满了
                    fifo_wr_en <= 1'b0;     //写使能失效
                    fifo_wr_data <= 8'b0;
                    state <= 2'd0;          //返回0状态
                end
                else
                    fifo_wr_en <= 1'b1;
                    fifo_wr_data <= fifo_wr_data + 8'd1;    //加一并且写入数值
            end
            default: 
                state <= 2'd0;
        endcase
    end
end

endmodule
