.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# ==============================================================================
write_matrix:
    addi sp, sp, -4
    sw ra, 0(sp)
    # Prologue
    mv t0, a0 # t0 = filename
    mv t1, a1 # t1 = *m
    mv t2, a2 # t2 = nrow
    mv t3, a3 # t3 = ncolumn

    # call fopen
    mv a1, t0
    li a2, 1
    jal fopen
    blt a0, x0, write_matrix_exit1
    mv t4, a0 # t4 = FILE
    # write nrow, ncolumn
    addi sp, sp, -4 # nrow and ncolumn are saved in M[sp] temporary
    sw t2, 0(sp)
    mv a1, t4
    mv a2, sp
    li a3, 1
    li a4, 4
    jal ra, fwrite
    addi a0, a0, -1
    bne a0, x0, write_matrix_exit2
    sw t3, 0(sp)
    mv a1, t4
    mv a2, sp
    li a3, 1
    li a4, 4
    jal ra, fwrite
    addi a0, a0, -1
    bne a0, x0, write_matrix_exit2
    addi sp, sp, 4
    # write matrix element
    mul t5, t2, t3
    mv a1, t4
    mv a2, t1
    mv a3, t5
    li a4, 4
    jal ra, fwrite
    bne a0, t5, write_matrix_exit2
    # call fclose
    mv a1, t4
    jal ra, fclose
    bne a0, x0, write_matrix_exit3
    # Epilogue
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

write_matrix_exit1:
    li a1, 53
    jal exit2

write_matrix_exit2:
    li a1, 54
    jal exit2

write_matrix_exit3:
    li a1, 55
    jal exit2