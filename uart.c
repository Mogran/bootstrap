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

void uart_tx_byte(unsigned char data)
{
	while(!(UTRSTAT0&0x2));
	UTXH0 = data;
}

void uart_tx_multiple_bytes(unsigned char *buf, int size)
{
	volatile int ssize = 0;

	for(ssize = 0; ssize < size; ssize++){
		uart_tx_byte(buf[ssize]);
	}
}
