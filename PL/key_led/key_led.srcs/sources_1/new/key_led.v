module key_led (
    input   sys_clk,
    input   sys_rst_n,
    
    input   	[1:0] key,  //按键
    output  reg [1:0] led   //LED
);

reg [24:0] cnt;     //计数值

reg led_ctrl;       //LED置位标志

//计数器
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        cnt <= 25'd0;
    //else if(cnt < 25'd2500_0000)    //未到0.25ms按位加一
    else if(cnt < 25'd25)    //未到0.25ms按位加一
        cnt <= cnt + 1'b1;
    else
        cnt <= 25'd0;           //到了就清零
end

//标志位
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        led_ctrl <= 1'b0;
    //else if(cnt == 25'd2500_0000)
    else if(cnt == 25'd25)
        led_ctrl <= ~led_ctrl;  //0,25ms翻转一次，0.5ms必然是0
end

//模式切换
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        led <= 2'b11;
    else case (key)
        2'b10:
            if(led_ctrl == 1'b0)
                led <= 2'b01;
            else
                led <= 2'b10;
        2'b01:
            if(led_ctrl == 1'b0)
                led <= 2'b11;
            else
                led <= 2'b00;
        2'b11:
            led <= 2'b11;
        default: 
            led <= 2'b11;
    endcase
end
    
endmodule