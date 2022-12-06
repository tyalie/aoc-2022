.align 2
.equ UART_REG_TXFIFO,   0

#include "../helper/halt.S"
#include "../helper/strings.S"
#include "../helper/task_load.S"
#include "../helper/stack.S"

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
    li    a1, 8
    jal   gets_line
    mv    a0, sp
    jal   puts
    j     1b


    j     halt                     # go into infinite loop

.section .rodata
msg:
    .string "Hello.\n"


