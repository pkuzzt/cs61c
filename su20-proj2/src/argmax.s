.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:
    addi t0, a0, 0
    addi t1, a1, 0
    addi t2, x0, 0
    addi t3, x0, 0
    bge x0, t1, argmax_exit
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)
loop_start:
    slli s0, t2, 2
    slli s1, t3, 2
    add s0, s0, t0
    add s1, s1, t0
    lw s0, 0(s0) # s0 = A[i]
    lw s1, 0(s1) # s1 = A[arg]
    slt t4, s1, s0 # t4 = (A[arg] < A[i]) ? 1 : 0
    sub t5, t2, t3 # t5 = i - arg
    mul t5, t5, t4
    add t3, t3, t5
    addi t2, t2, 1
loop_continue:
    bge t2, t1, loop_end
    jal x0, loop_start
loop_end:
    lw s0, 0(sp)
    lw s1, 0(sp)
    addi sp, sp, 8
    addi a0, t3, 0
    ret

argmax_exit:
    addi a1, x0, 7
    jal exit2