.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:
    addi sp, sp, -4
    sw ra, 0(sp)
    # Prologue
    mv t0, a0 # t0 = filename
    mv t1, a1 # t1 = *nrow
    mv t2, a2 # t2 = *ncolumn
    # call fopen
    mv a1, t0
    li a2, 0
    jal ra, fopen
    # error 
    blt a0, x0, read_matrix_exit1
    mv t3, a0 # t3 = file t0 read
    # read nrow, ncolumn
    mv a1, t3
    mv a2, t1
    li a3, 4
    jal ra, fread
    # error 
    addi a0, -4
    bne a0, x0, read_matrix_exit2
    mv a1, t3
    mv a2, t2
    li a3, 4
    jal ra, fread
    # error
    addi a0, -4
    bne a0, x0, read_matrix_exit2
    # get length
    lw t4, t1
    lw t5, t2
    mul t4, t4, t5 # t4 = nrow * ncolumn
    # call malloc
    mv a0, t4
    jal ra, malloc
    mv t5, a0 # t5 = *m
    beq a0, x0, read_matrix_exit
    # read m
    slli t4, t4, 2
    mv a1, t3
    mv a2, t5
    mv a3, t4
    jal ra, fread
    # error 
    bne a0, t4, read_matrix_exit2
    # call fclose
    mv a1, t3
    jal ra, fclose
    # error 
    bne a0, x0, read_matrix_exit3
    # Epilogue
    lw ra, 0(sp)
    addi sp, sp, 4
    mv a0, t5
    ret

read_matrix_exit:
    li a1, 48
    jal ra, exit2

read_matrix_exit1:
    li a1, 50
    jal ra, exit2

read_matrix_exit2:
    li a1, 51
    jal ra, exit2

read_matrix_exit3:
    li a1, 52
    jal ra, exit2