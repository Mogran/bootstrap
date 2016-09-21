#ifndef BOOTSTARP_H__
#define BOOTSTARP_H__

#define NFCONF      (*(volatile unsigned int*)0x4E000000)
#define NFCONT      (*(volatile unsigned int*)0x4E000004)

#define NFCMMD      (*(volatile unsigned char*)0x4E000008)
#define NFADDR      (*(volatile unsigned char*)0x4E00000c)
#define NFDATA      (*(volatile unsigned char*)0x4E000010)

#define NFMECCD0    (*(volatile unsigned int*)0x4E000014)
#define NFMECCD1    (*(volatile unsigned int*)0x4E000018)

#define NFSECCD     (*(volatile unsigned int*)0x4E00001C)

#define NFSBLK      (*(volatile unsigned int*)0x4E000020)
#define NFEBLK      (*(volatile unsigned int*)0x4E000024)

#define NFSTAT      (*(volatile unsigned int*)0x4E000028)

#define NFECCERR0   (*(volatile unsigned int*)0x4E00002C)
#define NFECCERR1   (*(volatile unsigned int*)0x4E000030)

#define NFMECC0     (*(volatile unsigned int*)0x4E000034)
#define NFMECC1     (*(volatile unsigned int*)0x4E000038)
#define NFSECC      (*(volatile unsigned int*)0x4E00003C)

#define NFMLCBITPT  (*(volatile unsigned int*)0x4E000040)

#define NF8ECCERR0  (*(volatile unsigned int*)0x4E000044)
#define NF8ECCERR1  (*(volatile unsigned int*)0x4E000048)
#define NF8ECCERR2  (*(volatile unsigned int*)0x4E00004c)

#define NFM8ECC0    (*(volatile unsigned int*)0x4E000050)
#define NFM8ECC1    (*(volatile unsigned int*)0x4E000054)
#define NFM8ECC2    (*(volatile unsigned int*)0x4E000058)
#define NFM8ECC3    (*(volatile unsigned int*)0x4E00005c)

#define NFMLCBITPT0 (*(volatile unsigned int*)0x4E000060)
#define NFMLCBITPT1 (*(volatile unsigned int*)0x4E000064)

#define clean_Rnb_bit() do{NFSTAT &= (1<<4);}while(0)

#define wait_Rnb_ready() while(!(NFSTAT&(1 << 4)))

#define chip_enable()	do{NFCONT &= ~(1 << 1);}while(0)
#define chip_disable()	do{NFCONT |= (1 << 1);}while(0) 

#define ULCON0 		(*(volatile unsigned char*)0x50000000)
#define UCON0 		(*(volatile unsigned int*)0x50000004)

#define UART0_TX_ENABLE()   do{UCON0 |= (1 << 2);}while(0)
#define UART0_TX_DISABLE()  do{UCON0 &= ~(3 << 2);}while(0)

#define UFCON0 			(*(volatile unsigned char*)0x50000008)
#define UMCON0 			(*(volatile unsigned char*)0x5000000C)
#define UTRSTAT0		(*(volatile unsigned char*)0x50000010)
#define UTXH0 			(*(volatile unsigned char*)0x50000020)
#define UBRDIV0 		(*(volatile unsigned short*)0x50000028)
#define UDIVSLOT0 		(*(volatile unsigned short*)0x5000002C)

#define wait4txdone()  while(!(UTRSTAT0& 0x2))

extern void uart_init(void);
extern void nand_init(void);
extern void uart_tx_byte(void);
extern void mdelay(void);

#define GPHCON 		(*(volatile unsigned int*)0x56000070)
#define GPHDAT 		(*(volatile unsigned int*)0x56000074)
#define GPHUDP 		(*(volatile unsigned int*)0x56000078)

#endif

