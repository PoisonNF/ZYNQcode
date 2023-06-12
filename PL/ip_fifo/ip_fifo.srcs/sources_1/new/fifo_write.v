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

reg [1:0] state;    //״̬��
reg [3:0] dly_cnt;  //��ʱ�Ĵ���



//���������ģ��
assign pose_flag = (~almost_empty_last & almost_empty_now);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        almost_empty_now <= 1'b0;
        almost_empty_last <= 1'b0;
    end
    else begin
        almost_empty_now <= almost_empty;       //���浱ǰֵ
        almost_empty_last <= almost_empty_now;  //�����ϴε�ֵ
    end
end

//дģ��
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin //��λȫ�����
        fifo_wr_en <= 1'b0;
        fifo_wr_data <= 8'b0;
        state <= 2'd0;
        dly_cnt <= 4'b0;
    end
    else begin  
        case (state)
            2'd0:begin      //0״̬����ʼ
                if(pose_flag)
                    state <= 2'd1;  //����⵽������ʱ������1״̬
                else
                    state <= state; //û�м�⵽�����أ�����0״̬
            end
            2'd1:begin      //1״̬������10�����ڣ�ȷ��fifo��д
                if(dly_cnt == 4'd10)begin   //�������10�����ڽ���2״̬
                    dly_cnt <= 4'd0;
                    state <= 2'd2;
                    fifo_wr_en <= 1'b1;    //дʹ��
                end
                else
                    dly_cnt <= dly_cnt + 4'd1;  //�����һ��ֵ
            end 
            2'd2:begin
                if(almost_full)begin        //���д����
                    fifo_wr_en <= 1'b0;     //дʹ��ʧЧ
                    fifo_wr_data <= 8'b0;
                    state <= 2'd0;          //����0״̬
                end
                else
                    fifo_wr_en <= 1'b1;
                    fifo_wr_data <= fifo_wr_data + 8'd1;    //��һ����д����ֵ
            end
            default: 
                state <= 2'd0;
        endcase
    end
end

endmodule
