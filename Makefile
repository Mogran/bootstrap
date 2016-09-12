TARGET=bootstrap

TEXTBASE=0x30008000
INC=-I.

CROSS_COMPILE=arm-linux-
#gnu c compiler
CC=$(CROSS_COMPILE)gcc
#generate ELF format file
LD=$(CROSS_COMPILE)ld
#STL generate 
AR=$(CROSS_COMPILE)ar
#arm-linux-copy src_file dst_file (different file format)
OBJCOPY=$(CROSS_COMPILE)objcopy
#arm-linux-dump src_file ? remove src_file's symbol and unused info.
OBJDUMP=$(CROSS_COMPILE)objdump
#arm-linux-strip 
STRIP=$(CROSS_COMPILE)strip
#arm-linux-readelf
READELF=$(CROSS_COMPILE)readelf

CFLAGS =-g -O2 -Wall -nostdinc -nostdlib -fno-builtin ${INC}
AFLAGS =-${CFLAGS} -D_ASSEMBLY__ 

LDFALGS=-Ttext ${TEXTBASE}

SRC_C=$(wildcard *.c)
SRC_S=$(wildcard *.S)

OBJ_C=$(patsubst %.c,%.o,$(SRC_C))
OBJ_S=$(patsubst %.c,%.o,$(SRC_S))
OBJ_ALL=$(OBJ_C) $(OBJ_S)

.PHONY:all
all:${OBJ_ALL}
	${LD} ${LDFALGS} -o ${TARGET}.elf ${OBJ_ALL}
	${OBJCOPY} -O binary -S ${TARGET}.elf ${TARGET}.bin
	rm -rf *.elf *.o

%.o:%.c
	${CC} ${CFLAGS} -c -o $@ $<
%.o:%.S
	${CC} ${AFLAGS} -c -o $@ $<

clean:
	rm -rf *.elf ${TARGET}.bin 

