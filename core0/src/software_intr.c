/*
 * software_intr.c
 *
 * www.osrc.cn
 * www.milinker.com
 * copyright by nan jin mi lian dian zi www.osrc.cn
*/
#include "software_intr.h"
#include "shared_mem.h"
#include "xil_cache.h"
#include "stdbool.h"



extern bool software_intr_conter;
extern shared_region *region,send_region[10];
extern u8 new_flag;

void Cpu0_Intr_Hanedler(void *Callback)
{
	if(new_flag>1)
	{
		xil_printf("L(%d)\r\n",new_flag++);
		return;
	}
	new_flag ++;
	Xil_DCacheInvalidateRange((INTPTR)region, sizeof(shared_region));
	Xil_DCacheInvalidateRange((INTPTR)region->dataload, region->data_length);

	memcpy(send_region[0].dataload, region->dataload, region->data_length);
	send_region[0].data_length = region->data_length;


	software_intr_conter = !software_intr_conter;
}

void Cpu1_Intr_Hanedler(void *Callback)
{
	//xil_printf("core1: receive interrupt from core0!\r\n");
	//software_intr_conter = 1;
}

void Init_Software_Intr(XScuGic *GicInstancePtr, Xil_InterruptHandler IntrHanedler, u16 SoftwareIntrId, u8 CpuId)
{

	int Status;

	XScuGic_SetPriorityTriggerType(GicInstancePtr, SoftwareIntrId, 0xB0, 0x2);

	Status = XScuGic_Connect(GicInstancePtr, SoftwareIntrId,
				 (Xil_InterruptHandler)IntrHanedler, NULL);
	if (Status != XST_SUCCESS) {
		xil_printf("core%d: interrupt %d set fail!\r\n", XPAR_CPU_ID, SoftwareIntrId);
		return;
	}

	XScuGic_InterruptMaptoCpu(GicInstancePtr, CpuId, SoftwareIntrId); //map the the Software interrupt to target CPU

	XScuGic_Enable(GicInstancePtr, SoftwareIntrId);//enable the interrupt for the Software interrupt at GIC
 }


void Gen_Software_Intr(XScuGic *GicInstancePtr, u16 SoftwareIntrId, u32 CpuId)
{
	int Status;

	Status = XScuGic_SoftwareIntr(GicInstancePtr, SoftwareIntrId, CpuId);
	if (Status != XST_SUCCESS) {
		xil_printf("core%d: interrupt %d gen fail!\r\n", XPAR_CPU_ID, SoftwareIntrId);
		return;
	}
}

