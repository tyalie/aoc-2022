#pragma once

.section .text

#include "../helper/strings.S"
#include "../helper/task_load.S"
#include "../helper/printer.S"
#include "../helper/stack.S"

ptask1:
    // print msg
    la    a0, taskmsg1             // load addr of string msg
    store_r ra
    jal   puts                     // print msg contained in a0
    load_r ra

    // init variables
    addi  sp, sp, -0x10            // reserve 16 bytes for line in
    mv    t0, sp                   // store sp buffer in t0

    li    t1, 0                    // max_person: t1 = 0
    li    t2, 0                    // counter: t2 = 0
    li    t3, 0                    // EOT_flag: t3 = 0

1:  mv    t4, t2
    li    t2, 0                    // counter: t1 = 0
    blt   t4, t1, 2f               // if max_person > counter: do nothing
    mv    t1, t4                   // else max_person = counter

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

    beqz  a0, 1b                   // empty line, reset c

    // else parse line and add value to current counter
    mv    a0, t0
    store_r t0, t1, t2, t3, ra
    jal   stoi
    load_r  ra, t3, t2, t1, t0

    add   t2, t2, a0               // else counter += int(line)

    bnez  t3, 3f                   // if EOT flag was set, end
    j     2b

    // last check if max
3:  blt   t2, t1, 4f               // if max_person > counter: do nothing
    mv    t1, t4                   // else max_person = counter

    // print maximum
4:  mv    a0, t1
    store_r ra
    jal   printu
    load_r ra
    addi  sp, sp, 0x10
    ret
