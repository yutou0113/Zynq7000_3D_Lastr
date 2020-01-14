
`timescale 1 ns / 1 ps

	module OV_Sensor_cc_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 4
	)
	(
		// Users to add ports here
        input       OV_CLK_i,
		input        cmos_vsync_i,    //cmos vsync
		input        cmos_href_i,    //cmos hsync refrence
		input        cmos_pclk_i,    //cmos pxiel clock
		output        cmos_xclk_o,    //cmos externl clock
		input[7:0]    cmos_data_i,    //cmos data
		output hs_o,//hs signal.
		output vs_o,//vs signal.
       // output de_o,//data enable.
		output [23:0] rgb_o,//data output,
		output vid_clk_ce,
		
		input wire mul_clk,
		//input wire [23:0]RGB_data,
		output wire [23:0]yuv_o,
		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready
	);
// Instantiation of Axi Bus Interface S00_AXI
	OV_Sensor_cc_v1_0_S00_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) OV_Sensor_cc_v1_0_S00_AXI_inst (
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready),
		
		.cmos_xclk_o(cmos_xclk_o),
		.cmos_clk_i(OV_CLK_i),
		.MUL_CLK(mul_clk),
		.RGB_data(rgb_o),
		.YUV_data(yuv_o)
	);

	// Add user logic here
 	 //----------------------视频输出解码模块---------------------------//
	   wire  [15:0]rgb_o_r;
	   assign rgb_o = {rgb_o_r[15:11],3'd0 ,rgb_o_r[10:5]     ,2'd0,rgb_o_r[4:0]   ,3'd0};
	   	
	   reg [7:0]cmos_data_r;
	   reg cmos_href_r;
	   reg cmos_vsync_r;
	   
	   always@(posedge cmos_pclk_i)
	   begin
	      cmos_data_r <= cmos_data_i;
	      cmos_href_r <= cmos_href_i;
	      cmos_vsync_r<= cmos_vsync_i;
	   end 
	   //assign rgb_o = 24'b11111111_00000000_11111111;
	   cmos_decode cmos_decode_u0(
	       //system signal.
	       .cmos_clk_i(OV_CLK_i),//cmos senseor clock.
	       .rst_n_i(RESETn_i2c),//system reset.active low.
	       //cmos sensor hardware interface.
	       .cmos_pclk_i(cmos_pclk_i),//(cmos_pclk),//input pixel clock.
	       .cmos_href_i(cmos_href_r),//(cmos_href),//input pixel hs signal.
	       .cmos_vsync_i(cmos_vsync_r),//(cmos_vsync),//input pixel vs signal.
	       .cmos_data_i(cmos_data_r),//(cmos_data),//data.
	      // .cmos_xclk_o(cmos_xclk_o),//(cmos_xclk),//output clock to cmos sensor.
	       //user interface.
	       .hs_o(hs_o),//hs signal.
	       .vs_o(vs_o),//vs signal.
	   //	.de_o(de_o),//data enable.
	       .rgb565_o(rgb_o_r),//data output
	       .vid_clk_ce(vid_clk_ce)
	       );
	   
	   count_reset_v1#(.num(20'hffff0)
	       )(
	           .clk_i(OV_CLK_i),
	           .rst_o(RESETn_i2c)
	       );    
	// User logic ends

	endmodule
