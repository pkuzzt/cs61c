.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "inputs/test_read_matrix/test_input.bin"
nrow: 0
ncolumn: 0

.text
main:
    # Read matrix into memory
    la s0, nrow
    la s1, ncolumn
    la a0, file_path
    mv a1, t0
    mv a2, s1
    jal ra, read_matrix
    mv s2, a0
    # Print out elements of matrix
    lw s0, 0(s0)
    lw s1, 0(s1)
    mv a0, s2
    mv a1, s0
    mv a2, s1
    jal ra print_int_array

    # Terminate the program
    jal exit