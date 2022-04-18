#!/bin/sh
echo "Python results:" >> ../data/result_python.txt
for i in 0 1 2 3 4 5 6 7 8 9
do
python3 ../spec/Python/network.py -i1 ../data/image$i.txt -i2 ../data/weights.txt >> ../data/result_python.txt
done
make -C ../spec/C++ 
echo "C++ results:" >> ../data/result_cpp.txt 
for i in 0 1 2 3 4 5 6 7 8 9
do
../spec/C++/main ../data/weights.txt ../data/image$i.txt >> ../data/result_cpp.txt 
done
make clean -C ../spec/C++














