/*
 * emio_initial.c
 *
 *  Created on: 2016��10��22��
 *      Author: Administrator
 */

#include"emio_initial.h"

static XGpioPs psGpioInstancePtr;

int Miz702_EMIO_init()
{
	XGpioPs_Config* GpioConfigPtr;
	int xStatus;
	//--MIO �ĳ�ʼ��
	GpioConfigPtr = XGpioPs_LookupConfig(XPAR_PS7_GPIO_0_DEVICE_ID);
	if(GpioConfigPtr == NULL)
	return XST_FAILURE;

	xStatus = XGpioPs_CfgInitialize(&psGpioInstancePtr,GpioConfigPtr,GpioConfigPtr->BaseAddr);
	if(XST_SUCCESS != xStatus)
	print(" PS GPIO INIT FAILED \n\r");

	XGpioPs_SetDirectionPin(&psGpioInstancePtr, SCL_PIN,DIRECTION_OUTPUT);//
	XGpioPs_SetDirectionPin(&psGpioInstancePtr, SDA_PIN,DIRECTION_OUTPUT);//

	XGpioPs_SetOutputEnablePin(&psGpioInstancePtr, SCL_PIN,1);//
	XGpioPs_SetOutputEnablePin(&psGpioInstancePtr, SDA_PIN,1);//


//	GpioConfigPtr = XGpioPs_LookupConfig(XPAR_AXI_GPIO_1_DEVICE_ID);
//	if(GpioConfigPtr == NULL)
//	return XST_FAILURE;
//
//	xStatus = XGpioPs_CfgInitialize(&psGpioInstancePtr,GpioConfigPtr,GpioConfigPtr->BaseAddr);
//	if(XST_SUCCESS != xStatus)
//	print(" PS GPIO INIT FAILED \n\r");
//
//	//--MIO �������������
//
//	XGpioPs_SetDirectionPin(&psGpioInstancePtr, OV_CLK_EN_PIN,DIRECTION_OUTPUT);//
//
//	XGpioPs_SetOutputEnablePin(&psGpioInstancePtr, OV_CLK_EN_PIN,1);//




	return xStatus;
}

void CLOCK_HIGH(void)
{
	XGpioPs_WritePin(&psGpioInstancePtr,SCL_PIN, 1);
}

void CLOCK_LOW(void)
{
	XGpioPs_WritePin(&psGpioInstancePtr,SCL_PIN, 0);
}

void DATA_HIGH(void)
{
	XGpioPs_WritePin(&psGpioInstancePtr,SDA_PIN, 1);
}

void DATA_LOW(void)
{
	XGpioPs_WritePin(&psGpioInstancePtr,SDA_PIN,0);
}


void OV_CLK_EN(void)
{
	XGpioPs_WritePin(&psGpioInstancePtr,OV_CLK_EN_PIN, 1);
}

void OV_CLK_DIS(void)
{
	XGpioPs_WritePin(&psGpioInstancePtr,OV_CLK_EN_PIN,0);
}

