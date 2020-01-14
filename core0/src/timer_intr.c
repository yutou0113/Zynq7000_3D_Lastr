/*
 *
 * www.osrc.cn
 * www.milinker.com
 * copyright by nan jin mi lian dian zi www.osrc.cn
*/

#include "timer_intr.h"
#include "tcp_transmission.h"
//#include "lwip/tcp_impl.h"
extern struct netif *netif;
extern struct tcp_pcb *send_pcb;
extern enum ethernet_link_status eth_link_status;
volatile int TcpTmrFlag;


static void TimerIntrHandler(void *CallBackRef)
{

    XScuTimer *TimerInstancePtr = (XScuTimer *) CallBackRef;
    XScuTimer_ClearInterruptStatus(TimerInstancePtr);
    /* call tcp timer every 250ms */
    tcp_tmr();
	TcpTmrFlag ++;
	xemacif_input(netif);//��MAC�������packets���䵽���LwIP/IP stack��
	//isrDone++;
	if(TcpTmrFlag>=10)
	{
		tcp_client_connected = 0;
		xil_printf("Ethernet Link Status Error,Retry to LinkUp!\r\n");
		//tcp_tmr();
		TcpTmrFlag = 0;
		tcp_send_init(send_pcb);

	}




}
void Timer_start(XScuTimer *TimerPtr)
{
	    XScuTimer_Start(TimerPtr);
}

void Timer_Setup_Intr_System(XScuGic *GicInstancePtr,XScuTimer *TimerInstancePtr, u16 TimerIntrId)
{
        XScuGic_Connect(GicInstancePtr, TimerIntrId,
                        (Xil_ExceptionHandler)TimerIntrHandler,//set up the timer interrupt
                        (void *)TimerInstancePtr);

        XScuGic_Enable(GicInstancePtr, TimerIntrId);//enable the interrupt for the Timer at GIC
        XScuTimer_EnableInterrupt(TimerInstancePtr);//enable interrupt on the timer
 }

int Timer_init(XScuTimer *TimerPtr,u32 Load_Value,u32 DeviceId)
{
     XScuTimer_Config *TMRConfigPtr;     //timer config
     //˽�ж�ʱ����ʼ��
     TMRConfigPtr = XScuTimer_LookupConfig(DeviceId);
     XScuTimer_CfgInitialize(TimerPtr, TMRConfigPtr,TMRConfigPtr->BaseAddr);
     //XScuTimer_SelfTest(&Timer);
     //���ؼ������ڣ�˽�ж�ʱ����ʱ��ΪCPU��һ�룬Ϊ333MHZ,�������1S,����ֵΪ1sx(333x1000x1000)(1/s)-1=0x13D92D3F
     XScuTimer_LoadTimer(TimerPtr, Load_Value);//F8F00600+0=reg=F8F00600
     //�Զ�װ��
     XScuTimer_EnableAutoReload(TimerPtr);//F8F00600+8=reg=F8F00608

     return 1;
}
