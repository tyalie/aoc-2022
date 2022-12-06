#pragma once

/** macro to store given registers in stack
 * use it like this
 *
 * store_r t0, t1, t2
 */
.macro store_r p1:req p2:vararg
addi  sp, sp, -0x8
sd    \p1, (sp)

.ifnb \p2
store_r \p2
.endif
.endm

/** macro to load given from stack
 * similar usage to store_r, but to unstack,
 * reverse order of parameters in comparision
 * to store_r
 */
.macro load_r p1:req p2:vararg
ld    \p1, (sp)
addi  sp, sp, 0x8

.ifnb \p2
load_r \p2
.endif
.endm
