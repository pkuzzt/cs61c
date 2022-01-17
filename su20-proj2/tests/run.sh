java -jar ../tools/venus.jar ../src/main.s -ms -1 ./inputs/mnist/bin/m0.bin ./inputs/mnist/bin/m1.bin ./inputs/mnist/bin/inputs/mnist_input0.bin ./outputs/test_mnist_main/student_mnist_output.bin
python3 ../tools/convert.py --to-ascii ./outputs/test_mnist_main/student_mnist_output.bin output.txt
cat output.txt