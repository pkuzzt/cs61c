!/bin/bash
python3 binary_to_hex_cpu.py student_output/CPU-addi-pipelined-student.out > stu.out
python3 binary_to_hex_cpu.py reference_output/CPU-addi-pipelined-ref.out > ref.out
diff stu.out ref.out

