#include "bootstrap.h"

inline void delay (unsigned long loops)  
{  
    __asm__ volatile ("1:\n"  
        "subs %0, %1, #1\n"  
        "bne 1b":"=r" (loops):"0" (loops));  
} 

void mdelay(void)
{
	volatile unsigned int tm = 4000000; //local varible needs to vlolatile! 
	
	while(tm--);
}


void led_init(void)
{
	GPBCON = 0x0;
	GPBCON |= (1 << 6);//GPB3
	GPBCON |= (1 << 18);//GPB9
	
	GPBUDP = 0x0;
	GPBUDP |= (1 << 7);
	GPBUDP |= (1 << 19);
}


void led_display(void)
{
	GPBDAT |= (1 << 3); //led 1
	GPBDAT |= (1 << 9); //led 1
	delay(100000000);
	GPBDAT &= ~(1 << 3); //led 2
	GPBDAT &= ~(1 << 9); //led 2
	delay(100000000);
}


int main(int argc, char *argv[])
{
	volatile int ret = 0;
	unsigned char dat[100];

	led_init();
	uart_init();
	nand_init();

	nand_read_id();
	ret = nand_erase_one_block(3);
	if(ret == 0){
		nand_read_one_page(3, 0, dat, 10);
		uart_tx_multiple_bytes(dat, 10);	
	}


	while(1){
		led_display();
	}

	return 0;
}

