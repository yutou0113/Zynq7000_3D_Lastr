
################################################################
# This is a generated script based on design: system
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source system_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z010clg400-1

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}



# CHANGE DESIGN NAME HERE
set design_name system

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: system
proc create_hier_cell_system_1 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_system_1() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR
  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 GPIO_0
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M01_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M02_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M03_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M04_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M05_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S01_AXI

  # Create pins
  create_bd_pin -dir O -type clk FCLK_CLK0
  create_bd_pin -dir O -type clk FCLK_CLK1
  create_bd_pin -dir I -from 0 -to 0 -type intr IRQ_F2P
  create_bd_pin -dir O -from 0 -to 0 -type rst S00_ARESETN

  # Create instance: axi_mem_intercon, and set properties
  set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon ]
  set_property -dict [ list \
CONFIG.ENABLE_ADVANCED_OPTIONS {0} \
CONFIG.NUM_MI {2} \
CONFIG.NUM_SI {4} \
 ] $axi_mem_intercon

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1} \
CONFIG.PCW_CAN0_CAN0_IO {MIO 10 .. 11} \
CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_CAN1_CAN1_IO {MIO 8 .. 9} \
CONFIG.PCW_CAN1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_EN_CLK1_PORT {1} \
CONFIG.PCW_EN_CLK2_PORT {0} \
CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {25} \
CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1} \
CONFIG.PCW_GPIO_EMIO_GPIO_IO {2} \
CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
CONFIG.PCW_I2C_RESET_ENABLE {0} \
CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_MIO_10_SLEW {fast} \
CONFIG.PCW_MIO_11_SLEW {fast} \
CONFIG.PCW_MIO_16_SLEW {fast} \
CONFIG.PCW_MIO_17_SLEW {fast} \
CONFIG.PCW_MIO_18_SLEW {fast} \
CONFIG.PCW_MIO_19_SLEW {fast} \
CONFIG.PCW_MIO_1_SLEW {fast} \
CONFIG.PCW_MIO_20_SLEW {fast} \
CONFIG.PCW_MIO_21_SLEW {fast} \
CONFIG.PCW_MIO_22_SLEW {fast} \
CONFIG.PCW_MIO_23_SLEW {fast} \
CONFIG.PCW_MIO_24_SLEW {fast} \
CONFIG.PCW_MIO_25_SLEW {fast} \
CONFIG.PCW_MIO_26_SLEW {fast} \
CONFIG.PCW_MIO_27_SLEW {fast} \
CONFIG.PCW_MIO_2_SLEW {fast} \
CONFIG.PCW_MIO_3_SLEW {fast} \
CONFIG.PCW_MIO_40_SLEW {fast} \
CONFIG.PCW_MIO_41_SLEW {fast} \
CONFIG.PCW_MIO_42_SLEW {fast} \
CONFIG.PCW_MIO_43_SLEW {fast} \
CONFIG.PCW_MIO_44_SLEW {fast} \
CONFIG.PCW_MIO_45_SLEW {fast} \
CONFIG.PCW_MIO_47_SLEW {fast} \
CONFIG.PCW_MIO_48_SLEW {fast} \
CONFIG.PCW_MIO_49_SLEW {fast} \
CONFIG.PCW_MIO_4_SLEW {fast} \
CONFIG.PCW_MIO_52_SLEW {fast} \
CONFIG.PCW_MIO_53_SLEW {fast} \
CONFIG.PCW_MIO_5_SLEW {fast} \
CONFIG.PCW_MIO_6_SLEW {fast} \
CONFIG.PCW_MIO_8_SLEW {fast} \
CONFIG.PCW_MIO_9_SLEW {fast} \
CONFIG.PCW_OVERRIDE_BASIC_CLOCK {0} \
CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
CONFIG.PCW_SD0_GRP_CD_IO {MIO 47} \
CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
CONFIG.PCW_SD1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_SD1_SD1_IO {<Select>} \
CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_UART0_UART0_IO {MIO 14 .. 15} \
CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J128M16 HA-125} \
CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
CONFIG.PCW_USE_S_AXI_HP0 {1} \
CONFIG.PCW_USE_S_AXI_HP1 {1} \
 ] $processing_system7_0

  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
  set_property -dict [ list \
CONFIG.NUM_MI {8} \
 ] $processing_system7_0_axi_periph

  # Create instance: rst_processing_system7_0_100M, and set properties
  set rst_processing_system7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_100M ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S01_AXI] [get_bd_intf_pins axi_mem_intercon/S01_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S00_AXI] [get_bd_intf_pins axi_mem_intercon/S00_AXI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins M00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins M05_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_mem_intercon/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
  connect_bd_intf_net -intf_net axi_mem_intercon_M01_AXI [get_bd_intf_pins axi_mem_intercon/M01_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP1]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_pins DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_pins FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_GPIO_0 [get_bd_intf_pins GPIO_0] [get_bd_intf_pins processing_system7_0/GPIO_0]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M01_AXI [get_bd_intf_pins M01_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M02_AXI [get_bd_intf_pins M02_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M03_AXI [get_bd_intf_pins M03_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M04_AXI [get_bd_intf_pins M04_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M04_AXI]

  # Create port connections
  connect_bd_net -net IRQ_F2P_1 [get_bd_pins IRQ_F2P] [get_bd_pins processing_system7_0/IRQ_F2P]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins FCLK_CLK0] [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_mem_intercon/M01_ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins axi_mem_intercon/S01_ACLK] [get_bd_pins axi_mem_intercon/S02_ACLK] [get_bd_pins axi_mem_intercon/S03_ACLK] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP1_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/M02_ACLK] [get_bd_pins processing_system7_0_axi_periph/M03_ACLK] [get_bd_pins processing_system7_0_axi_periph/M04_ACLK] [get_bd_pins processing_system7_0_axi_periph/M05_ACLK] [get_bd_pins processing_system7_0_axi_periph/M06_ACLK] [get_bd_pins processing_system7_0_axi_periph/M07_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins rst_processing_system7_0_100M/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins FCLK_CLK1] [get_bd_pins processing_system7_0/FCLK_CLK1]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_100M/ext_reset_in]
  connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins axi_mem_intercon/ARESETN] [get_bd_pins processing_system7_0_axi_periph/ARESETN] [get_bd_pins rst_processing_system7_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins S00_ARESETN] [get_bd_pins axi_mem_intercon/M00_ARESETN] [get_bd_pins axi_mem_intercon/M01_ARESETN] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins axi_mem_intercon/S01_ARESETN] [get_bd_pins axi_mem_intercon/S02_ARESETN] [get_bd_pins axi_mem_intercon/S03_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M02_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M03_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M04_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M05_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M06_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M07_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_processing_system7_0_100M/peripheral_aresetn]

  # Perform GUI Layout
  regenerate_bd_layout -hierarchy [get_bd_cells /system] -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port DDR -pg 1 -y 850 -defaultsOSRD
preplace port TMDS -pg 1 -y 170 -defaultsOSRD
preplace port HDMI_HPD -pg 1 -y 680 -defaultsOSRD
preplace port cmos_vsync_i -pg 1 -y 810 -defaultsOSRD
preplace port cmos_pclk_i -pg 1 -y 280 -defaultsOSRD
preplace port GPIO_0 -pg 1 -y 830 -defaultsOSRD
preplace port cmos_href_i -pg 1 -y 830 -defaultsOSRD
preplace port FIXED_IO -pg 1 -y 870 -defaultsOSRD
preplace portBus cmos_xclk_o -pg 1 -y 980 -defaultsOSRD -left
preplace portBus COMS_PWDN -pg 1 -y 460 -defaultsOSRD
preplace portBus cmos_data_i -pg 1 -y 870 -defaultsOSRD
preplace portBus COMS_reset -pg 1 -y 620 -defaultsOSRD
preplace portBus HDMI_OEN -pg 1 -y 540 -defaultsOSRD
preplace inst v_axi4s_vid_out_0 -pg 1 -lvl 2 -y 190 -defaultsOSRD
preplace inst axi_vdma_0 -pg 1 -lvl 2 -y 490 -defaultsOSRD
preplace inst v_tc_0 -pg 1 -lvl 1 -y 590 -defaultsOSRD
preplace inst OV_Sensor_cc_0 -pg 1 -lvl 1 -y 850 -defaultsOSRD
preplace inst xlconstant_0 -pg 1 -lvl 4 -y 540 -defaultsOSRD
preplace inst xlconstant_1 -pg 1 -lvl 3 -y 400 -defaultsOSRD
preplace inst xlconstant_2 -pg 1 -lvl 4 -y 460 -defaultsOSRD
preplace inst axi_gpio_0 -pg 1 -lvl 2 -y 680 -defaultsOSRD
preplace inst xlconstant_3 -pg 1 -lvl 4 -y 620 -defaultsOSRD
preplace inst rgb2dvi_0 -pg 1 -lvl 3 -y 170 -defaultsOSRD
preplace inst axis_subset_converter_0 -pg 1 -lvl 4 -y 360 -defaultsOSRD
preplace inst axi_dynclk_0 -pg 1 -lvl 2 -y 1160 -defaultsOSRD
preplace inst CLK_wiz -pg 1 -lvl 3 -y 510 -defaultsOSRD
preplace inst v_vid_in_axi4s_1 -pg 1 -lvl 1 -y 290 -defaultsOSRD
preplace inst system -pg 1 -lvl 2 -y 940 -defaultsOSRD
preplace netloc processing_system7_0_DDR 1 2 3 NJ 850 NJ 850 NJ
preplace netloc S_AXI_LITE_1 1 1 2 510 350 890
preplace netloc video_stream_M_AXI_MM2S 1 1 2 500 360 860
preplace netloc xlconstant_1_dout 1 3 1 NJ
preplace netloc cmos_href_i_1 1 0 1 NJ
preplace netloc system_M04_AXI 1 0 3 40 50 NJ 50 900
preplace netloc axi_dynclk_0_PXL_CLK_O 1 2 1 940
preplace netloc OV_Sensor_RGB565_0_vs_o 1 0 2 100 120 400
preplace netloc xlconstant_2_dout 1 4 1 NJ
preplace netloc clk_wiz_0_locked 1 0 4 50 70 510 30 NJ 30 1180
preplace netloc video_stream_M_AXI_S2MM 1 1 2 520 370 850
preplace netloc processing_system7_0_axi_periph_M03_AXI 1 1 2 530 750 870
preplace netloc video_stream_M_AXIS 1 1 4 520 10 NJ 10 NJ 10 1460
preplace netloc v_axi4s_vid_out_0_vid_io_out 1 2 1 N
preplace netloc video_stream_s2mm_introut 1 1 2 530 770 860
preplace netloc axi_dynclk_0_LOCKED_O 1 2 1 950
preplace netloc axi_vdma_0_M_AXIS_MM2S 1 2 2 930 340 NJ
preplace netloc OV_Sensor_RGB565_0_vid_clk_ce 1 0 2 110 130 420
preplace netloc util_vector_logic_0_Res 1 0 4 80 90 470 330 NJ 330 1170
preplace netloc OV_Sensor_ML_0_hs_o 1 0 2 90 100 430
preplace netloc S_AXI_CTRL_1 1 2 1 N
preplace netloc v_vid_in_axi4s_1_video_out 1 1 1 450
preplace netloc axi_dynclk_0_PXL_CLK_5X_O 1 2 1 960
preplace netloc rgb2dvi_0_TMDS 1 3 2 NJ 170 NJ
preplace netloc processing_system7_0_axi_periph_M02_AXI 1 1 2 510 760 850
preplace netloc cmos_pclk_i_1 1 0 1 20
preplace netloc rst_processing_system7_0_100M_peripheral_aresetn 1 0 3 120 720 490 610 970
preplace netloc v_axi4s_vid_out_0_vtg_ce 1 0 3 120 450 NJ 340 850
preplace netloc xlconstant_0_dout 1 4 1 NJ
preplace netloc processing_system7_0_FIXED_IO 1 2 3 NJ 870 NJ 870 NJ
preplace netloc OV_Sensor_cc_0_cmos_xclk_o 1 0 2 NJ 980 410
preplace netloc system_FCLK_CLK1 1 0 3 30 40 NJ 40 910
preplace netloc clk_wiz_0_clk_out1 1 0 4 70 80 500 20 NJ 20 1190
preplace netloc axi_gpio_0_GPIO 1 2 3 NJ 680 NJ 680 NJ
preplace netloc cmos_vsync_i_1 1 0 1 NJ
preplace netloc OV_Sensor_cc_0_rgb_o 1 0 2 120 110 440
preplace netloc processing_system7_0_GPIO_0 1 2 3 NJ 830 NJ 830 NJ
preplace netloc cmos_data_i_1 1 0 1 NJ
preplace netloc processing_system7_0_FCLK_CLK0 1 0 4 110 460 480 320 920 350 NJ
preplace netloc v_tc_0_vtiming_out 1 1 1 460
preplace netloc processing_system7_0_axi_periph_M01_AXI 1 0 3 60 60 NJ 60 880
preplace netloc xlconstant_3_dout 1 4 1 NJ
levelinfo -pg 1 0 260 690 1070 1330 1480 -top 0 -bot 1240
",
}

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: CLK_wiz
proc create_hier_cell_CLK_wiz { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_CLK_wiz() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 0 -to 0 Op1
  create_bd_pin -dir O -from 0 -to 0 Res
  create_bd_pin -dir I -type clk clk_in1
  create_bd_pin -dir O -type clk clk_out1
  create_bd_pin -dir I -from 0 -to 0 -type rst resetn

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.2 clk_wiz_0 ]
  set_property -dict [ list \
CONFIG.CLKOUT1_DRIVES {BUFG} \
CONFIG.CLKOUT1_JITTER {181.828} \
CONFIG.CLKOUT1_PHASE_ERROR {104.359} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {25} \
CONFIG.CLKOUT1_REQUESTED_PHASE {0} \
CONFIG.CLKOUT1_USED {true} \
CONFIG.CLKOUT2_DRIVES {BUFG} \
CONFIG.CLKOUT2_JITTER {200.764} \
CONFIG.CLKOUT2_PHASE_ERROR {98.575} \
CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {12.5} \
CONFIG.CLKOUT2_REQUESTED_PHASE {0} \
CONFIG.CLKOUT2_USED {false} \
CONFIG.CLKOUT3_DRIVES {BUFG} \
CONFIG.CLKOUT3_JITTER {151.636} \
CONFIG.CLKOUT3_PHASE_ERROR {98.575} \
CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {50} \
CONFIG.CLKOUT3_REQUESTED_PHASE {90.0} \
CONFIG.CLKOUT3_USED {false} \
CONFIG.CLKOUT4_DRIVES {BUFG} \
CONFIG.CLKOUT5_DRIVES {BUFG} \
CONFIG.CLKOUT6_DRIVES {BUFG} \
CONFIG.CLKOUT7_DRIVES {BUFG} \
CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
CONFIG.MMCM_CLKFBOUT_MULT_F {9.125} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {36.500} \
CONFIG.MMCM_CLKOUT0_PHASE {0.000} \
CONFIG.MMCM_CLKOUT1_DIVIDE {1} \
CONFIG.MMCM_CLKOUT1_PHASE {0.000} \
CONFIG.MMCM_CLKOUT2_DIVIDE {1} \
CONFIG.MMCM_CLKOUT2_PHASE {90.000} \
CONFIG.MMCM_COMPENSATION {ZHOLD} \
CONFIG.MMCM_DIVCLK_DIVIDE {1} \
CONFIG.NUM_OUT_CLKS {1} \
CONFIG.PRIMITIVE {MMCM} \
CONFIG.RESET_PORT {resetn} \
CONFIG.RESET_TYPE {ACTIVE_LOW} \
 ] $clk_wiz_0

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
CONFIG.C_OPERATION {not} \
CONFIG.C_SIZE {1} \
 ] $util_vector_logic_0

  # Create port connections
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_out1] [get_bd_pins clk_wiz_0/clk_out1]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins Op1] [get_bd_pins clk_wiz_0/locked] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins clk_in1] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins resetn] [get_bd_pins clk_wiz_0/resetn]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins Res] [get_bd_pins util_vector_logic_0/Res]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  set GPIO_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 GPIO_0 ]
  set HDMI_HPD [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 HDMI_HPD ]
  set TMDS [ create_bd_intf_port -mode Master -vlnv digilentinc.com:interface:tmds_rtl:1.0 TMDS ]

  # Create ports
  set COMS_PWDN [ create_bd_port -dir O -from 0 -to 0 COMS_PWDN ]
  set COMS_reset [ create_bd_port -dir O -from 0 -to 0 COMS_reset ]
  set HDMI_OEN [ create_bd_port -dir O -from 0 -to 0 HDMI_OEN ]
  set cmos_data_i [ create_bd_port -dir I -from 7 -to 0 cmos_data_i ]
  set cmos_href_i [ create_bd_port -dir I cmos_href_i ]
  set cmos_pclk_i [ create_bd_port -dir I cmos_pclk_i ]
  set cmos_vsync_i [ create_bd_port -dir I cmos_vsync_i ]
  set cmos_xclk_o [ create_bd_port -dir O -from 0 -to 0 cmos_xclk_o ]

  # Create instance: CLK_wiz
  create_hier_cell_CLK_wiz [current_bd_instance .] CLK_wiz

  # Create instance: OV_Sensor_cc_0, and set properties
  set OV_Sensor_cc_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:OV_Sensor_cc:1.0 OV_Sensor_cc_0 ]

  # Create instance: axi_dynclk_0, and set properties
  set axi_dynclk_0 [ create_bd_cell -type ip -vlnv digilentinc.com:ip:axi_dynclk:1.0 axi_dynclk_0 ]
  set_property -dict [ list \
CONFIG.ADD_BUFMR {false} \
 ] $axi_dynclk_0

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list \
CONFIG.C_ALL_INPUTS {1} \
CONFIG.C_GPIO_WIDTH {1} \
CONFIG.C_INTERRUPT_PRESENT {0} \
 ] $axi_gpio_0

  # Create instance: axi_vdma_0, and set properties
  set axi_vdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.2 axi_vdma_0 ]
  set_property -dict [ list \
CONFIG.c_include_mm2s {1} \
CONFIG.c_include_mm2s_dre {0} \
CONFIG.c_include_s2mm {1} \
CONFIG.c_include_s2mm_dre {0} \
CONFIG.c_m_axi_mm2s_data_width {64} \
CONFIG.c_m_axis_mm2s_tdata_width {24} \
CONFIG.c_mm2s_genlock_mode {3} \
CONFIG.c_mm2s_linebuffer_depth {512} \
CONFIG.c_mm2s_max_burst_length {32} \
CONFIG.c_num_fstores {3} \
CONFIG.c_s2mm_genlock_mode {2} \
CONFIG.c_s2mm_linebuffer_depth {1024} \
CONFIG.c_s2mm_max_burst_length {32} \
CONFIG.c_use_mm2s_fsync {0} \
CONFIG.c_use_s2mm_fsync {2} \
 ] $axi_vdma_0

  # Create instance: axis_subset_converter_0, and set properties
  set axis_subset_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_0 ]
  set_property -dict [ list \
CONFIG.M_HAS_TKEEP {1} \
CONFIG.M_HAS_TLAST {1} \
CONFIG.M_TDATA_NUM_BYTES {3} \
CONFIG.M_TUSER_WIDTH {1} \
CONFIG.S_HAS_TKEEP {1} \
CONFIG.S_HAS_TLAST {1} \
CONFIG.S_TDATA_NUM_BYTES {3} \
CONFIG.S_TUSER_WIDTH {1} \
CONFIG.TDATA_REMAP {tdata[23:16],tdata[7:0],tdata[15:8]} \
CONFIG.TKEEP_REMAP {tkeep[2:0]} \
CONFIG.TLAST_REMAP {tlast[0]} \
CONFIG.TUSER_REMAP {tuser[0:0]} \
 ] $axis_subset_converter_0

  # Create instance: rgb2dvi_0, and set properties
  set rgb2dvi_0 [ create_bd_cell -type ip -vlnv digilentinc.com:ip:rgb2dvi:1.2 rgb2dvi_0 ]
  set_property -dict [ list \
CONFIG.kClkRange {2} \
CONFIG.kGenerateSerialClk {false} \
CONFIG.kRstActiveHigh {false} \
 ] $rgb2dvi_0

  # Create instance: system
  create_hier_cell_system_1 [current_bd_instance .] system

  # Create instance: v_axi4s_vid_out_0, and set properties
  set v_axi4s_vid_out_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_axi4s_vid_out:4.0 v_axi4s_vid_out_0 ]
  set_property -dict [ list \
CONFIG.C_ADDR_WIDTH {12} \
CONFIG.C_HAS_ASYNC_CLK {1} \
CONFIG.C_NATIVE_COMPONENT_WIDTH {8} \
CONFIG.C_PIXELS_PER_CLOCK {1} \
CONFIG.C_S_AXIS_VIDEO_DATA_WIDTH {8} \
CONFIG.C_S_AXIS_VIDEO_FORMAT {2} \
CONFIG.C_VTG_MASTER_SLAVE {0} \
 ] $v_axi4s_vid_out_0

  # Create instance: v_tc_0, and set properties
  set v_tc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tc:6.1 v_tc_0 ]
  set_property -dict [ list \
CONFIG.GEN_F0_VBLANK_HEND {640} \
CONFIG.GEN_F0_VBLANK_HSTART {640} \
CONFIG.GEN_F0_VFRAME_SIZE {525} \
CONFIG.GEN_F0_VSYNC_HEND {640} \
CONFIG.GEN_F0_VSYNC_HSTART {640} \
CONFIG.GEN_F0_VSYNC_VEND {491} \
CONFIG.GEN_F0_VSYNC_VSTART {489} \
CONFIG.GEN_F1_VBLANK_HEND {640} \
CONFIG.GEN_F1_VBLANK_HSTART {640} \
CONFIG.GEN_F1_VFRAME_SIZE {525} \
CONFIG.GEN_F1_VSYNC_HEND {640} \
CONFIG.GEN_F1_VSYNC_HSTART {640} \
CONFIG.GEN_F1_VSYNC_VEND {491} \
CONFIG.GEN_F1_VSYNC_VSTART {489} \
CONFIG.GEN_HACTIVE_SIZE {640} \
CONFIG.GEN_HFRAME_SIZE {800} \
CONFIG.GEN_HSYNC_END {752} \
CONFIG.GEN_HSYNC_START {656} \
CONFIG.GEN_VACTIVE_SIZE {480} \
CONFIG.HAS_AXI4_LITE {true} \
CONFIG.HAS_INTC_IF {false} \
CONFIG.INTERLACE_EN {false} \
CONFIG.VIDEO_MODE {640x480p} \
CONFIG.enable_detection {false} \
CONFIG.frame_syncs {1} \
CONFIG.max_clocks_per_line {4096} \
CONFIG.max_lines_per_frame {4096} \
 ] $v_tc_0

  # Create instance: v_vid_in_axi4s_1, and set properties
  set v_vid_in_axi4s_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_vid_in_axi4s:4.0 v_vid_in_axi4s_1 ]
  set_property -dict [ list \
CONFIG.C_HAS_ASYNC_CLK {1} \
CONFIG.C_M_AXIS_VIDEO_DATA_WIDTH {8} \
CONFIG.C_M_AXIS_VIDEO_FORMAT {2} \
CONFIG.C_PIXELS_PER_CLOCK {1} \
 ] $v_vid_in_axi4s_1

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {0} \
 ] $xlconstant_2

  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXI_LITE_1 [get_bd_intf_pins axi_vdma_0/S_AXI_LITE] [get_bd_intf_pins system/M00_AXI]
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO [get_bd_intf_ports HDMI_HPD] [get_bd_intf_pins axi_gpio_0/GPIO]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXIS_MM2S [get_bd_intf_pins axi_vdma_0/M_AXIS_MM2S] [get_bd_intf_pins axis_subset_converter_0/S_AXIS]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins system/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins system/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_GPIO_0 [get_bd_intf_ports GPIO_0] [get_bd_intf_pins system/GPIO_0]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M01_AXI [get_bd_intf_pins system/M01_AXI] [get_bd_intf_pins v_tc_0/ctrl]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M02_AXI [get_bd_intf_pins axi_dynclk_0/s00_axi] [get_bd_intf_pins system/M02_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M03_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins system/M03_AXI]
  connect_bd_intf_net -intf_net rgb2dvi_0_TMDS [get_bd_intf_ports TMDS] [get_bd_intf_pins rgb2dvi_0/TMDS]
  connect_bd_intf_net -intf_net system_M04_AXI [get_bd_intf_pins OV_Sensor_cc_0/S00_AXI] [get_bd_intf_pins system/M04_AXI]
  connect_bd_intf_net -intf_net v_axi4s_vid_out_0_vid_io_out [get_bd_intf_pins rgb2dvi_0/RGB] [get_bd_intf_pins v_axi4s_vid_out_0/vid_io_out]
  connect_bd_intf_net -intf_net v_tc_0_vtiming_out [get_bd_intf_pins v_axi4s_vid_out_0/vtiming_in] [get_bd_intf_pins v_tc_0/vtiming_out]
  connect_bd_intf_net -intf_net v_vid_in_axi4s_1_video_out [get_bd_intf_pins axi_vdma_0/S_AXIS_S2MM] [get_bd_intf_pins v_vid_in_axi4s_1/video_out]
  connect_bd_intf_net -intf_net video_stream_M_AXIS [get_bd_intf_pins axis_subset_converter_0/M_AXIS] [get_bd_intf_pins v_axi4s_vid_out_0/video_in]
  connect_bd_intf_net -intf_net video_stream_M_AXI_MM2S [get_bd_intf_pins axi_vdma_0/M_AXI_MM2S] [get_bd_intf_pins system/S00_AXI]
  connect_bd_intf_net -intf_net video_stream_M_AXI_S2MM [get_bd_intf_pins axi_vdma_0/M_AXI_S2MM] [get_bd_intf_pins system/S01_AXI]

  # Create port connections
  connect_bd_net -net OV_Sensor_ML_0_hs_o [get_bd_pins OV_Sensor_cc_0/hs_o] [get_bd_pins v_vid_in_axi4s_1/vid_active_video] [get_bd_pins v_vid_in_axi4s_1/vid_hsync]
  connect_bd_net -net OV_Sensor_RGB565_0_vid_clk_ce [get_bd_pins OV_Sensor_cc_0/vid_clk_ce] [get_bd_pins v_vid_in_axi4s_1/vid_io_in_ce]
  connect_bd_net -net OV_Sensor_RGB565_0_vs_o [get_bd_pins OV_Sensor_cc_0/vs_o] [get_bd_pins v_vid_in_axi4s_1/vid_vsync]
  connect_bd_net -net OV_Sensor_cc_0_cmos_xclk_o [get_bd_ports cmos_xclk_o] [get_bd_pins OV_Sensor_cc_0/cmos_xclk_o]
  connect_bd_net -net OV_Sensor_cc_0_rgb_o [get_bd_pins OV_Sensor_cc_0/rgb_o] [get_bd_pins v_vid_in_axi4s_1/vid_data]
  connect_bd_net -net axi_dynclk_0_LOCKED_O [get_bd_pins axi_dynclk_0/LOCKED_O] [get_bd_pins rgb2dvi_0/aRst_n]
  connect_bd_net -net axi_dynclk_0_PXL_CLK_5X_O [get_bd_pins axi_dynclk_0/PXL_CLK_5X_O] [get_bd_pins rgb2dvi_0/SerialClk]
  connect_bd_net -net axi_dynclk_0_PXL_CLK_O [get_bd_pins axi_dynclk_0/PXL_CLK_O] [get_bd_pins rgb2dvi_0/PixelClk]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins CLK_wiz/clk_out1] [get_bd_pins v_axi4s_vid_out_0/vid_io_out_clk] [get_bd_pins v_tc_0/clk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins CLK_wiz/Op1] [get_bd_pins v_axi4s_vid_out_0/aclken] [get_bd_pins v_axi4s_vid_out_0/aresetn] [get_bd_pins v_axi4s_vid_out_0/vid_io_out_ce] [get_bd_pins v_tc_0/clken] [get_bd_pins v_tc_0/resetn] [get_bd_pins v_vid_in_axi4s_1/aclken] [get_bd_pins v_vid_in_axi4s_1/aresetn] [get_bd_pins v_vid_in_axi4s_1/axis_enable]
  connect_bd_net -net cmos_data_i_1 [get_bd_ports cmos_data_i] [get_bd_pins OV_Sensor_cc_0/cmos_data_i]
  connect_bd_net -net cmos_href_i_1 [get_bd_ports cmos_href_i] [get_bd_pins OV_Sensor_cc_0/cmos_href_i]
  connect_bd_net -net cmos_pclk_i_1 [get_bd_ports cmos_pclk_i] [get_bd_pins OV_Sensor_cc_0/cmos_pclk_i] [get_bd_pins v_vid_in_axi4s_1/vid_io_in_clk]
  connect_bd_net -net cmos_vsync_i_1 [get_bd_ports cmos_vsync_i] [get_bd_pins OV_Sensor_cc_0/cmos_vsync_i]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins CLK_wiz/clk_in1] [get_bd_pins OV_Sensor_cc_0/mul_clk] [get_bd_pins OV_Sensor_cc_0/s00_axi_aclk] [get_bd_pins axi_dynclk_0/REF_CLK_I] [get_bd_pins axi_dynclk_0/s00_axi_aclk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_vdma_0/m_axi_mm2s_aclk] [get_bd_pins axi_vdma_0/m_axi_s2mm_aclk] [get_bd_pins axi_vdma_0/m_axis_mm2s_aclk] [get_bd_pins axi_vdma_0/s_axi_lite_aclk] [get_bd_pins axi_vdma_0/s_axis_s2mm_aclk] [get_bd_pins axis_subset_converter_0/aclk] [get_bd_pins system/FCLK_CLK0] [get_bd_pins v_axi4s_vid_out_0/aclk] [get_bd_pins v_tc_0/s_axi_aclk] [get_bd_pins v_vid_in_axi4s_1/aclk]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins CLK_wiz/resetn] [get_bd_pins OV_Sensor_cc_0/s00_axi_aresetn] [get_bd_pins axi_dynclk_0/s00_axi_aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_vdma_0/axi_resetn] [get_bd_pins system/S00_ARESETN] [get_bd_pins v_tc_0/s_axi_aresetn]
  connect_bd_net -net system_FCLK_CLK1 [get_bd_pins OV_Sensor_cc_0/OV_CLK_i] [get_bd_pins system/FCLK_CLK1]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins CLK_wiz/Res] [get_bd_pins v_axi4s_vid_out_0/vid_io_out_reset] [get_bd_pins v_vid_in_axi4s_1/vid_io_in_reset]
  connect_bd_net -net v_axi4s_vid_out_0_vtg_ce [get_bd_pins v_axi4s_vid_out_0/vtg_ce] [get_bd_pins v_tc_0/gen_clken]
  connect_bd_net -net video_stream_s2mm_introut [get_bd_pins axi_vdma_0/s2mm_introut] [get_bd_pins system/IRQ_F2P]
  connect_bd_net -net xlconstant_0_dout [get_bd_ports HDMI_OEN] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins axis_subset_converter_0/aresetn] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_ports COMS_PWDN] [get_bd_pins xlconstant_2/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_ports COMS_reset] [get_bd_pins xlconstant_3/dout]

  # Create address segments
  create_bd_addr_seg -range 0x10000000 -offset 0x0 [get_bd_addr_spaces axi_vdma_0/Data_MM2S] [get_bd_addr_segs system/processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x10000000 -offset 0x0 [get_bd_addr_spaces axi_vdma_0/Data_S2MM] [get_bd_addr_segs system/processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x10000000 -offset 0x10000000 [get_bd_addr_spaces axi_vdma_0/Data_MM2S] [get_bd_addr_segs system/processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x10000000 -offset 0x10000000 [get_bd_addr_spaces axi_vdma_0/Data_S2MM] [get_bd_addr_segs system/processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x10000 -offset 0x43C20000 [get_bd_addr_spaces system/processing_system7_0/Data] [get_bd_addr_segs OV_Sensor_cc_0/S00_AXI/S00_AXI_reg] SEG_OV_Sensor_cc_0_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C10000 [get_bd_addr_spaces system/processing_system7_0/Data] [get_bd_addr_segs axi_dynclk_0/s00_axi/reg0] SEG_axi_dynclk_0_reg0
  create_bd_addr_seg -range 0x10000 -offset 0x41200000 [get_bd_addr_spaces system/processing_system7_0/Data] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] SEG_axi_gpio_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43000000 [get_bd_addr_spaces system/processing_system7_0/Data] [get_bd_addr_segs axi_vdma_0/S_AXI_LITE/Reg] SEG_axi_vdma_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C00000 [get_bd_addr_spaces system/processing_system7_0/Data] [get_bd_addr_segs v_tc_0/ctrl/Reg] SEG_v_tc_0_Reg

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   DisplayPinAutomationMissing: "1",
   DisplayTieOff: "1",
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port DDR -pg 1 -y 1250 -defaultsOSRD
preplace port TMDS -pg 1 -y 530 -defaultsOSRD
preplace port HDMI_HPD -pg 1 -y 900 -defaultsOSRD
preplace port cmos_vsync_i -pg 1 -y 1100 -defaultsOSRD
preplace port cmos_pclk_i -pg 1 -y 1140 -defaultsOSRD
preplace port GPIO_0 -pg 1 -y 1230 -defaultsOSRD
preplace port cmos_href_i -pg 1 -y 1120 -defaultsOSRD
preplace port FIXED_IO -pg 1 -y 1270 -defaultsOSRD
preplace portBus cmos_xclk_o -pg 1 -y 1370 -defaultsOSRD -left
preplace portBus COMS_PWDN -pg 1 -y 260 -defaultsOSRD
preplace portBus cmos_data_i -pg 1 -y 1160 -defaultsOSRD
preplace portBus COMS_reset -pg 1 -y 420 -defaultsOSRD
preplace portBus HDMI_OEN -pg 1 -y 340 -defaultsOSRD
preplace inst v_axi4s_vid_out_0 -pg 1 -lvl 5 -y 550 -defaultsOSRD
preplace inst axi_vdma_0 -pg 1 -lvl 4 -y 630 -defaultsOSRD
preplace inst v_tc_0 -pg 1 -lvl 3 -y 510 -defaultsOSRD
preplace inst axis_switch_0 -pg 1 -lvl 3 -y 1000 -defaultsOSRD
preplace inst OV_Sensor_cc_0 -pg 1 -lvl 1 -y 1140 -defaultsOSRD
preplace inst rst_processing_system7_0_100M -pg 1 -lvl 1 -y 420 -defaultsOSRD
preplace inst xlconstant_0 -pg 1 -lvl 6 -y 340 -defaultsOSRD
preplace inst xlconstant_1 -pg 1 -lvl 4 -y 780 -defaultsOSRD
preplace inst xlconstant_2 -pg 1 -lvl 6 -y 260 -defaultsOSRD
preplace inst xlconstant_3 -pg 1 -lvl 6 -y 420 -defaultsOSRD
preplace inst util_vector_logic_0 -pg 1 -lvl 1 -y 540 -defaultsOSRD
preplace inst axi_gpio_0 -pg 1 -lvl 4 -y 900 -defaultsOSRD
preplace inst rgb2dvi_0 -pg 1 -lvl 6 -y 530 -defaultsOSRD
preplace inst axis_subset_converter_0 -pg 1 -lvl 5 -y 340 -defaultsOSRD
preplace inst axi_dynclk_0 -pg 1 -lvl 4 -y 1030 -defaultsOSRD
preplace inst v_vid_in_axi4s_1 -pg 1 -lvl 2 -y 150 -defaultsOSRD
preplace inst v_vid_in_axi4s_2 -pg 1 -lvl 2 -y 490 -defaultsOSRD
preplace inst clk_wiz_0 -pg 1 -lvl 1 -y 1310 -defaultsOSRD
preplace inst axi_mem_intercon -pg 1 -lvl 1 -y 800 -defaultsOSRD
preplace inst processing_system7_0_axi_periph -pg 1 -lvl 2 -y 920 -defaultsOSRD
preplace inst processing_system7_0 -pg 1 -lvl 3 -y 1300 -defaultsOSRD
preplace netloc axis_switch_0_M00_AXIS 1 3 1 1350
preplace netloc processing_system7_0_DDR 1 3 4 NJ 1250 NJ 1250 NJ 1250 NJ
preplace netloc axi_mem_intercon_M01_AXI 1 1 2 480 1290 NJ
preplace netloc cmos_href_i_1 1 0 1 NJ
preplace netloc xlconstant_1_dout 1 4 1 NJ
preplace netloc axis_subset_converter_0_M_AXIS 1 4 2 1790 270 2050
preplace netloc OV_Sensor_RGB565_0_vs_o 1 1 1 470
preplace netloc axi_vdma_0_s2mm_introut 1 2 3 920 830 NJ 830 1690
preplace netloc xlconstant_2_dout 1 6 1 NJ
preplace netloc axi_dynclk_0_PXL_CLK_O 1 4 2 1750 420 NJ
preplace netloc clk_wiz_0_locked 1 0 5 30 300 520 1310 860 640 NJ 500 1730
preplace netloc processing_system7_0_axi_periph_M00_AXI 1 2 2 880 660 NJ
preplace netloc processing_system7_0_axi_periph_M03_AXI 1 2 2 900 880 NJ
preplace netloc OV_Sensor_cc_0_YUV_data 1 1 1 530
preplace netloc axi_vdma_0_M_AXI_MM2S 1 0 5 40 310 NJ 310 NJ 310 NJ 310 1700
preplace netloc processing_system7_0_M_AXI_GP0 1 1 3 540 1190 NJ 1180 1300
preplace netloc v_axi4s_vid_out_0_vid_io_out 1 5 1 N
preplace netloc axi_dynclk_0_LOCKED_O 1 4 2 1780 680 NJ
preplace netloc processing_system7_0_axi_periph_M05_AXI 1 2 1 840
preplace netloc axi_vdma_0_M_AXIS_MM2S 1 4 1 1720
preplace netloc OV_Sensor_RGB565_0_vid_clk_ce 1 1 1 500
preplace netloc util_vector_logic_0_Res 1 1 4 420 650 NJ 650 NJ 510 NJ
preplace netloc OV_Sensor_ML_0_hs_o 1 1 1 440
preplace netloc processing_system7_0_FCLK_RESET0_N 1 0 4 100 330 NJ 330 NJ 330 1310
preplace netloc v_vid_in_axi4s_1_video_out 1 2 1 910
preplace netloc axi_mem_intercon_M00_AXI 1 1 2 490 1270 NJ
preplace netloc axi_dynclk_0_PXL_CLK_5X_O 1 4 2 1790 690 NJ
preplace netloc rgb2dvi_0_TMDS 1 6 1 NJ
preplace netloc processing_system7_0_axi_periph_M02_AXI 1 2 2 NJ 890 1360
preplace netloc cmos_pclk_i_1 1 0 2 20 290 540
preplace netloc rst_processing_system7_0_100M_peripheral_aresetn 1 0 4 80 1410 460 1180 890 780 1370
preplace netloc v_axi4s_vid_out_0_vtg_ce 1 2 4 920 380 NJ 380 NJ 410 2050
preplace netloc xlconstant_0_dout 1 6 1 NJ
preplace netloc v_vid_in_axi4s_2_video_out 1 2 1 830
preplace netloc processing_system7_0_FIXED_IO 1 3 4 NJ 1270 NJ 1270 NJ 1270 NJ
preplace netloc OV_Sensor_cc_0_cmos_xclk_o 1 0 2 NJ 1370 420
preplace netloc clk_wiz_0_clk_out1 1 1 4 NJ 1300 850 370 NJ 370 1760
preplace netloc axi_gpio_0_GPIO 1 4 3 NJ 900 NJ 900 NJ
preplace netloc cmos_vsync_i_1 1 0 1 NJ
preplace netloc OV_Sensor_cc_0_rgb_o 1 1 1 450
preplace netloc processing_system7_0_GPIO_0 1 3 4 NJ 1230 NJ 1230 NJ 1230 NJ
preplace netloc cmos_data_i_1 1 0 1 NJ
preplace netloc rst_processing_system7_0_100M_interconnect_aresetn 1 0 2 70 1400 430
preplace netloc processing_system7_0_FCLK_CLK0 1 0 5 60 1390 510 660 870 770 1340 300 1780
preplace netloc v_tc_0_vtiming_out 1 3 2 NJ 490 N
preplace netloc axi_vdma_0_M_AXI_S2MM 1 0 5 50 320 NJ 320 NJ 320 NJ 320 1690
preplace netloc processing_system7_0_FCLK_CLK1 1 0 4 90 1420 NJ 1420 NJ 1420 1300
preplace netloc processing_system7_0_axi_periph_M04_AXI 1 0 3 100 1380 NJ 1380 820
preplace netloc processing_system7_0_axi_periph_M01_AXI 1 2 1 820
preplace netloc xlconstant_3_dout 1 6 1 NJ
levelinfo -pg 1 0 260 680 1110 1530 1920 2170 2290 -top 0 -bot 1430
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


