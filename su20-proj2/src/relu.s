.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    # Prologue
    bge x0, a1, relu_exit
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)
    addi t0, a0, 0
    addi t1, a1, 0
    addi t2, x0, 0
loop_start:
    slli s0, t2, 2
    add s0, s0, t0
    lw s1, 0(s0)
    slt t3, x0, s1
    mul s1, s1, t3 # s1 = t3 * s1
    sw s1, 0(s0) # A[t2] = s1
    addi t2, t2, 1

loop_continue:
    bge t2, t1, loop_end
    jal x0, loop_start
loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8
    addi a0, x0, 0
    ret
    
relu_exit:
    addi a1, x0, 8
    jal exit2