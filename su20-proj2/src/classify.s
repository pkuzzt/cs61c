.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
	# =====================================
    addi sp, sp, -4
    sw ra, 0(sp)
    addi a0, a0, -5
    bne a0, x0, classify_exit
    mv t0, a1 # t0 = argv
    mv t1, a2 # a2 = print_classification
    # LOAD MATRICES
    # =====================================
    # Load pretrained m0
    addi sp, sp, -8

    lw a0, 4(t0)
    mv a1, sp
    addi a2, a1, 4

    # save t0, t1
    addi sp, sp, -8
    sw t0, 0(sp)
    sw t1, 4(sp)
    # call read_matrix
    jal ra, read_matrix
    lw t0, 0(sp)
    lw t1, 4(sp)
    addi sp, sp, 8
    
    lw s0, 0(sp) # s0 = nrow(m0), J
    lw s1, 4(sp) # s1 = ncolumn(m0), K
    mv s2, a0 # s2 = *m0
    
    # Load pretrained m1
    lw a0, 8(t0)
    mv a1, sp # nrow in 0(sp)
    addi a2, a1, 4 #ncolumn in 4(sp)

    # save t0, t1
    addi sp, sp, -8
    sw t0, 0(sp)
    sw t1, 4(sp)
    # call read_matrix
    jal ra, read_matrix
    # load t0, t1
    lw t0, 0(sp)
    lw t1, 4(sp)
    addi sp, sp, 8

    lw s3, 0(sp) # s3 = nrow(m1), I
    lw s4, 4(sp) # s4 = ncolumn(m1), J
    mv s5, a0 # s5 = *m1

    # Load input matrix
    lw a0, 12(t0)
    mv a1, sp
    addi a2, a1, 4

    # save t0, t1
    addi sp, sp, -8
    sw t0, 0(sp)
    sw t1, 4(sp)
    # call read_matrix
    jal ra, read_matrix
    # load t0, t1
    lw t0, 0(sp)
    lw t1, 4(sp)
    addi sp, sp, 8

    lw s6, 0(sp) # s6 = nrow(input), K
    lw s7, 4(sp) # s7 = ncolumn(input), L
    mv s8, a0 # s8 = *input
    addi sp, sp, 8

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # malloc
    mul a0, s0, s7
    slli a0, a0, 2
    jal ra, malloc
    mv t3, a0 # t3 = *output1 

    mv a0, s2
    mv a1, s0
    mv a2, s1
    mv a3, s8
    mv a4, s6
    mv a5, s7
    mv a6, t3

    # save t0, t1, t3
    addi sp, sp, -12
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t3, 8(sp)
    # call matmul
    jal ra, matmul
    # load t0, t1, t3
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t3, 8(sp)
    addi sp, sp, 12

    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    mv a0, t3
    mul a1, s0, s7

    # save t0, t1, t3
    addi sp, sp, -12
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t3, 8(sp)
    # call relu
    jal ra, relu
    # load t0, t1, t3
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t3, 8(sp)
    addi sp, sp, 12

    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    # malloc
    mul a0, s3, s7
    slli a0, a0, 2
    jal ra, malloc
    mv t4, a0 # t4 = *output2

    mv a0, s5
    mv a1, s3
    mv a2, s4
    mv a3, t3
    mv a4, s0
    mv a5, s7
    mv a6, t4

    # save t0, t1, t3, t4
    addi sp, sp, -16
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t3, 8(sp)
    sw t4, 12(sp)
    # call matmul
    jal ra, matmul
    # load t0, t1, t3
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t3, 8(sp)
    lw t4, 12(sp)
    addi sp, sp, 16

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(t0)
    mv a1, t4
    mv a2, s3
    mv a3, s7

    addi sp, sp, -8
    sw t1, 0(sp)
    sw t4, 4(sp)
    jal ra, write_matrix
    lw t1, 0(sp)
    lw t4, 4(sp)
    addi sp, sp, 8
    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    bne t1, x0, classify_end
    mv a0, t4
    mul a1, s3, s7
    jal ra, argmax
    # Print classification
    mv a1, a0
    jal ra, print_int
    # Print newline afterwards for clarity
    li a1, '\n'
    jal ra, print_char
classify_end:
    # free
    mv a0, s2
    jal ra, free
    mv a0, s5
    jal ra, free
    mv a0, s8
    jal ra, free
    mv a0, t3
    jal ra, free
    mv a0, t4
    jal ra, free
    # load sp
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

classify_exit:
    li a1, 49
    jal exit2