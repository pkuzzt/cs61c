#!/bin/bash
python3 binary_to_hex_cpu.py ./student_output/cpu-mem-student.out > stu.out
python3 binary_to_hex_cpu.py ./reference_output/cpu-mem-ref.out > ref.out
diff stu.out ref.out

