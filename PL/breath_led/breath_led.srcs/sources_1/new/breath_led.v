`timescale 1ns / 1ps

module breath_led(
	input sys_clk,
	input sys_rst_n,
	
	output led
    );
    
reg [15:0] period_cnt;
reg [15:0] duty_cycle;
reg			inc_dec_flag;

parameter cnt_max = 16'd50000;  //����1ms
parameter duty_inc = 16'd50;    //��Ҫ1000�����ڵ������

assign led = (period_cnt >= duty_cycle)? 1'b1:1'b0;	//led�仯

always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)
		period_cnt <= 16'd0;
	else if(period_cnt == cnt_max)
		period_cnt <= 16'd0;
	else
		period_cnt <= period_cnt + 1'b1;
end

always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)begin
		duty_cycle <= 16'd0;
		inc_dec_flag <= 1'b0;	//0Ϊ������1Ϊ�𽥽���
	end

	else begin
		if(period_cnt == cnt_max)		//���ڼ����������
			if(inc_dec_flag == 1'b0)	//���Ϊ����ģʽ
				if(duty_cycle == cnt_max)	//���ռ�ձȵ������
					inc_dec_flag = 1'b1;	//���Ϊ�½�ģʽ
				else
					duty_cycle <= duty_cycle + duty_inc;	//û�����һֱ�ۼ�
			else
				if(duty_cycle == 16'd0)
					inc_dec_flag = 1'b0;   //���Ϊ����ģʽ
				else
					duty_cycle <= duty_cycle - duty_inc;	//û����Сһֱ�ݼ�
	end

end

endmodule
