`timescale 1ns / 1ps

module ctrl(
    input               sys_clk,
    input               sys_rst_n,
    
    //����Ƶ�ʼƵ��ź�
    input [19:0]        data_fx,  //�����ź�Ƶ�����
    input               tx_busy,
    input               measure_done,
    
    //�����ڷ���ģ����ź�
    output reg          send_en,    //����ģ�鷢��ʹ��
    output reg [7:0]    send_data   //���͵�����
    );
    
reg tx_ready;
//wire   [3:0]              data0    ;        // ʮ��λ��
//wire   [3:0]              data1    ;        // ��λ��
//wire   [3:0]              data2    ;        // ǧλ��
//wire   [3:0]              data3    ;        // ��λ��
//wire   [3:0]              data4    ;        // ʮλ��
//wire   [3:0]              data5    ;        // ��λ��

//assign  data5 = data_fx / 17'd100000;           // ʮ��λ��
//assign  data4 = data_fx / 14'd10000 % 4'd10;    // ��λ��
//assign  data3 = data_fx / 10'd1000 % 4'd10 ;    // ǧλ��
//assign  data2 = data_fx /  7'd100 % 4'd10  ;    // ��λ��
//assign  data1 = data_fx /  4'd10 % 4'd10   ;    // ʮλ��
//assign  data0 = data_fx %  4'd10;               // ��λ��

//�����ݽ������ڷ���
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        send_en <= 1'd0;
        send_data <= 8'd0;
        tx_ready <= 1'b0;
    end
    else begin
        if(measure_done) begin //���������ɱ�־��1
            tx_ready <= 1'd1;
            send_data <= data_fx;     //���ݹ���
            send_en <= 1'd0;
        end
        else if(~tx_busy && tx_ready) begin //������Ͳ�æ����׼������
            tx_ready <= 1'd0;
            send_en <= 1'd1;
        end
    end
end    
    
endmodule
