module key_led (
    input   sys_clk,
    input   sys_rst_n,
    
    input   	[1:0] key,  //����
    output  reg [1:0] led   //LED
);

reg [24:0] cnt;     //����ֵ

reg led_ctrl;       //LED��λ��־

//������
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        cnt <= 25'd0;
    //else if(cnt < 25'd2500_0000)    //δ��0.25ms��λ��һ
    else if(cnt < 25'd25)    //δ��0.25ms��λ��һ
        cnt <= cnt + 1'b1;
    else
        cnt <= 25'd0;           //���˾�����
end

//��־λ
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        led_ctrl <= 1'b0;
    //else if(cnt == 25'd2500_0000)
    else if(cnt == 25'd25)
        led_ctrl <= ~led_ctrl;  //0,25ms��תһ�Σ�0.5ms��Ȼ��0
end

//ģʽ�л�
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