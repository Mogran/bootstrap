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
	NFCONF |= (0 << 12)|(2 << 8)|(1 << 4)|(1 << 1);

	NFCONT = 0x0;
	NFCONT |= (2 << 12)|(1 << 1)|(1 << 0);

	GPACON = 0x0fffffff;
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
	volatile unsigned char loop_i = 0;
	volatile unsigned char id_tbl[6];

	chip_enable();
	clean_Rnb_bit();
	nand_write_cmmd(0xff);
	wait_Rnb_ready();

	nand_write_cmmd(0x90);
	nand_write_addr(0x00);

	id_tbl[0] = nand_read_byte();
	id_tbl[1] = nand_read_byte();
	id_tbl[2] = nand_read_byte();
	id_tbl[3] = nand_read_byte();
	id_tbl[4] = nand_read_byte();

	for(loop_i = 0; loop_i < 5; loop_i++){
		uart_tx_byte(id_tbl[loop_i]);
	}

	chip_disable();

}

int nand_erase_one_block(int block)
{
	volatile unsigned char data = 0;
	volatile int ret = 0;

	chip_enable();
	clean_Rnb_bit();
	nand_write_cmmd(0x60);
	nand_write_addr((block&0x2)<<6);	
	nand_write_addr((block>>2)&0xff);	
	nand_write_addr((block>>10)&0xff);	
	nand_write_cmmd(0xd0);	
	
	wait_Rnb_ready();
	
	nand_write_cmmd(0x70);	
	data = nand_read_byte();	
	if(!(data & 0x01)){
		ret = 1;
	}

	chip_disable();

	return ret;
}

int nand_read_one_page(int block, int page, unsigned char *buf, int size)
{
	volatile int i = 0;

	chip_enable();
	nand_write_cmmd(0x00);

	nand_write_addr(0x00);
	nand_write_addr(0x00);
	nand_write_addr(((block&0x2)<<6) | page);	
	nand_write_addr((block>>2)&0xff);	
	nand_write_addr((block>>10)&0xff);	

	nand_write_cmmd(0x30);
	clean_Rnb_bit();
	wait_Rnb_ready();

	for(i = 0; i < size; i++){
		buf[i] = nand_read_byte();
	}

	chip_disable();

	return size;
}

