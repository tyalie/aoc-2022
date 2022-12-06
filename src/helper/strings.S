#pragma once

# string to int function
# will continue parsing int from string until non int character
# input:
#   a0: null-terminated string
# output:
#   a0: int
# clobbers:
#   t0, t1, t2
stoi:
    mv    t0, a0                # t0 = a0
    mv    a0, zero              # a0 = 0
    li    t2, 10                # constant 10

1:  lb    t1, (t0)              # t1 = *t0 (byte)
    addi  t1, t1, -0x30         # convert '0'-'9' to 0-9
    bgeu  t1, t2, 2f            # check if t1 ∈ [0,9], by using property u(t1)>>0 if t1<0
    mul   a0, a0, t2            # a0 *= 10
    add   a0, a0, t1            # a0 += t1
    addi  t0, t0, 1             # move index by one

2:  ret

