#This is demo project for arm926ej-s kernel
.section .data
.equ WDTCON,   0x53000000
.equ INTMSK1,  0x4A000008
.equ INTMSK2,  0x4A000048
.equ LOCKCON0, 0x4C000000
.equ LOCKCON1, 0x4C000004
.equ MPLLCON,  0x4C000010
.equ EPLLCON,  0x4C000018
.equ CLKSRC,   0x4C000020
.equ CLKDIV0,  0x4C000024
.equ CLKDIV1,  0x4C000028
.equ CLKDIV2,  0x4C00002C
.equ HCLKCON,  0x4C000030
.equ PCLKCON,  0x4C000034

.section .text
.globl _start
_start:
	mrs r0, cpsr
	bic r0, r0, #0x1f
	orr r0, r0, #0xd3
	msr cpsr, r0

	ldr r0, =WDTCON
	mov r1, #0
	str r1, [r0]

	ldr r0, =INTMSK1
	ldr r1, =0xffffffff
	str r1, [r0]

	ldr r0, =INTMSK2
	ldr r1, =0xffffffff 
	str r1, [r0]

	mov r0, #0
	mcr p15, 0, r0, c7, c7, 0 @ flush D-cache and invalid cache
	mcr p15, 0, r0, c8, c7, 0 @ flush TLB 

	mrc p15, 0, r0, c1, c0, 0 @ read c1 control register
	bic r0, r0, #0x00002300   @ clear bit9:bit8, disable ROM and MMU Opcode
	bic r0, r0, #0x00000087   @ disable MMU and Cache
	orr r0, r0, #0x00000002   @ set bit (A) align
	orr r0, r0, #0x00001000   @ enable I-cache 
	mcr p15, 0, r0, c1, c0, 0 @ write back c1 control register

	ldr r0, =CLKDIV0
	ldr r1, =0x0000022d
	str r1, [r0]

	ldr r0, =HCLKCON
	ldr r1, =0xffffffff
	str r1, [r0]

	ldr r0, =PCLKCON
	ldr r1, =0xffffffff
	str r1, [r0]

	ldr r0, =MPLLCON
	ldr r1, =(0 << 24)+(400 << 14)+(3 << 5)+(1 << 0)
	str r1, [r0]

	ldr r0, =EPLLCON
	ldr r1, =(0 << 24)+(32 << 16)+(1 << 8)+(2 << 0)
	str r1, [r0]

	ldr r0, =LOCKCON0
	ldr r1, =3600
	str r1, [r0]

	ldr r0, =LOCKCON1
	ldr r1, =3600
	str r1, [r0]

	ldr r0, =CLKSRC
	ldr r1, =(1 << 6)+(1 << 4)
	str r1, [r0]

#wait until clock stablize all clock.
	mov r2, #0x10000
1:  subs r2, r2, #1
	bne 1b

	bl init_stack @because we will jump to C running enviroment
	
#	bl clean_bss

	bl main

halt_loop:
	b halt_loop
	
init_stack:
	ldr sp, =8192 
	mov pc, lr

clean_bss:
	ldr r0, =__start_bss
	ldr r1, =__end_bss
	cmp r0, r1
	moveq pc, lr

clean_loop:
	mov r2, #0
	str r2, [r0], #4
	cmp r0, r1
	bne clean_loop

	mov pc, lr


