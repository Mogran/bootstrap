#This is demo project for arm926ej-s kernel
.section .data
.equ WDTCON, 0x53000000  @wdtcon
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

	bl init_stack @because we will jump to C running enviroment
	
	bl clean_bss

	bl main

halt_loop:
	b halt_loop

init_stack:
	ldr sp, =8196 
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


