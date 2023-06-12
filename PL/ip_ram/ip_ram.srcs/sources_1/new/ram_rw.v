`timescale 1ns / 1ps

module ram_rw(
    input            clk,
    input            rst_n,
    output reg       ram_en,      //ram使能
    output reg       rw,          //读写方向控制
    output reg [4:0] ram_addr,      //ram地址
    output reg [7:0] ram_wr_data    //写入ram数据
    );
    
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        ram_en <= 1'b0;
    else
        ram_en <= 1'b1;
end

reg [5:0] rw_cnt;   //模64计数器

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        rw_cnt <= 6'd0;
    else if(rw_cnt == 6'd63)       //达到上限清零
        rw_cnt <= 6'd0;
    else
        rw_cnt <= rw_cnt + 6'd1;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        ram_wr_data <= 8'd0;
    else if(rw_cnt <= 6'd31 && ram_en)  //当计数器小于等于31，ram使能，data加一
        ram_wr_data <= ram_wr_data + 8'd1;
    else
        ram_wr_data <= 8'd0;    //超过31的部分就是在读取，应当归零

end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        rw <= 1'b1;
    else if(rw_cnt <= 6'd31)
        rw <= 1'b1;     //写使能
    else
        rw <= 1'b0;     //读使能
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        ram_addr <= 5'd0;
    else
        ram_addr <= rw_cnt[4:0];    //地址值为计时器值
end

endmodule
