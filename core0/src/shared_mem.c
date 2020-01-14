/*
 * shared_mem.c
 *
 *  Created on: 2017Äê2ÔÂ7ÈÕ
 * www.osrc.cn
 * www.milinker.com
 * copyright by nan jin mi lian dian zi www.osrc.cn
*/

#include "shared_mem.h"


void get_data_from_region(u8 *buffer,  shared_region *p)
{
	u32 length;
	u8* data_buffer;

	Xil_DCacheInvalidateRange((INTPTR)p, sizeof(shared_region));

	length = p->data_length;
	data_buffer = p->dataload;

	Xil_DCacheInvalidateRange((INTPTR)data_buffer, length);

	memcpy(buffer, data_buffer, length);

}

void put_data_to_region(u8 *src_buffer, u8 *dst_buffer, u32 length, shared_region *p)
{

	p->data_length =length;
	p->dataload = dst_buffer;

	memcpy(p->dataload, src_buffer, length);

	Xil_DCacheFlushRange((INTPTR)p, sizeof(shared_region));

	Xil_DCacheFlushRange((INTPTR)p->dataload, length);

}
