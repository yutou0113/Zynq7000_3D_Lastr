/*
 * main.h
 *
 *  Created on: 2019Äê8ÔÂ18ÈÕ
 *      Author: Administrator
 */

#ifndef MAIN_H_
#define MAIN_H_

#include "string.h"

#define sev() __asm__("sev")
#define CPU1STARTADR 0xFFFFFFF0
#define CPU1STARTMEM 0x10000000

#define Stream_switch0 		0
#define BUFFER_BASE_ADDR	0x11000000
#define SHARED_BASE_ADDR	0x08000000
#define CPU1_INT61_CTRL_REG 	0xF8F0183C
#define TIMER_LOAD_VALUE 	XPAR_CPU_CORTEXA9_0_CPU_CLK_FREQ_HZ / 2
#define VDMA_0_S2MM_INTROUT_INTR		61
#define VAL_REG XAxiVdma_ReadReg(XPAR_AXIVDMA_0_BASEADDR, 0x28)

#define DEMO_MAX_FRAME (640*480*3)
#define RESOLUTION 640*480
#define DICISOR    240
#define WRITE_READ_ADDR_OFFSET 		0//	1280*1024*3

#endif /* MAIN_H_ */
