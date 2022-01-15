.data
source:
    .word   3
    .word   1
    .word   4
    .word   1
    .word   5
    .word   9
    .word   0
dest:
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0

.text
main:
    addi t0, x0, 0
    addi s0, x0, 0
    la s1, source
    la s2, dest
loop:
    slli s3, t0, 2 # t0 = k
    add t1, s1, s3 # t1 = source + t0  
    lw t2, 0(t1) # t2 = source[k]
    beq t2, x0, exit # if (source[k] == 0) exit;

    add a0, x0, t2 # a0 = source[k];

    addi sp, sp, -8
    sw t0, 0(sp)
    sw t2, 4(sp)
    jal square
    lw t0, 0(sp)
    lw t2, 4(sp)
    addi sp, sp, 8 # a0 = func(a0);

    add t2, x0, a0 # t2 = a0
    add t3, s2, s3 # t3 = source + t0
    sw t2, 0(t3) 
    add s0, s0, t2 # s0 = sum, sum = sum + func(source[k]);
    addi t0, t0, 1 # t0 = k;
    jal x0, loop
square:
    add t0, a0, x0
    add t1, a0, x0
    addi t0, t0, 1
    addi t2, x0, -1
    mul t1, t1, t2
    mul a0, t0, t1
    jr ra
    
exit:
    add a0, x0, s0
    add a1, x0, x0
    ecall # Terminate ecall