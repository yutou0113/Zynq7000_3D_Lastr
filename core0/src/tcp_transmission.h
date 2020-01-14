/*
 * tcp_transmission.h
 *
 * Created on: 2017Äê1ÔÂ25ÈÕ
 * www.osrc.cn
 * www.milinker.com
 * copyright by nan jin mi lian dian zi www.osrc.cn
*/

#ifndef TCP_TRANSMISSION_H_
#define TCP_TRANSMISSION_H_

#include "lwip/err.h"
#include "lwip/ip_addr.h"
#include "lwip/tcp.h"
#include "lwipopts.h"
#include "netif/xadapter.h"
#include "shared_mem.h"

extern volatile unsigned tcp_client_connected ;
extern void send_received_data();

err_t connect_accept_callback(void *arg, struct tcp_pcb *newpcb, err_t err);
err_t tcp_sent_callback(void *arg, struct tcp_pcb *tpcb, u16_t len);
err_t tcp_recv_callback(void *arg, struct tcp_pcb *tpcb, struct pbuf *p, err_t err);
int tcp_recv_init(ip_addr_t *lo_ipaddr);
int tcp_send_init(struct tcp_pcb *pcb);
void tcp_printf(void *addr,u32 len);

#endif /* TCP_TRANSMISSION_H_ */
