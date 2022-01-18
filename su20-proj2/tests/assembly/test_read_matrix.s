.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "inputs/test_read_matrix/test_input.bin"
nrow: .word 0
ncolumn: .word 0

.text
main:
    # Read matrix into memory
    la s0, nrow
    la s1, ncolumn
    la a0, file_path
    mv a1, s0
    mv a2, s1
    jal ra, read_matrix
    mv s2, a0
    # Print out elements of matrix
    mv a0, s2
    lw a1, 0(s0)
    lw a2, 0(s1)
    jal ra print_int_array
    # Terminate the program
    jal exit