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

    addi a0, a0, -6
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
    jal ra, read_matrix
    lw s0, 0(sp) # s0 = nrow(m0), J
    lw s1, 4(sp) # s1 = ncolumn(m0), K
    mv s2, a0 # s2 = *m0
    # Load pretrained m1
    lw a0, 8(t0)
    mv a1, sp # nrow in 0(sp)
    addi a2, a1, 4 #ncolumn in 4(sp)
    jal ra, read_matrix
    lw s3, 0(sp) # s3 = nrow(m1), I
    lw s4, 4(sp) # s4 = ncolumn(m1), J
    mv s5, a0 # s5 = *m1
    # Load input matrix
    lw a0, 8(t0)
    mv a1, sp
    addi a2, a1, 4
    jal ra, read_matrix
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
    
    jal ra, matmul
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    # Print classification
    # Print newline afterwards for clarity
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

classify_exit:
    li a1, 49
    exit2