#pragma once

.section .text

#include "../helper/strings.S"
#include "../helper/task_load.S"
#include "../helper/printer.S"
#include "../helper/stack.S"

ptask2:
    // print msg
    la    a0, taskmsg2             // load addr of string msg
    store_r ra
    jal   puts                     // print msg contained in a0
    load_r ra

    // init variables
    addi  sp, sp, -0x10            // reserve 16 bytes for line in
    mv    t0, sp                   // store sp buffer in t0

    addi  sp, sp, -0x10            // reserve 12 bytes for top list
    mv    t1, sp                   // max_person list
    sd    zero, (t1)               // reset to 0
    sd    zero, 4(t1)              // reset to 0

    li    t2, 0                    // counter: t2 = 0
    li    t3, 0                    // EOT_flag: t3 = 0

    // check whether t2 can be insert, and if so, do that
1:  store_r t0, t1, t2, t3, ra
    mv    a0, t1
    mv    a1, t2
    jal   inserttopelves
    load_r  ra, t3, t2, t1, t0
    li    t2, 0
    bnez  t3, 4f                   // if EOT flag was set, end

    // get line
2:  mv    a0, t0                   // buffer loc
    li    a1, 0x10                 // size
    store_r t0, t1, t2, t3, ra
    jal   gets_line
    load_r  ra, t3, t2, t1, t0
    mv    t3, a1                   // store flag

    // check string length
    mv    a0, t0
    store_r t0, t1, t2, t3, ra
    jal   strlen
    load_r  ra, t3, t2, t1, t0

    beqz  a0, 1b               // empty line, reset c

    // else parse line and add value to current counter
    mv    a0, t0
    store_r t0, t1, t2, t3, ra
    jal   stoi
    load_r  ra, t3, t2, t1, t0

    add   t2, t2, a0               // else counter += int(line)

    bnez  t3, 1b                   // if EOT flag was set, end, but first insert
    j     2b

    // sum top three and print
4:  lwu   t0, (t1)
    lwu   t2, 4(t1)
    add   t0, t0, t2
    lwu   t2, 8(t1)
    add   t0, t0, t2

    mv    a0, t0
    store_r ra
    jal   printu
    load_r ra
    addi  sp, sp, 0x20
    ret


/** primary purpose:
 * given [x,y,z] and t, insert t into array,
 * if t is larger than min(arr), while preserving
 * property that arr presents top three elves
 * input:
 *   a0: ptr to 3 element (word) buffer  (12 bytes)
 *   a1: new value to consider
 * clobbers:
 *   t0, t1, t2
 */
inserttopelves:
    mv    t0, a0                  // buffer a0 value
    addi  t1, t0, 12              // t1 is max element

    // loop over elements
1:  beq   t0, t1, 3f              // return if reached end
    lw    t2, (t0)                // t2 (tmp) = *t0
    bge   t2, a1, 2f              // if *t0 >= a1, do nothing

    // a1 > *t0, insert a1
    sw    a1, (t0)
    store_r t0, t1, ra
    mv    a1, t2
    jal   inserttopelves
    load_r  ra, t1, t0

2:  addi  t0, t0, 4               // move by 2 bytes (short)
    j     1b

3:  ret
