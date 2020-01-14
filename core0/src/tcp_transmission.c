/*
 * tcp_transmission.c
 *
 * Created on: 2016Äê11ÔÂ22ÈÕ
 * www.osrc.cn
 * www.milinker.com
 * copyright by nan jin mi lian dian zi www.osrc.cn
*/


#include <stdio.h>
#include <string.h>
#include "timer_intr.h"
#include "lwip/err.h"
#include "lwip/tcp.h"
#include "lwipopts.h"
//#include "lwip/tcp_impl.h"
#include "netif/xadapter.h"
#include "xil_cache.h"
#include "xil_printf.h"
#include "xil_exception.h"
#include "xscugic.h"
#include "sleep.h"
#include "tcp_transmission.h"
#include "software_intr.h"
#include "shared_mem.h"


#define DATA_BASE_ADDR		0x10000000
#define BUFFER_BASE_ADDR	0x11000000
#define SHARED_BASE_ADDR	0x08000000
#define SEND_SIZE (1460)


extern XScuGic Intc; //GIC
extern enum ethernet_link_status eth_link_status;
struct tcp_pcb *connected_pcb = NULL;
struct tcp_pcb *send_pcb= NULL;
volatile unsigned tcp_client_connected = 0;

static unsigned local_port = 5010;	/* server port */
volatile unsigned server_running = 0;

u8 *file;
u8 *data_buffer;
shared_region *region;
extern struct netif *netif;

err_t tcp_recv_callback(void *arg, struct tcp_pcb *tpcb, struct pbuf *p, err_t err)
{
	struct pbuf *q;
	u32 remain_length;
	u32 file_length;
//
//	q = p;
//
//	/* close socket if the peer has sent the FIN packet  */
//    if (p == NULL) {
//        tcp_close(tpcb);
//        xil_printf("tcp connection closed\r\n");
//        return ERR_OK;
//    }
//
//	/*if received ip fragment packets*/
//	if(q->tot_len > q->len)
//	{
//		remain_length = q->tot_len;
//		file_length = 0;
//		while(remain_length > 0)
//		{
//			memcpy(file + file_length, q->payload, q->len);
//
//			file_length += q->len;
//			remain_length -= q->len;
//			/*go to next pbuf pointer*/
//			q = q->next;
//		}
//	}
//	/*if received no ip fragment packets*/
//	else
//	{
//		memcpy(file, q->payload, q->len);
//	}
//
//	//xil_printf("tcp data come in!%d, %d\r\n", p->tot_len, p->len);
//	//memset(data_buffer, 0, 100);
//	/*put the data to the shared memory*/
//    //put_data_to_region(file, data_buffer, p->tot_len, region);
//	/* tell lwip we've received the tcp packet */
//	tcp_recved(tpcb, p->tot_len);
//	pbuf_free(p);
//
//	/* generate software interrupt to the other core */
//	if(XPAR_CPU_ID == 0)
//		Gen_Software_Intr(&Intc, CORE0_TO_CORE1_INTR_ID, XSCUGIC_SPI_CPU1_MASK);
//	else
//		Gen_Software_Intr(&Intc, CORE1_TO_CORE0_INTR_ID, XSCUGIC_SPI_CPU0_MASK);

    return ERR_OK;
}

/*we just do not need this fuction to do anything */
err_t tcp_sent_callback(void *arg, struct tcp_pcb *tpcb, u16_t len)
{
	//tcp_trans_done ++;
	//xil_printf("tcp send done\r\n");
	return ERR_OK;
}

err_t connect_accept_callback(void *arg, struct tcp_pcb *newpcb, err_t err)
{
    xil_printf("core%d: tcp_server: Connection Accepted\r\n", XPAR_CPU_ID);
	/* store state */
	connected_pcb = newpcb;

    tcp_recv(newpcb, tcp_recv_callback);
    tcp_sent(newpcb, tcp_sent_callback);
    //tcp_client_connected = 1;
    return ERR_OK;
}


static err_t
tcp_connected_callback(void *arg, struct tcp_pcb *tpcb, err_t err)
{
	xil_printf("txperf: Connected to iperf server\r\n");

	/* store state */
	connected_pcb = tpcb;

	/* set callback values & functions */
	tcp_arg(tpcb, NULL);
	tcp_sent(tpcb, tcp_sent_callback);

	tcp_client_connected = 1;

	/* initiate data transfer */
	return ERR_OK;
}

int tcp_recv_init(ip_addr_t *lo_ipaddr)
{
	static struct tcp_pcb *pcb;
	err_t err;

//    file = (u8 *)DATA_BASE_ADDR;
//    data_buffer = (u8 *)BUFFER_BASE_ADDR;
//	region = (shared_region *)SHARED_BASE_ADDR;

    /* create new TCP PCB structure */
    pcb = tcp_new();
    if (!pcb) {
    	xil_printf("tcp_server: Error creating PCB. Out of Memory\r\n");
    	return -1;
    }

    /* bind to local port */
    err = tcp_bind(pcb, lo_ipaddr, local_port);
    if (err != ERR_OK) {
    	xil_printf("tcp_server: Unable to bind to port %d: err = %d\r\n", local_port, err);
    	return -2;
    }

    /* we do not need any arguments to callback functions :) */
    tcp_arg(pcb, NULL);

    /* listen for connections */
    pcb = tcp_listen(pcb);
    if (!pcb) {
    	xil_printf("tcp_server: Out of memory while tcp_listen\r\n");
    	return -3;
    }

    /* specify callback to use for incoming connections */
    tcp_accept(pcb, connect_accept_callback);

    server_running = 1;

    return 0;
}

int tcp_send_init(struct tcp_pcb *pcb)
{

	ip_addr_t ipaddr;
	err_t err;
	u16_t port;

	/* create new TCP PCB structure */
	if(pcb ==NULL)
	{
		pcb = tcp_new();
		if (!pcb) {
			xil_printf("txperf: Error creating PCB. Out of Memory\r\n");
			return -1;
		}
	}

	/* connect to iperf tcp server */
	IP4_ADDR(&ipaddr,  192, 168,   1, 11);		/* iperf server address */

	port = local_port+1;					/* iperf default port */

    tcp_client_connected = 0;
//    first_trans_start = 0;
//    packet_trans_done = 0;
//    packet_index = 0;
    pcb->local_port = local_port;
	err = tcp_connect(pcb, &ipaddr, port, tcp_connected_callback);
	if (err != ERR_OK) {
		xil_printf("txperf: tcp_connect returned error: %d\r\n", err);
		return err;
	}


	return 0;
}


extern struct netif *netif;

void tcp_printf( void *addr,u32 len)
{

	u32 length;
	err_t err;
	struct tcp_pcb *tpcb = connected_pcb;

#if __arm__
	int copy = 3;
#else
	int copy = 0;
#endif

	if (!tpcb)
	{
		xil_printf("error return\r\n");
		return;
	}
	length = len;

	while(length>0)
	{
		if(!tcp_client_connected )
		{
			return;
		}
		if(length > SEND_SIZE )
		{
			if (tcp_sndbuf(tpcb) > SEND_SIZE)
			{
				/*transmit received data through TCP*/
				err = tcp_write(tpcb, addr, SEND_SIZE, copy);
				if (err != ERR_OK) {
					xil_printf("tcp_server: Error on tcp_write: %d\r\n", err);
					tpcb = NULL;
					continue;
				}
				err = tcp_output(tpcb);
				if (err != ERR_OK) {
					xil_printf("tcp_server: Error on tcp_output: %d\r\n",err);
					continue;
				}
				length -= SEND_SIZE ;
				addr += SEND_SIZE;
				//xemacif_input(netif);

			}
		}
		else if(length)
		{
			if (tcp_sndbuf(tpcb) > length)
			{
				/*transmit received data through TCP*/
				err = tcp_write(tpcb, addr, length, copy);
				if (err != ERR_OK) {
					xil_printf("tcp_server: Error on tcp_write: %d\r\n", err);
					tpcb = NULL;
					continue;
				}
				err = tcp_output(tpcb);
				if (err != ERR_OK) {
					xil_printf("tcp_server: Error on tcp_output: %d\r\n",err);
					continue;
				}
				length =0;
				//xemacif_input(netif);
				//return;
			}
		}
		tcp_output(tpcb);
		xemacif_input(netif);
//		eth_link_detect(netif);



	}

}


//void send_received_data()
//{
//#if __arm__
//	int copy = 3;
//#else
//	int copy = 0;
//#endif
//	err_t err;
//
//	struct tcp_pcb *tpcb = connected_pcb;
//
//
//
//	/*if the last axidma transmission is done, the interrupt triggered, then start TCP transmission*/
//
//
//	if (!connected_pcb)
//		return;
//
//	/* if tcp send buffer has enough space to hold the data we want to transmit from PL, then start tcp transmission*/
//	if (tcp_sndbuf(tpcb) > SEND_SIZE)
//	{
//		/*transmit received data through TCP*/
//		err = tcp_write(tpcb,((shared_region *)SHARED_BASE_ADDR)->dataload, SEND_SIZE, copy);
//		if (err != ERR_OK) {
//			xil_printf("txperf: Error on tcp_write: %d\r\n", err);
//			connected_pcb = NULL;
//			return;
//		}
//		err = tcp_output(tpcb);
//		if (err != ERR_OK) {
//			xil_printf("txperf: Error on tcp_output: %d\r\n",err);
//			return;
//		}
//
//		((shared_region *)SHARED_BASE_ADDR)->data_length = ((shared_region *)SHARED_BASE_ADDR)->data_length  - SEND_SIZE ;
//
//	}
//
//}
