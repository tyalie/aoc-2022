#pragma once

#include "uart.S"

# int to uart out function (unsigned)
# given an int, this function will print it to
# the uart
# input:
#   a0: number
# clobbers:
#   t0, t1, t2, t3
printu:
    # reserve buffer with 16 bytes size (log10 2³² ≈ 10)
    add   sp, sp, -0x10
    mv    t0, sp

    # fill t0 with spaces for 10 and add null-termination
    addi  t1, t0, 11              # t1 = t0 + 10 + 1
    li    t2, 0                   # t2 = 0  (constant)
    sb    t2, (t1)                #   - store null-termination
    li    t2, 0x20                # t2 = ' ' (constant)
1:  beq   t1, t0, 2f              # break if t1 == t0 (t1 is @beginning)
    addi  t1, t1, -1              # move t1 ptr 1 to left
    sb    t2, (t1)                # store space
    j     1b

    # while loop with
2:  li    t3, 10
    addi  t1, t0, 11
3:  beqz  a0, 5f                  # if a0 == 0, end, as there is nothing to print
    beq   t0, t1, 4f              #   - t1 is at t0 -> buffer full

    addi  t1, t1, -1              # t1 -= 1  (move t1 ptr by 1 to left)

    remu  t2, a0, t3              # t2 = a0 % 10
    divu  a0, a0, t3              # a0 /= 10

    addi  t2, t2, 0x30            # t2 += '0'  (to convert to ascii)
    sb    t2, (t1)
    j     3b


    # store '?' at beginning, if write buffer was full
4:  li    t2, 0x3f                # t2 = '?'
    sb    t2, (t0)

5:  mv    a0, t0
    li    a1, 16
    store_r ra
    jal   puts
    load_r ra
    add   sp, sp, 0x10
    ret


# simple function that prints a new line
# to UART
# input: -
# clobbers:
#   t0
println:
    add   sp, sp, -0x8
    li    t0, 0x000a                   # t0 = '\n\0' (const)
    sh    t0, (sp)
    mv    a0, sp
    store_r ra
    jal   puts
    load_r ra
    add   sp, sp, 0x8
    ret

