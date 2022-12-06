#pragma once

#include "uart.S"
#include "stack.S"

/** load a single line from uart input, null-terminated
 * input:
 *   a0: memory address
 *   a1: max. size of line  (should by <= size(a0)-1)
 * output:
 *   a1: flag if encountered EOT
 * clobbers:
 *   t0, t1, t2
 */
gets_line:
    addi sp, sp, -0x8               // reserve memory on stack for gets
    mv   t0, sp
    mv   t3, a1                     // store len in t3
    li   a1, 0                      // flag a1 (EOT) as 0

1:  beqz t3, 2f                     // return if max chars read
                                    // get chars from gets, one char at a time
    store_r  a0, a1, t0, t1, t3, ra     // caller saved
    mv   a0, t0                     // prepare fn arguments for get
    li   a1, 1
    jal  gets                       // get single char from uart
    load_r   ra, t3, t1, t0, a1, a0

    lb   t1, (t0)                   // get value that is in buffer t0
                                    // check if return val is \n, \r, null or EOT
    li   t2, 0xa                    //   - newline
    beq  t1, t2, 2f
    li   t2, 0xd                    //   - \r
    beq  t1, t2, 2f
    beqz t1, 2f                     //   - zero
    li   t2, 0x4                    //   - EOT  (flag a1 == 1)
    beq  t1, t2, 3f

    sb   t1, (a0)                   // write char into line buf
    addi a0, a0, 1                  // increment buffer index
    addi t3, t3, -1
    j    1b

3:  li   a1, 1                      // flag a1 (EOT) as 1

2:  sb   zero, (a0)
    addi sp, sp, 0x8
    ret
