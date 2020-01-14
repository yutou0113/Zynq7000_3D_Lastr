/*
 * software_intr.h
 *
 *  Created on: 2017Äê2ÔÂ7ÈÕ
 * www.osrc.cn
 * www.milinker.com
 * copyright by nan jin mi lian dian zi www.osrc.cn
*/

#ifndef SOFTWARE_INTR_H_
#define SOFTWARE_INTR_H_

#include "xil_cache.h"
#include <stdio.h>
#include "xil_types.h"
#include "Xscugic.h"
#include "Xil_exception.h"
#include "xil_printf.h"
#include "xparameters.h"


#define CORE0_TO_CORE1_INTR_ID   0x01
#define CORE1_TO_CORE0_INTR_ID   0x02


void Cpu0_Intr_Hanedler(void *Callback);
void Cpu1_Intr_Hanedler(void *Callback);
void Init_Software_Intr(XScuGic *GicInstancePtr, Xil_InterruptHandler IntrHanedler, u16 SoftwareIntrId, u8 CpuId);
void Gen_Software_Intr(XScuGic *GicInstancePtr, u16 SoftwareIntrId, u32 CpuId);

#endif /* SOFTWARE_INTR_H_ */
