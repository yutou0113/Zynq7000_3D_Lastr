/*
 * shared_mem.h
 *
 *  Created on: 2017Äê2ÔÂ7ÈÕ
 * www.osrc.cn
 * www.milinker.com
 * copyright by nan jin mi lian dian zi www.osrc.cn
*/

#ifndef SHARED_MEM_H_
#define SHARED_MEM_H_

#include "xil_types.h"
#include "xil_cache.h"
#include "string.h"

#define FRAME_LENGHT		921600 //680*480*3
#define FRAME_BUF_MAX		2

typedef struct
{
	u32 data_length;
	u8* dataload;
}shared_region;


void get_data_from_region(u8 *buffer,  shared_region *p);
void put_data_to_region(u8 *src_buffer, u8 *dst_buffer, u32 length, shared_region *p);

#endif /* SHARED_MEM_H_ */
