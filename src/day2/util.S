#pragma once

.section .text

/** Determine winner in rock-paper-scissor
 * input:
 *   a0: move by A
 *   a1: move by B
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

