java -jar ../tools/venus.jar assembly/test_write_matrix.s
python3 ../tools/convert.py --to-ascii outputs/test_write_matrix/student_write_outputs.bin output.txt 
cat output.txt