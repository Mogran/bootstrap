#include "bootstrap.h"

void nand_write_cmmd(unsigned char cmmd)
{
	NFCMMD = cmmd;
}

void nand_write_addr(unsigned char addr)
{
	NFADDR = addr;
}

unsigned char nand_read_byte(void)
{
	return NFDATA&0xff;
}

void nand_init(void)
{
	NFCONF = 0x0;
	NFCONF |= (2 << 12)|(1 << 8)|(1 << 1);

	NFCONT = 0x0;
	NFCONT |= (2 << 12)|(1 << 1)|(1 << 0);
}

void nand_reset(void)
{
	chip_enable();
	clean_Rnb_bit();
	
	nand_write_cmmd(0xff);
	
	wait_Rnb_ready();
}

void nand_read_id(void)
{
	volatile unsigned char id_tbl[5];
	nand_reset();
	
	nand_write_cmmd(0x90);
	nand_write_addr(0x00);
	
	id_tbl[0] = nand_read_byte();
	id_tbl[1] = nand_read_byte();
	id_tbl[2] = nand_read_byte();
	id_tbl[3] = nand_read_byte();
	id_tbl[4] = nand_read_byte();
	
}
