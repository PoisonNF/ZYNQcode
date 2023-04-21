`timescale 1ns/1ps
module tb_key_led ();

reg sys_clk;
reg sys_rst_n;

reg [1:0]  key;
wire [1:0] led;

initial begin
    sys_clk = 1'b0;
    sys_rst_n = 1'b0;
    key = 2'b11;
    #20 sys_rst_n = 1'b1;

    #400 key = 2'b10;
    #800 key = 2'b01;
    #800 key = 2'b11;
end

always #10 sys_clk <= ~sys_clk; //ÆµÂÊÎª50mhz


key_led u_key_led(
    .sys_clk    (sys_clk),
    .sys_rst_n  (sys_rst_n),

    .key        (key),
    .led        (led)
);

endmodule