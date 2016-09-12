TARGET=bootstrap

CROSS_COMPILE=arm-linux-
CC=$(CROSS_COMPILE)gcc
CFLAGS=-g -O -Wall

C_SOURCE=$(wildcard *.c)
A_SOURCE=$(wildcard *.S)
O_SOURCE=$(patsubst %.c,%,o,$(C_SOURCE) $(A_SOURCE))

all:$(TARGET)


