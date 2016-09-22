#include "bootstrap.h"

void uart_init(void)
{
	/* uart0 */
	GPHCON &= ~((3 << 2) | (3 << 0));
	GPHCON |= (2 << 2) |(2 << 0); 

	/* uart3 */
	GPHCON &= ~((3 << 14) | (3 << 12));
	GPHCON |= (2 << 14) |(2 << 12); 

	GPHUDP &= ~((3 << 2) | (3 << 0));
	GPHUDP |= (2 << 2) |(2 << 0); 

	GPHUDP &= ~((3 << 14) | (3 << 12));
	GPHUDP |= (2 << 14) |(2 << 12); 

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
		while(!(UTRSTAT0&0x2));
		UTXH0 = 0x55;
	}

	led_display();
}

