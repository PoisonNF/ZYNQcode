`timescale 1ns / 1ps

module breath_led(
	input sys_clk,
	input sys_rst_n,
	
	output led
    );
    
reg [15:0] period_cnt;
reg [15:0] duty_cycle;
reg			inc_dec_flag;

parameter cnt_max = 16'd50000;  //周期1ms
parameter duty_inc = 16'd50;    //需要1000个周期到达最高

assign led = (period_cnt >= duty_cycle)? 1'b1:1'b0;	//led变化

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
		inc_dec_flag <= 1'b0;	//0为逐渐增大，1为逐渐降低
	end

	else begin
		if(period_cnt == cnt_max)		//周期计数到达最高
			if(inc_dec_flag == 1'b0)	//如果为上升模式
				if(duty_cycle == cnt_max)	//如果占空比到达最大
					inc_dec_flag = 1'b1;	//变更为下降模式
				else
					duty_cycle <= duty_cycle + duty_inc;	//没到最大一直累加
			else
				if(duty_cycle == 16'd0)
					inc_dec_flag = 1'b0;   //变更为上升模式
				else
					duty_cycle <= duty_cycle - duty_inc;	//没到最小一直递减
	end

end

endmodule
