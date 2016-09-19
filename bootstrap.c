#define GPACON (*((volatile unsigned int*)0x56000000))
#define GPADAT (*((volatile unsigned int*)0x56000004))

#define GPBCON (*((volatile unsigned int*)0x56000010))
#define GPBDAT (*((volatile unsigned int*)0x56000014))
#define GPBUDP (*((volatile unsigned int*)0x56000018))


static inline void delay (unsigned long loops)  
{  
    __asm__ volatile ("1:\n"  
        "subs %0, %1, #1\n"  
        "bne 1b":"=r" (loops):"0" (loops));  
} 


void led_init(void)
{
	GPACON = 0x0fffffff;
	GPACON &= ~(3 << 23);

	GPADAT |= (3 << 23);
}

void mdelay(unsigned int count)
{
	unsigned int tm = count;
	
	while(tm--);
}

void led_display(void)
{
	GPADAT |= (3 << 23);
	mdelay(1000000);
	GPADAT &= ~(3 << 23);
	mdelay(1000000);
}

void beep_init(void)
{
	GPBCON = 0x0;
	GPBCON |= (1 << 0);//GPB0
	GPBCON |= (1 << 10);//GPB5
	
	GPBUDP = 0x0;
	GPBUDP |= (1 << 1);
	GPBUDP |= (1 << 11);

	GPBDAT |= (1 << 5); //close LED1
}


void beep_on_off(void)
{
	GPBDAT |= (1 << 5); //beep Beep
//	delay(4000000);
	mdelay(4000000);
	GPBDAT &= ~(1 << 5); //close Beep
//	delay(4000000);
	mdelay(4000000);
}


int main(int argc, char *argv[])
{
	beep_init();

	led_init();

	while(1){
		beep_on_off();
	}

	return 0;
}

