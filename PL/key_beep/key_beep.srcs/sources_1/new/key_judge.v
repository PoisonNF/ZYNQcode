`timescale 1ns / 1ps

module key_judge(
        input 	   sys_clk,
        input 	   sys_rst_n,

        input 	   key,
        output reg key_value,
        output reg key_flag
    );

reg [20:0] cnt;
reg         key_reg;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        cnt <= 20'd0;
        key_reg <= 1'b1;    //按键不按下是高电平
    end
    else begin

        //寄存key的值
        key_reg <= key;
        //按键发生变化
        if(key_reg != key)begin
            //cnt <= 20'd100_0000;   //按键消抖20ms
            cnt <= 20'd10;   //仿真
        end
        else begin
            if(cnt > 20'd0)
                cnt <= cnt - 1;
            else 
                cnt <= 20'd0;
        end
    end
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        key_value <= 1'b1;
        key_flag  <= 1'b0;
    end

    //到20ms结束前判断，才能实现脉冲效果
    else if(cnt == 20'd1)begin
        key_value <= key;
        key_flag  <= 1'b1;
    end

    //在减数期间保持之前的数值
    else begin
        key_value <= key_value;
        key_flag  <= 1'b0;
    end
end

endmodule
