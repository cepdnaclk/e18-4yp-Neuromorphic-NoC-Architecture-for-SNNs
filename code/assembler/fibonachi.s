addi x0, x0, 1
addi x1, x1, 1
addi x5, x5, 0
Loop:
add x2, x0, x1
addi x0, x1, 0
addi x1, x2, 0
sw x2, 0(x5)
nop
nop
nop
lw x6, 0(x5)
jal x5, Loop