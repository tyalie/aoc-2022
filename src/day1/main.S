.align 2
.equ UART_REG_TXFIFO,   0

#include "../helper/uart.S"
#include "../helper/halt.S"

.section .init
.globl _start
_start:
    csrr  t0, mhartid              # read hardware thread id
    bnez  t0, halt                 # close down all threads except first

    la    sp, stack_top            # setup sp (stack_top defined in baremetal.ld)

    la    a0, msg                  # load addr of string msg
    jal   puts                     # print msg contained in a0

    addi  sp, sp, -0x8
1:  mv    a0, sp
    li    a1, 1
    jal   gets
    jal   puts
    j     1b


    j     halt                     # go into infinite loop

.section .rodata
msg:
    .string "Hello.\n"


