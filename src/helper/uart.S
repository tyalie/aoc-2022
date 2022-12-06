#pragma once

.include "cfg.inc"
.equ UART_REG_TXFIFO,  0x0
.equ UART_REG_RXFIFO,  0x4

.section .text

# puts subroutine, takes a pointer to a null-terminated C string
# and writes the content into uart
# input:
#   a0: output string
# clobbers:
#   t0,t1,t2 - temporary registers
puts:
    li    t0, UART_BASE                # t0 = UART_BASE

1:  lbu   t1, (a0)                     # t1 = unsigned byte from memory in a0
    beqz  t1, 3f                       # return if zero byte

                                       # wait until uart ready
2:  lw    t2, UART_REG_TXFIFO(t0)      # t2 = uart[UART_REG_TXFIFO]
    bltz  t2, 2b                       # t2 becomes positive once uart is ready
    sw    t1, UART_REG_TXFIFO(t0)      # send byte in t1

    addi  a0, a0, 1                    # increment by 1
    j     1b

3:  ret

# gets subroutine, takes a pointer to a free memory space and
# returns C terminated string
# input:
#   a0: address to memory
#   a1: number of bytes to load, must be at most size(a0)-1 for zero
# clobbers:
#   t0, t1, t2, t3
gets:
    li    t0, UART_BASE                # t0 = UART_BASE
    add   t3, a0, a1
    mv    t1, a0

1:  beq   t1, t3, 3f                   # return if index == a0 + a1

2:  lw    t2, UART_REG_RXFIFO(t0)      # load state of rx fifo
    bltz  t2, 2b                       # if t2 negative, there is no data
    sb    t2, (t1)                     # write byte t2 into memory addr of t1
    addi  t1, t1, 1
    j     1b

3:  sw    zero, (t1)
    ret

