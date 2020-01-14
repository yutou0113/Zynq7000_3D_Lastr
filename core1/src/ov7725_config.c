/*
 * ov7725_config.c
 *
 *  Created on: 2016Äê10ÔÂ22ÈÕ
 *      Author: Administrator
 */
#include"sleep.h"
#include"i2c_ctr.h"

#define CAM_OV7725     0x42

void ov7725_init_rgb(void)
{
	sccb_senddata(0x12,0x80);		// BIT[7]-Reset all the Reg
	usleep(1000);

	  //Bingo Init REV
  	//Write Data Index
    sccb_senddata(0x1c, 0x7f);
    sccb_senddata(0x1d, 0xa2);

  	sccb_senddata(0x3d, 0x0B);	//DC offset for analog process
  	sccb_senddata(0x15, 0x00);	//COM10: href/vsync/pclk/data reverse(Vsync H valid)
  	sccb_senddata(0x17, 0x24);	//VGA:	0x22;	QVGA:	0x3f;
  	sccb_senddata(0x18, 0xa3);	//VGA:	0xa4;	QVGA:	0x50;
  	sccb_senddata(0x19, 0x07);	//VGA:	0x07;	QVGA:	0x03;
  	sccb_senddata(0x1a, 0xf0);	//VGA:	0xf0;	QVGA:	0x78;
  	sccb_senddata(0x32, 0x00);	//Bit[7]:Mirror image edge alignment
  	sccb_senddata(0x29, 0xA0);	//VGA:	0xA0;	QVGA:	0xF0
  	sccb_senddata(0x2C, 0xF6);	//VGA:	0xF0;	QVGA:	0x78
  	sccb_senddata(0x0d, 0x71);	//PLL 8x
  	//sccb_senddata(0x2a, 0x00);	//PLL 4x
  	sccb_senddata(0x11, 0x00);	//CLKRC,Finternal clock = Finput clk*PLL multiplier/[(CLKRC[5:0]+1)*2] = 25MHz*4/[(x+1)*2]
  															//00: 50fps, 01:25fps, 03:12.5fps	(50Hz Fliter)
  	sccb_senddata(0x12, 0x06);	//BIT[6]:	0:VGA; 1;QVGA
  															//VGA:	00:YUV; 01:Processed Bayer RGB; 10:RGB;	11:Bayer RAW; BIT[7]-Reset all the Reg
  	sccb_senddata(0x0c, 0x10);	//COM3: Bit[6]:Horizontal mirror image ON/OFF, Bit[0]:Color bar; Default:0x10
  	//DSP control
  	sccb_senddata(0x42, 0x7f);	//BLC Blue Channel Target Value, Default: 0x80
  	sccb_senddata(0x4d, 0x09);	//BLC Red Channel Target Value, Default: 0x80
  	sccb_senddata(0x63, 0xf0);	//AWB Control
  	sccb_senddata(0x64, 0xff);	//DSP_Ctrl1:
  	sccb_senddata(0x65, 0x00);	//DSP_Ctrl2:
  	sccb_senddata(0x66, 0x00);	//{COM3[4](0x0C), DSP_Ctrl3[7]}:00:YUYV;	01:YVYU;	[10:UYVY]	11:VYUY
  	sccb_senddata(0x67, 0x00);	//DSP_Ctrl4:[1:0]00/01: YUV or RGB; 10: RAW8; 11: RAW10

    //AGC AEC AWB
  	sccb_senddata(0x13, 0xff);
  	sccb_senddata(0x0f, 0xc5);
  	sccb_senddata(0x14, 0x11);
  	sccb_senddata(0x22, 0x98);	//Banding Filt er Minimum AEC Value; Default: 0x09
  	sccb_senddata(0x23, 0x03);	//Banding Filter Maximum Step
  	sccb_senddata(0x24, 0x40);	//AGC/AEC - Stable Operating Region (Upper Limit)
  	sccb_senddata(0x25, 0x30);	//AGC/AEC - Stable Operating Region (Lower Limit)
  	sccb_senddata(0x26, 0xa1);	//AGC/AEC Fast Mode Operating Region
  	sccb_senddata(0x2b, 0x9e);	//TaiWan: 0x00:60Hz Filter; Mainland: 0x9e:50Hz Filter
  	sccb_senddata(0x6b, 0xaa);	//AWB Control 3
  	sccb_senddata(0x13, 0xff);	//0xff: AGC AEC AWB Enable; 0xf0: AGC AEC AWB Disable;


  	//sccb_senddata(0x0d, 0x41); //20141206

  	//matrix sharpness brightness contrast UV
  	sccb_senddata(0x90, 0x0a);
  	sccb_senddata(0x91, 0x01);
  	sccb_senddata(0x92, 0x01);
  	sccb_senddata(0x93, 0x01);
  	sccb_senddata(0x94, 0x5f);
  	sccb_senddata(0x95, 0x53);
  	sccb_senddata(0x96, 0x11);
  	sccb_senddata(0x97, 0x1a);
  	sccb_senddata(0x98, 0x3d);
  	sccb_senddata(0x99, 0x5a);
  	sccb_senddata(0x9a, 0x1e);
  	sccb_senddata(0x9b, 0x07);	//Brightness
  	sccb_senddata(0x9c, 0x25);
  	sccb_senddata(0x9e, 0x81);
  	sccb_senddata(0xa6, 0x06);
  	sccb_senddata(0xa7, 0x65);
  	sccb_senddata(0xa8, 0x65);
  	sccb_senddata(0xa9, 0x80);
  	sccb_senddata(0xaa, 0x80);

  	//Gamma correction
  	sccb_senddata(0x7e, 0x0c);
  	sccb_senddata(0x7f, 0x16);	//
  	sccb_senddata(0x80, 0x2a);
  	sccb_senddata(0x81, 0x4e);
  	sccb_senddata(0x82, 0x61);
  	sccb_senddata(0x83, 0x6f);
  	sccb_senddata(0x84, 0x7b);
  	sccb_senddata(0x85, 0x86);
  	sccb_senddata(0x86, 0x8e);
  	sccb_senddata(0x87, 0x97);
  	sccb_senddata(0x88, 0xa4);
  	sccb_senddata(0x89, 0xaf);
  	sccb_senddata(0x8a, 0xc5);
  	sccb_senddata(0x8b, 0xd7);
  	sccb_senddata(0x8c, 0xe8);
  	sccb_senddata(0x8d, 0x20);
  	//sccb_senddata(0x1c, 0x7f);//20141206
  	sccb_senddata(0x0e, 0x65);//20141206
}

