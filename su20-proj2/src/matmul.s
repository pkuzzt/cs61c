.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:
    # Error checks
    bge x0, a1, matmul_exit1
    bge x0, a2, matmul_exit1
    
    bge x0, a4, matmul_exit2
    bge x0, a5, matmul_exit2

    bne a2, a4, matmul_exit3
    # save s
    addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)

    # Prologue
    mv s0, a1 # s0 = I
    mv s1, a2 # s1 = K
    mv s2, a5 # s2 = J
    mv s3, a0 # s3 = A
    mv s4, a3 # s4 = B
    mv s5, a6 # s5 = C 

    li t0, 0 # t0 = i
outer_loop_start:
    # C[i][j] = sum(A[i][k], B[k][j])
    # in row-major order, 
    # sum(A[i][k], B[k][j]) = dot(A + i * K, B + j, K, 1, J)
    li t1, 0 # t1 = j
inner_loop_start:

    mul t2, t0, s2
    add t2, t2, t1 # t2 = i * J + j
    
    slli t2, t2, 2
    add t2, t2, s5 # t2 = C + i * J + j
    
    # set Arguments
    mv a0, s1
    mul a0, s1, t0
    slli a0, a0, 2
    add a0, a0, s3 # a0 = A + i * K

    mv a1, t1
    slli a1, a1, 2
    add a1, s4, a1 # a1 = B + j

    mv a2, s1
    li a3, 1
    mv a4, s2

    # save t, ra
    addi sp, sp, -16
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw ra, 12(sp)

    # call dot
    jal ra dot

    #load t, ra
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16

    sw a0, 0(t2)
    addi t1, t1, 1
    bge t1, s2, inner_loop_end
    jal x0, inner_loop_start

inner_loop_end:
    addi t0, t0, 1
    bge t0, s0, outer_loop_end
    jal x0, outer_loop_start

outer_loop_end:
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    addi sp, sp, 24
    ret

matmul_exit1:
    li a1, 2
    jal exit2

matmul_exit2:
    li a1, 3
    jal exit2

matmul_exit3:
    li a1, 4
    jal exit2