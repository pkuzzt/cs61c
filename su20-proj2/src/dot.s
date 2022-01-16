.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
    bge x0, a2, dot_exit1
    bge x0, a3, dot_exit2
    bge x0, a4, dot_exit2
    addi sp, sp, -16
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp) 
    mv t0, a0
    mv t1, a1
    mv t2, a2
    mv s0, a3
    mv s1, a4
    li t3, 0
    li t4, 0
loop_start:
    mul s2, t3, s0
    mul s3, t3, s1
    slli s2, s2, 2
    slli s3, s3, 2
    add s2, s2, t0
    add s3, s3, t0
    lw s2, 0(s2) # s2 = v0[i * step1]
    lw s3, 0(s3) # s3 = v1[i * step2]
    mul s2, s2, s3 # s2 = v0[i * step1] * v1[i * step1]
    add t4, t4, s2 # t4 = sum
    addi t3, t3, 1
    bge t3, a2, loop_end
    jal x0, loop_start
loop_end:
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    addi sp, sp, 16
    mv a0, t4
    ret

dot_exit1:
    li a1, 5
    jal exit2 

dot_exit2:
    li a1, 6
    jal exit2