module uart_loopback_top (
    input               sys_clk,
    input               sys_rst_n,

    input               uart_rxd,
    output              uart_txd
);

wire uart_en;
wire [7:0]uart_din;
wire [7:0]uart_data;
wire uart_done;
wire uart_tx_busy;

//parameter define
parameter  CLK_FREQ = 50000000;         //����ϵͳʱ��Ƶ��
parameter  UART_BPS = 115200;           //���崮�ڲ�����

uart_recv  #(                          
    .CLK_FREQ       (CLK_FREQ),         //����ϵͳʱ��Ƶ��
    .UART_BPS       (UART_BPS))         //���ô��ڽ��ղ�����
u_uart_recv
(
    .sys_clk        (sys_clk),
    .sys_rst_n      (sys_rst_n),
    .uart_rxd       (uart_rxd),
    .uart_data      (uart_data),
    .uart_done      (uart_done)
);

uart_send #(                          
    .CLK_FREQ       (CLK_FREQ),         //����ϵͳʱ��Ƶ��
    .UART_BPS       (UART_BPS))         //���ô��ڽ��ղ�����
u_uart_send(
    .sys_clk        (sys_clk),
    .sys_rst_n      (sys_rst_n),
    .uart_en        (uart_en),
    .uart_din       (uart_din),
    .uart_txd       (uart_txd),
    .uart_tx_busy   (uart_tx_busy)
);

uart_loop u_uart_loop(
    .sys_clk        (sys_clk),
    .sys_rst_n      (sys_rst_n),
    .recv_done      (uart_done),
    .recv_data      (uart_data),
    .tx_busy        (uart_tx_busy),
    .send_en        (uart_en),
    .send_data      (uart_din)
);
    
endmodule