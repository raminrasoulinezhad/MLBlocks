#!/usr/bin/sh

mkdir -p fixed_asic
mkdir -p fixed_asic/files
cp -r ../Fixed_parameterized_Verilog/*.v ./fixed_asic/files
cp Cons_fixed.xdc ./fixed_asic/files/Cons.xdc

NUM_CORES=2

parallel --bar --gnu -j${NUM_CORES} --header : \
    'bash ./fixed_asic_exp.sh {top} {a_w} {b_w} {a_s} {b_s} {c_w}' \
	::: top "fixed_mac" "fixed_mult" \
    ::: a_w 2 3 4 5 6 7 8 9 10 11 \
    ::: b_w 2 3 4 5 6 7 8 9 10 12 \
    ::: a_s 0 1 \
    ::: b_s 0 1 \
    ::: c_w 32

