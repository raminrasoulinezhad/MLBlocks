#!/usr/bin/sh

mkdir -p MLBlock_sample_dir
mkdir -p MLBlock_sample_dir/files
cp -r ../verilog/*.v ./MLBlock_sample_dir/files

NUM_CORES=10

parallel --bar --gnu -j${NUM_CORES} --header : \
    'bash ./asic_MLBlock_sample_exp.sh {PE_W} {PE_H} {TYPE} {REUSE}' \
    ::: PE_W 3 \
    ::: PE_H 2 3 4 \
    ::: TYPE 0 1 2 3 4 \
    ::: REUSE 0 1 
