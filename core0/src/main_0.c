
/*
 *
 * www.osrc.cn
 * www.milinker.com
 * copyright by nan jin mi lian dian zi www.osrc.cn
 *
 *
*/


#include "timer_intr.h"
#include "stdbool.h"
#include "sys_intr.h"
//#include "lwip/err.h"
#include "lwip/tcp.h"
//#include "lwip/tcp_impl.h"
#include "lwipopts.h"
#include "netif/xadapter.h"
#include "lwipopts.h"
#include "xil_cache.h"
#include "xparameters.h"
#include "tcp_transmission.h"
#include "software_intr.h"
#include "shared_mem.h"
#include "xil_mmu.h"
#include "xil_misc_psreset_api.h"

XScuGic Intc; //GIC
static  XScuTimer Timer;//timer



#define BUFFER_BASE_ADDR	0x13000000
#define SHARED_BASE_ADDR	0x08000000

#define QSPI_DEVICE_ID		XPAR_XQSPIPS_0_DEVICE_ID
#define TIMER_LOAD_VALUE    XPAR_CPU_CORTEXA9_0_CPU_CLK_FREQ_HZ / 8

#define CPU1_CATCH			0x00000024   //entry of code start address of core1's application, defined in asm_vectors.s in fsbl bsp's standalone
#define APP_CPU1_ADDR	    0x02000000   //code start address of core1's application
#define A9_CPU_RST_CTRL		(XSLCR_BASEADDR + 0x244)
#define A9_RST1_MASK 		0x00000002
#define A9_CLKSTOP1_MASK	0x00000020

#define XSLCR_LOCK_ADDR		(XSLCR_BASEADDR + 0x4)
#define XSLCR_LOCK_CODE		0x0000767B


extern enum ethernet_link_status eth_link_status;
extern struct tcp_pcb *connected_pcb;
extern struct tcp_pcb *send_pcb;
volatile bool software_intr_conter = 0,ethernet_send_conter=0;
volatile u8 new_flag=0;
const char Fream_star[]={"Fream_sync"};
extern void lwip_init(void);

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

static void Start_cpu1()
{
   	u32 RegVal;

    //Disable cache on OCM
    Xil_SetTlbAttributes(0xFFFF0000,0x14de2);           // S=b1 TEX=b100 AP=b11, Domain=b1111, C=b0, B=b0

    //Disable cache on fsbl vector table location
    Xil_SetTlbAttributes(0x00000000,0x14de2);           // S=b1 TEX=b100 AP=b11, Domain=b1111, C=b0, B=b0

	/*
	 *  Reset and start CPU1
	 *  - Application for cpu1 exists at 0x00000000 per cpu1 linkerscript
	 *
	 */

	/*
	 * Setup cpu1 catch address with starting address of app_cpu1. The FSBL initialized the vector table at 0x00000000
	 * using a boot.S that checks for cpu number and jumps to the address stored at the
	 * end of the vector table in cpu0_catch and cpu1_catch entries.
	 * Note: Cache has been disabled at the beginning of main(). Otherwise
	 * a cache flush would have to be issued after this write
	 */
	Xil_Out32(CPU1_CATCH, APP_CPU1_ADDR);

	/* Unlock the slcr register access lock */
	Xil_Out32(XSLCR_UNLOCK_ADDR, XSLCR_UNLOCK_CODE);

	//    the user must stop the associated clock, de-assert the reset, and then restart the clock. During a
	//    system or POR reset, hardware automatically takes care of this. Therefore, a CPU cannot run the code
	//    that applies the software reset to itself. This reset needs to be applied by the other CPU or through
	//    JTAG or PL. Assuming the user wants to reset CPU1, the user must to set the following fields in the
	//    slcr.A9_CPU_RST_CTRL (address 0xF8000244) register in the order listed:
	//    1. A9_RST1 = 1 to assert reset to CPU1
	//    2. A9_CLKSTOP1 = 1 to stop clock to CPU1
	//    3. A9_RST1 = 0 to release reset to CPU1
	//    4. A9_CLKSTOP1 = 0 to restart clock to CPU1

	/* Assert and deassert cpu1 reset and clkstop using above sequence*/
	RegVal = 	Xil_In32(A9_CPU_RST_CTRL);
	RegVal |= A9_RST1_MASK;
	Xil_Out32(A9_CPU_RST_CTRL, RegVal);
	RegVal |= A9_CLKSTOP1_MASK;
	Xil_Out32(A9_CPU_RST_CTRL, RegVal);
	RegVal &= ~A9_RST1_MASK;
	Xil_Out32(A9_CPU_RST_CTRL, RegVal);
	RegVal &= ~A9_CLKSTOP1_MASK;
	Xil_Out32(A9_CPU_RST_CTRL, RegVal);

	/* lock the slcr register access */
	Xil_Out32(XSLCR_LOCK_ADDR, XSLCR_LOCK_CODE);
}

struct netif *netif;
shared_region *region,send_region[10];
u8 FRAME_BUF[FRAME_BUF_MAX][FRAME_LENGHT];

int main(void)
{
	unsigned int regval=0,i;
	static struct netif  server_netif;
	ip_addr_t ipaddr, netmask, gw;

	/* the mac address of the board. this should be unique per board */
	unsigned char mac_ethernet_address[] = { 0x00, 0x0a, 0x35, 0x00, 0x01, 0x02 };


	region= (shared_region *)SHARED_BASE_ADDR;
	//region->dataload = (u8 *)BUFFER_BASE_ADDR;//just give it a default addr, nothing

	memset(FRAME_BUF,0,FRAME_BUF_MAX*FRAME_LENGHT);

	for(i=0;i<FRAME_BUF_MAX;i++)
	{
		send_region[i].dataload =FRAME_BUF[i];
		send_region[i].data_length = FRAME_LENGHT;
	}


	init_intr_sys();
	TcpTmrFlag = 0;

	netif = &server_netif;

	IP4_ADDR(&ipaddr,  192, 168,   1,  10);
	IP4_ADDR(&netmask, 255, 255, 255,  0);
	IP4_ADDR(&gw,      192, 168,   1,  1);

	/*lwip library init*/
	lwip_init();
	/* Add network interface to the netif_list, and set it as default */
	if (!xemac_add(netif, &ipaddr, &netmask, &gw, mac_ethernet_address, XPAR_XEMACPS_0_BASEADDR)) {
		xil_printf("Error adding N/W interface\r\n");
		return -1;
	}
	netif_set_default(netif);

	/* specify that the network if is up */
	netif_set_up(netif);

	/* initialize tcp pcb */
	tcp_recv_init(&ipaddr);

	tcp_send_init(connected_pcb);


	Timer_start(&Timer);


	/*
	 * NOTE:
	 * Do comment Start_cpu1() if you want to debug
	 * Never comment Start_cpu1() if you want to create BOOT.bin
	 */
	Start_cpu1();

	regval = XScuGic_ReadReg(0xF8F0183C, 0x00);
	XScuGic_WriteReg(0xF8F0183C, 0x00, regval | 0x00000300);//cahnge int61 to share cpu0 and cpu1


	xil_printf("core%d: application start\r\n", XPAR_CPU_ID);





	while (1)
	{

		if(tcp_client_connected )
		{

			if(new_flag)
			{
				tcp_printf(&Fream_star,10);
				tcp_printf(send_region[0].dataload,region->data_length);

	//			if(ethernet_send_conter >= FRAME_BUF_MAX-1)ethernet_send_conter=0;
	//			else ethernet_send_conter++;
	//
	//			if(ethernet_send_conter != software_intr_conter)
	//			{
	//				xil_printf("OF:%d\r\n", software_intr_conter - ethernet_send_conter);
	//			}
				new_flag --;
			}


		}
//		else if((eth_link_status!=ETH_LINK_UP) ||(!(tcp_client_connected)) )
//		{
//			if(send_pcb)
//			{
//				tcp_free(send_pcb);
//			}
//			tcp_send_init(send_pcb);
//
//		}
//		else
//		{
//			Gen_Software_Intr(&Intc, CORE0_TO_CORE1_INTR_ID, XSCUGIC_SPI_CPU1_MASK);
//		}
		if(TcpTmrFlag>=2 && (tcp_client_connected))
		{
			//tcp_tmr();
			TcpTmrFlag = 0;
			Gen_Software_Intr(&Intc, CORE0_TO_CORE1_INTR_ID, XSCUGIC_SPI_CPU1_MASK);


		}

		xemacif_input(netif);

	}
	return 0;

}


