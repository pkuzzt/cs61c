.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0) # a0 = n
    jal ra, factorial

    addi a1, a0, 0 # a1 = factorial(n)
    addi a0, x0, 1 # a0 = 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    # YOUR CODE HERE
    addi t0, x0, 1
    addi t1, x0, 1
loop:
    mul t1, t1, t0
    addi t0, t0, 1
    bgeu a0, t0, loop
    addi a0, t1, 0
    jr ra

