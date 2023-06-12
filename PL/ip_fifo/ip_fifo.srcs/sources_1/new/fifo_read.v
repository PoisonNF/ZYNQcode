`timescale 1ns / 1ps

module fifo_read(
    input           clk,
    input           rst_n,

    input           almost_empty,
    input           almost_full,

    output reg      fifo_rd_en
    //input [7:0]     fifo_rd_data
    );

reg almost_full_now;
reg almost_full_last;
wire pose_flag;

reg [1:0] state;    //×´Ì¬»ú
reg [3:0] dly_cnt;  //ÑÓÊ±¼Ä´æÆ÷

assign pose_flag = (~almost_full_last & almost_full_now);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        almost_full_now <= 1'b0;
        almost_full_last <= 1'b0;
    end
    else begin
        almost_full_now <= almost_full;
        almost_full_last <= almost_full_now;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        fifo_rd_en <= 1'b0;
        state <= 2'd0;
        dly_cnt <= 4'b0;
    end
    else begin  
        case (state)
            2'd0:begin
                if(pose_flag)
                    state <= 2'd1;
                else
                    state <= state;
            end
            2'd1:begin
                if(dly_cnt == 4'd10)begin
                    dly_cnt <= 4'd0;
                    state <= 2'd2;
                end
                else
                    dly_cnt <= dly_cnt + 4'd1;
            end 
            2'd2:begin
                if(almost_empty)begin
                    fifo_rd_en <= 1'b0;
                    state <= 2'd0;
                end
                else
                    fifo_rd_en <= 1'b1;
            end
            default: 
                state <= 2'd0;
        endcase
    end
end

endmodule
