#include "bootstrap.h"


void uart_init(void)
{
	GPHCON &= ~((3 << 2) | (3 << 0));
	GPHCON |= (2 << 2) |(2 << 0); 
	GPHUDP &= ~((3 << 2) | (3 << 0));
	GPHUDP |= (2 << 2) |(2 << 0); 

	ULCON0 = 0x3;
	UCON0  = 0x5;
	UMCON0 = 0x0;
	UFCON0 = 0x0;
	UBRDIV0 = 34;
	UDIVSLOT0 = 0xDFDD;
}

void uart_tx_byte(void)
{
	volatile int i = 0;

	for(i = 0; i < 6; i++){
		wait4txdone();
		UTXH0 = 0x55;
	}
}

