.align 2
.equ UART_REG_TXFIFO,   0

#include "../helper/halt.S"
#include "task1.S"
#include "task2.S"

.section .init
.globl _start
_start:
    csrr  t0, mhartid              # read hardware thread id
    bnez  t0, halt                 # close down all threads except first

    la    sp, stack_top            # setup sp (stack_top defined in baremetal.ld)

    la    a0, msg                  # load addr of string msg
    jal   puts                     # print msg contained in a0

    # execute ptask 1
    jal   ptask1
    jal   println

    jal   ptask2
    jal   println

    j     halt                     # go into infinite loop

.section .rodata
msg:
    .string "Hello. This is day1\n"


