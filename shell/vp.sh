#!/bin/sh
make -C ../vp 
echo "SystemC results:" > ../data/result.txt
for i in 0 1 2 3 4 5 6 7 8 9
do
	../vp/main ../data/weights.txt ../data/image$i.txt | grep "Image" >> ../data/result.txt
done
make clean -C ../vp 
echo "" >> ../data/result.txt