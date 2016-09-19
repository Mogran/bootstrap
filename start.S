#This is demo project for arm926ej-s kernel
.section .data
.equ WDTCON, 0x53000000    @wdtcon
.equ INTMSK1, 0x4A000008 @intmask1
.equ INTMSK2, 0x4A000048 @intmask2

.section .text
.globl _start

_start:
	mrs r0, cpsr
	bic r0, r0, #0x1f
	orr r0, r0, #0xd3
	msr cpsr, r0

	ldr r0, =WDTCON
	ldr r1, =0x0000ffff 
	str r1, [r0]

	ldr r0, =INTMSK1
	ldr r1, =0xffffffff
	str r1, [r0]

	ldr r0, =INTMSK2
	ldr r1, =0xffffffff 
	str r1, [r0]

	bl cpu_init_cirt

	b main

cpu_init_cirt:
	mov r0, #0
flush_dcache:
	mrc p15, 0, r15, c7, c10, 0 @flush D-cache before disabling it
	bne flush_dcache

	mrc p15, 0, r0, c8, c7, 0 @flush TLB 

	mrc p15, 0, r0, c1, c0, 0 @read c1 control register
	bic r0, r0, #0x00000300   @clear bit9:bit8, disable ROM and MMU Opcode
	bic r0, r0, #0x00002000   @set Interrupt Table low addr
	bic r0, r0, #0x00000087   @disable MMU and Cache
	orr r0, r0, #0x00001000   @enable I-cache 
	mcr p15, 0, r0, c1, c0, 0 @write back c1 control register

	mov pc, lr


