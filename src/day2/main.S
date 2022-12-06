.align 2

#include "../helper/halt.S"
#include "task1.S"
#include "task2.S"

.section .init
.globl _start

_start:
    csrr  t0, mhartid              // t0 = hardware thread id
    bnez  t0, halt                 // close down all threads except first

    la    sp, stack_top            // setup sp

    la    a0, startupmsg           // load addr of string msg
    jal   puts                     // print msg contained in a0

    // execute ptask1
    jal   ptask1
    jal   println

    jal   ptask2
    jal   println

    j     halt

