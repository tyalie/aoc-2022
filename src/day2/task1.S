#pragma once

.section .text

#include "util.S"

#include "../helper/strings.S"
#include "../helper/task_load.S"
#include "../helper/printer.S"
#include "../helper/stack.S"

ptask1:
    // print msg
    la    a0, taskmsg1
    store_r ra
    jal   puts
    load_r  ra

    // init variables
    addi  sp, sp, -0x8             // 8 byte buffer for line
    mv    t0, sp                   // t0 (line)

    li    t1, 0                    // t1 (score) = 0
    li    t2, 0                    // t3 (EOTflag) = 0

    // get line
1:  mv    a0, t0                   // a0: buffer loc
    li    a1, 0x8                  // a1: size of buffer
    store_r t0, t1, t2, ra
    jal   gets_line
    load_r  ra, t2, t1, t0
    mv    t2, a1                   // store EOT flag

    // check string length, must be 3
    mv    a0, t0
    store_r t0, t1, t2, ra
    jal   strlen
    load_r  ra, t2, t1, t0

    li    t4, 3
    bne   a0, t4, 3f               // len(line) != 3 -> error

    // parse line
    lb    a0, 2(t0)                // my move
    addi  a0, a0, -88              //  - a0 -= 'X'
    lb    a1, 0(t0)                // opponent
    addi  a1, a1, -65              //  - a1 -= 'A'

    addi  t3, a0, 1                // myMove val is used later (myMove ∈ [1,2,3])

    store_r t0, t1, t2, t3, ra
    jal   iswinner
    load_r  ra, t3, t2, t1, t0

    // calc score += iswinner * 3 + myMove
    li    t4, 0x3                 // t4 (tmp_score)
    mul   t4, a0, t4              // iswinner * 3
    add   t4, t4, t3              // += myMove

    add   t1, t1, t4              // score += tmp_score

    bnez  t2, 3f                  // jump back, if EOT not done
    j     1b                      // else read new line


3:  mv    a0, t1
    store_r ra
    jal   printu
    load_r  ra
    addi  sp, sp, 0x8
    ret



