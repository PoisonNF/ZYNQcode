#----------------------系统时钟---------------------------
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports sys_clk]

#----------------------系统复位---------------------------
set_property -dict {PACKAGE_PIN N16 IOSTANDARD LVCMOS33} [get_ports sys_rst_n]

set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports uart_txd]

set_property IOSTANDARD LVCMOS33 [get_ports clk_out]
set_property IOSTANDARD LVCMOS33 [get_ports clk_fx]
set_property PACKAGE_PIN J14 [get_ports clk_fx]
set_property PACKAGE_PIN K14 [get_ports clk_out]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_fx_IBUF]
