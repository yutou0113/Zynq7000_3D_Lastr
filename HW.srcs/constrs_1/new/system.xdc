## This file is a general .xdc for the ALINX AX7010 board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used signals according to the project

set_property IOSTANDARD TMDS_33 [get_ports TMDS_clk_n]


set_property PACKAGE_PIN N18 [get_ports TMDS_clk_p]
set_property IOSTANDARD TMDS_33 [get_ports TMDS_clk_p]


set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_n[0]}]


set_property PACKAGE_PIN V20 [get_ports {TMDS_data_p[0]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_p[0]}]

set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_n[1]}]


set_property PACKAGE_PIN T20 [get_ports {TMDS_data_p[1]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_p[1]}]


set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_n[2]}]


set_property PACKAGE_PIN N20 [get_ports {TMDS_data_p[2]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_p[2]}]



set_property PACKAGE_PIN Y19 [get_ports {hdmi_hpd_tri_i[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmi_hpd_tri_i[0]}]

set_property PACKAGE_PIN V16 [get_ports {HDMI_OEN[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {HDMI_OEN[0]}]

#II2C
#sc
set_property PACKAGE_PIN B20 [get_ports {gpio_0_tri_io[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_0_tri_io[0]}]
set_property PULLUP true [get_ports {gpio_0_tri_io[0]}]
#sd
set_property PACKAGE_PIN C20 [get_ports {gpio_0_tri_io[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_0_tri_io[1]}]
set_property PULLUP true [get_ports {gpio_0_tri_io[1]}]


#OV7725
#set_property  -dict {PACKAGE_PIN  T11   IOSTANDARD LVCMOS33} [get_ports cmos_xclk_o]
set_property PACKAGE_PIN T11 [get_ports {cmos_xclk_o[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos_xclk_o[0]}]

set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports cmos_pclk_i]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets cmos_pclk_i]


#------------------------------------------------------------------------------------------------
set_property -dict {PACKAGE_PIN A20 IOSTANDARD LVCMOS33} [get_ports cmos_vsync_i]
set_property -dict {PACKAGE_PIN B19 IOSTANDARD LVCMOS33} [get_ports cmos_href_i]
#------------------------------------------------------------------------------------------------
set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33} [get_ports {cmos_data_i[0]}]
set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS33} [get_ports {cmos_data_i[1]}]
set_property -dict {PACKAGE_PIN U13 IOSTANDARD LVCMOS33} [get_ports {cmos_data_i[2]}]
set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS33} [get_ports {cmos_data_i[3]}]
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports {cmos_data_i[4]}]
set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33} [get_ports {cmos_data_i[5]}]
set_property -dict {PACKAGE_PIN T12 IOSTANDARD LVCMOS33} [get_ports {cmos_data_i[6]}]
set_property -dict {PACKAGE_PIN U12 IOSTANDARD LVCMOS33} [get_ports {cmos_data_i[7]}]

set_property PACKAGE_PIN V18 [get_ports {COMS_reset[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {COMS_reset[0]}]

set_property PACKAGE_PIN V17 [get_ports {COMS_PWDN[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {COMS_PWDN[0]}]




