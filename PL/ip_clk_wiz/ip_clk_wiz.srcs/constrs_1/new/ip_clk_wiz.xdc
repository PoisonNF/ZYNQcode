#----------------------系统时钟---------------------------
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports sys_clk]

#----------------------系统复位---------------------------
set_property -dict {PACKAGE_PIN N16 IOSTANDARD LVCMOS33} [get_ports sys_rst_n]

set_property -dict {PACKAGE_PIN K14 IOSTANDARD LVCMOS33} [get_ports clk_out1]
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS33} [get_ports clk_out2]
set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33} [get_ports clk_out3]
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports clk_out4]

set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports locked]