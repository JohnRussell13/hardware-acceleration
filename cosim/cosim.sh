#!/bin/sh
source amsgo
xmsc_run -sc_main -DSC_INCLUDE_DYNAMIC_PROCESSES -v93 -gui sc_main.cpp tb_cnn.cpp cnn.vhd bram.vhd dense.vhd pipeline.vhd
echo "" >> ../data/result_cosim.txt
