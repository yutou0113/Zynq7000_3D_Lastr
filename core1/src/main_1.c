/*
 * main.c
 *
 *  Created on: 2017年2月7日
 * www.osrc.cn
 * www.milinker.com
 * copyright by nan jin mi lian dian zi www.osrc.cn
*/


#include "sys_intr.h"
#include "timer_intr.h"
#include "xil_cache.h"
#include "xparameters.h"
#include "software_intr.h"
#include "shared_mem.h"
#include "sleep.h"


/* ------------------------------------------------------------ */
/*				Include File Definitions						*/
/* ------------------------------------------------------------ */


#include "xgpio.h"
#include "display_demo.h"
#include "xscugic.h"
#include "emio_initial.h"
#include "display_ctrl.h"
#include <stdio.h>
#include "math.h"
#include <ctype.h>
#include <stdlib.h>
#include "xil_types.h"
#include "xil_cache.h"
#include "xparameters.h"
#include "sleep.h"
#include "sys_intr.h"
#include "ov7725_config.h"
#include "common.h"



static void VDMA_0_S2MM_Non_CallBack();
static void VDMA_0_S2MM_Err_CallBack();


/*
 * XPAR redefines
 */

//#define INTC_DEVICE_ID      XPAR_PS7_SCUGIC_0_DEVICE_ID





/* ------------------------------------------------------------ */
/*				Global Variables								*/
/* ------------------------------------------------------------ */

/*
 * Display Driver structs
 */
DisplayCtrl dispCtrl;
XAxiVdma vdma0,vdma1;
XScuGic Intc;
static  XScuTimer Timer;//timer



/*
 * Framebuffers for video data
 */
u8 frameBuf0[DISPLAY_NUM_FRAMES][DEMO_MAX_FRAME] __attribute__ ((aligned(64)));
u8 frameBuf1[DISPLAY_NUM_FRAMES][DEMO_MAX_FRAME] __attribute__ ((aligned(64)));
u8 *pFrames[DISPLAY_NUM_FRAMES]; //array of pointers to the frame buffers
u8 srcFramebuf[DEMO_MAX_FRAME];
u8 disFramebuf[DEMO_MAX_FRAME];
unsigned int S2MM_conter =0,S2MM_Err_conter= 0 ;




XScuGic Intc; //GIC

volatile u8 software_intr_received = 0,frame_vnsy=0;

shared_region *region;
u8 *data;

void init_intr_sys(void)
{
	Timer_init(&Timer,TIMER_LOAD_VALUE,0);
	
	Init_Intr_System(&Intc); // initial interrupt system
	
	Timer_Setup_Intr_System(&Intc,&Timer,TIMER_IRPT_INTR);

	/*initial software interrupt of local cpu*/
	if(XPAR_CPU_ID == 0)
		Init_Software_Intr(&Intc, Cpu0_Intr_Hanedler, CORE1_TO_CORE0_INTR_ID, 0);
	else
		Init_Software_Intr(&Intc, Cpu1_Intr_Hanedler, CORE0_TO_CORE1_INTR_ID, 1);


	Setup_Intr_Exception(&Intc);
}


int main(void)
{


	unsigned char Status;
	unsigned char r_buf[256*2]={0},g_buf[256*2]={0},b_buf[256*2]={0};
	unsigned char r_buf_index=0,g_buf_index=0,b_buf_index=0,divisor_limit=0; ;
	unsigned int regval=0,i=0,outdata_len=0;
	XScuGic_Config *IntcConfig;


	region = (shared_region *)SHARED_BASE_ADDR;
	data = (u8 *)BUFFER_BASE_ADDR;

	region->dataload = disFramebuf;

	init_intr_sys();

	Xil_ExceptionDisable();
	regval = XAxiVdma_ReadReg(CPU1_INT61_CTRL_REG, 0x00);
	XScuGic_WriteReg(CPU1_INT61_CTRL_REG, 0x00, regval | 0x00000300);//cahnge int61 to share cpu0 and cpu1


	/*
	 * Initialize an array of pointers to the 3 frame buffers
	 */
	for (i = 0; i < DISPLAY_NUM_FRAMES; i++)
	{
		pFrames[i] = (u8 *)&frameBuf0[i];
	}


	/*
	 * Initialize the Display controller and start it
	 */
	Status = DisplayInitialize(&dispCtrl, &vdma0, DISP_VTC_ID, DYNCLK_BASEADDR, pFrames, DEMO_STRIDE);
	if (Status != XST_SUCCESS)
	{
		xil_printf("Display Ctrl initialization failed during demo initialization%d\r\n", Status);

	}

	Status = DisplayStart(&dispCtrl);
	if (Status != XST_SUCCESS)
	{
		xil_printf("Couldn't start display during demo initialization%d\r\n", Status);

	}

	xil_printf("Starting the first vdma0 \n\r");

	XAxiVdma_WriteReg(XPAR_AXIVDMA_0_BASEADDR, 0x30, 0x04);//VDMA0 reset
	usleep(1000);

	Status = run_triple_frame_buffer(&vdma0, 0,640,480,(u32 *)pFrames[0], 1, 1);
	if (Status != XST_SUCCESS)
	{
		xil_printf("Transfer of frames failed with error = %d\r\n",Status);
		return XST_FAILURE;
	}
	else
	{
		xil_printf("VDMA0 Transfer of frames started \r\n");
	}

	IntcConfig = XScuGic_LookupConfig(INTC_DEVICE_ID);
	if (NULL == IntcConfig) return XST_FAILURE;

	Status = XScuGic_CfgInitialize(&Intc, IntcConfig, IntcConfig->CpuBaseAddress);
	if (Status != XST_SUCCESS) return XST_FAILURE;

	//XScuGic_SetPriorityTriggerType(&Intc, VDMA_0_S2MM_INTROUT_INTR, 0x08, 0x02);

	Status = XScuGic_Connect(&Intc, VDMA_0_S2MM_INTROUT_INTR,(Xil_InterruptHandler)XAxiVdma_WriteIntrHandler,&vdma0);
	if (Status != XST_SUCCESS) return XST_FAILURE;



	/* Register callback functions*/
	XAxiVdma_SetCallBack(&vdma0, XAXIVDMA_HANDLER_GENERAL, VDMA_0_S2MM_Non_CallBack, (void *)&vdma0, XAXIVDMA_WRITE);
	XAxiVdma_SetCallBack(&vdma0, XAXIVDMA_HANDLER_ERROR, VDMA_0_S2MM_Err_CallBack, (void *)&vdma0, XAXIVDMA_WRITE);
	XAxiVdma_IntrEnable(&vdma0, XAXIVDMA_IXR_FRMCNT_MASK, XAXIVDMA_WRITE);

	XScuGic_Enable(&Intc, VDMA_0_S2MM_INTROUT_INTR); /* enable the interrupt for the DMA device */
	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_IRQ_INT,(Xil_ExceptionHandler)XScuGic_InterruptHandler,&Intc);
	Xil_ExceptionEnable(); /* enable interrupt in the Processor */


	//start_switch(Stream_switch0,1);//video surce switch, ch0:rgb888   ch1:YUV444

	usleep(1000);
	//	Y = 0.299*R + 0.587*G + 0.114*B;  		Y = (77R + 150G + 29B) >> 8;
	//	U = -0.169*R - 0.331*G + 0.5 *B ;		U = (-43R - 85G + 128B)>> 8 + 128;
	//	V = 0.5 *R - 0.419*G - 0.081*B;			V = (128R - 107G - 21B)>> 8 + 128;

	//	R = Y + 1.4075 * V;						R = Y + (360*(V-128)) >> 8;
	//	G = Y - 0.3455 * U - 0.7169*V;			G = Y - (88*(U-128) + 184*(V-128))>>8;
	//	B = Y + 1.779 * U;						B = Y + 455*(U-128)>>8;
//	XScuGic_WriteReg(XPAR_OV_SENSOR_CC_0_S00_AXI_BASEADDR, 0x04, 0x004d961d);//KYrgb = 77,150,29
//	XScuGic_WriteReg(XPAR_OV_SENSOR_CC_0_S00_AXI_BASEADDR, 0x08, 0x002b5580);//KUrgb = 43,85,128
//	XScuGic_WriteReg(XPAR_OV_SENSOR_CC_0_S00_AXI_BASEADDR, 0x0C, 0x00806b15);//KVrgb = 128,107,21
	XScuGic_WriteReg(XPAR_OV_SENSOR_CC_0_S00_AXI_BASEADDR, 0x00, 0x00000002);//bit0:mul clear 						0:CLEAR 1:RUN
																			 //bit1: OV clk an clear YUV oupput		0:STOP	1:ENABLE AND YUV data valid
	usleep(1000);


	Miz702_EMIO_init();
	ov7725_init_rgb();

	xil_printf("TEST PASS\r\n");

	Timer_start(&Timer);

//	region->data_length = DEMO_MAX_FRAME;
//	region->dataload = data;

	regval = XAxiVdma_ReadReg(XPAR_AXIVDMA_0_BASEADDR, 0x34);
	if(regval & 0x00000010 )XAxiVdma_WriteReg(XPAR_AXIVDMA_0_BASEADDR, 0x34, 0x00011010);//clear VDMAIntErr

//	regval = XAxiVdma_ReadReg(CPU1_INT61_CTRL_REG, 0x00);
//	XScuGic_WriteReg(CPU1_INT61_CTRL_REG, 0x00, regval | 0x00000300);//cahnge int61 to share cpu0 and cpu1

	xil_printf("core%d: application start\r\n", XPAR_CPU_ID);

	while(1)
	{


		if(frame_vnsy )
		{

			r_buf[1] = srcFramebuf[0];
			g_buf[1] = srcFramebuf[1];
			b_buf[1] = srcFramebuf[2];

			for(i=0;i<RESOLUTION;i++)
			{

				//R
				if(r_buf[r_buf_index+1] == srcFramebuf[i+0])//值相同，数量加1，值不变
				{
					r_buf[r_buf_index] ++;//数量
				}
				else
				{
					r_buf_index+=2;//索引移动到下一个区域
					r_buf[r_buf_index] ++;//数量
					r_buf[r_buf_index+1] = srcFramebuf[i+3];//数值
				}

				//G
				if(g_buf[g_buf_index+1] == srcFramebuf[i+1])//值相同，数量加1，值不变
				{
					g_buf[g_buf_index] ++;//数量
				}
				else
				{
					g_buf_index+=2;//索引移动到下一个区域
					g_buf[g_buf_index] ++;//数量
					g_buf[g_buf_index+1] = srcFramebuf[i+4];//数值
				}

				//B
				if(b_buf[b_buf_index+1] == srcFramebuf[i+2])//值相同，数量加1，值不变
				{
					b_buf[b_buf_index] ++;//数量
				}
				else
				{
					b_buf_index+=2;//索引移动到下一个区域
					b_buf[b_buf_index] ++;//数量
					b_buf[b_buf_index+1] = srcFramebuf[i+5];//数值
				}

				divisor_limit ++;

				if(divisor_limit == DICISOR)
				{
					memcpy(disFramebuf+outdata_len,r_buf,(r_buf_index+1));
					outdata_len += (r_buf_index+1);
					memcpy(disFramebuf+outdata_len,g_buf,(g_buf_index+1));
					outdata_len += (g_buf_index+1);
					memcpy(disFramebuf+outdata_len,b_buf,(b_buf_index+1));
					outdata_len += (b_buf_index+1);
					divisor_limit=0;
					r_buf_index = g_buf_index = b_buf_index = 0;

				}


			}

			region->data_length = outdata_len;
			Xil_DCacheFlushRange((INTPTR)region, sizeof(shared_region));
			Xil_DCacheFlushRange((INTPTR)region->dataload, outdata_len);
			Gen_Software_Intr(&Intc, CORE1_TO_CORE0_INTR_ID, XSCUGIC_SPI_CPU0_MASK);
			outdata_len =0;
			frame_vnsy = 0;
			regval = XAxiVdma_ReadReg(XPAR_AXIVDMA_0_BASEADDR, 0x34);
			if(regval & 0x00000010 )XAxiVdma_WriteReg(XPAR_AXIVDMA_0_BASEADDR, 0x34, 0x00011010);//clear VDMAIntErr

			if(TcpTmrFlag)
			{
				xil_printf("%d,%d\r\n", S2MM_conter,S2MM_Err_conter);
				TcpTmrFlag = 0;
				S2MM_conter= 0;
				S2MM_Err_conter=0;
			}
		}


	}
}


void VDMA_0_S2MM_Non_CallBack()
{

	unsigned char Frm_num;
	Frm_num = ((XAxiVdma_ReadReg(XPAR_AXIVDMA_0_BASEADDR, 0x28)) >> 24) & 0x0F;
	//memcpy(disFramebuf,(*pFrames+WRITE_READ_ADDR_OFFSET)+Frm_num*DEMO_MAX_FRAME,DEMO_MAX_FRAME);//copy from DDR to buf

	if(software_intr_received)
	{
		//region->dataload = *pFrames+((VAL_REG>>24) & 0x0F)*DEMO_MAX_FRAME;
		//region->dataload = disFramebuf;
		memcpy(srcFramebuf,(*pFrames+WRITE_READ_ADDR_OFFSET)+Frm_num*DEMO_MAX_FRAME,DEMO_MAX_FRAME);//copy from DDR to buf

		S2MM_conter ++;

//	memcpy((*pFrames+(Frm_num*DEMO_MAX_FRAME)),disFramebuf,DEMO_MAX_FRAME);//write val to read addr
//	Xil_DCacheFlushRange((INTPTR)(*pFrames+(Frm_num*DEMO_MAX_FRAME)), DEMO_MAX_FRAME);

		frame_vnsy = 1;
	}
}


void VDMA_0_S2MM_Err_CallBack()
{

	unsigned int regval=0;
	regval = XAxiVdma_ReadReg(XPAR_AXIVDMA_0_BASEADDR, 0x34);
	if(regval & 0x00000010 )XAxiVdma_WriteReg(XPAR_AXIVDMA_0_BASEADDR, 0x34, 0x00011010);//clear VDMAIntErr
	S2MM_Err_conter ++;

}
