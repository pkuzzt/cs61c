.import ../../src/matmul.s
.import ../../src/utils.s
.import ../../src/dot.s

# static values for testing
.data
m0: .word 1 2 3 4 5 6
m1: .word 1 2 3 4 5 6 7 8 9 10 11 12
d: .word 0 0 0 0 0 0 0 0 0 # allocate static space for output

.text
main:
    la a0, m0
    li a1, 2
    li a2, 3
    jal ra print_int_array
    li a1, '\n'
    jal ra print_char
    la a0, m1
    li a1, 3
    li a2, 4
    jal ra print_int_array
    li a1, '\n'
    jal ra print_char
    # Load addresses of input matrices (which are in static memory), and set their dimensions
    la a0, m0
    la a3, m1
    la a6, d
    li a1 2
    li a2 3
    li a4 3
    li a5 4

    # Call matrix multiply, m0 * m1
    jal ra matmul

    # Print the output (use print_int_array in utils.s)
    la a0, d
    li a1, 2
    li a2, 4
    jal ra print_int_array
    
    # Exit the program
    jal exit