`timescale 1ns / 1ps

module ram_rw(
    input            clk,
    input            rst_n,
    output reg       ram_en,      //ramʹ��
    output reg       rw,          //��д�������
    output reg [4:0] ram_addr,      //ram��ַ
    output reg [7:0] ram_wr_data    //д��ram����
    );
    
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        ram_en <= 1'b0;
    else
        ram_en <= 1'b1;
end

reg [5:0] rw_cnt;   //ģ64������

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        rw_cnt <= 6'd0;
    else if(rw_cnt == 6'd63)       //�ﵽ��������
        rw_cnt <= 6'd0;
    else
        rw_cnt <= rw_cnt + 6'd1;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        ram_wr_data <= 8'd0;
    else if(rw_cnt <= 6'd31 && ram_en)  //��������С�ڵ���31��ramʹ�ܣ�data��һ
        ram_wr_data <= ram_wr_data + 8'd1;
    else
        ram_wr_data <= 8'd0;    //����31�Ĳ��־����ڶ�ȡ��Ӧ������

end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        rw <= 1'b1;
    else if(rw_cnt <= 6'd31)
        rw <= 1'b1;     //дʹ��
    else
        rw <= 1'b0;     //��ʹ��
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        ram_addr <= 5'd0;
    else
        ram_addr <= rw_cnt[4:0];    //��ֵַΪ��ʱ��ֵ
end

endmodule
