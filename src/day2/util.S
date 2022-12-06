#pragma once

.section .text

/** Determine winner in rock-paper-scissor
 * Formula is (4 + a0 - a1) % 3
 * input:
 *   a0: move by me
 *   a1: move by opponent
 * output:
 *   a0: 2 if A is winner over B,
 *       1 if A == B,
 *       0 else
 * clobbers:
 *   t0, t1
 */
iswinner:
    mv    t0, a0
    mv    t1, a1

    # (3 + 1 + t0 - t1) % 3
    addi  a0, t0, 4
    sub   a0, a0, t1

    li    t0, 3
    remu  a0, a0, t0

    ret


/** Get required move to get result.
*  Formula is (a0 + a1 + 2) % 3
 * input:
 *   a0: move by opponent
 *   a1: required result (see iswinner doc for value meaning)
 * output:
 *   a0: move by me
 * clobbers:
 *   t0
 */
calcmove:
    # (a0 + a1 + 2) % 3
    addi  a0, a0, 2                 // a0 += 2
    add   a0, a0, a1                // a0 += a1

    li    t0, 3
    remu  a0, a0, t0                // a0 %= 3

    ret
