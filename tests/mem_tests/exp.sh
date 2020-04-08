#! /bin/bash

top=$1
type=$2
d_w=$3
addr_w=$4

let addr_deep=$((2**(${addr_w})))

if [ $top == "ram_mlut" ]; then
    addr_deep_z=00000
    d_w_z=00
elif [ $top == "ram_uram" ]; then
    addr_deep_z=000000
    d_w_z=000
fi

d_w_s="${d_w_z:${#d_w}:${#d_w_z}}${d_w}"
addr_deep_s="${addr_deep_z:${#addr_deep}:${#addr_deep_z}}${addr_deep}"
addr_s="./workspace/${top}_${type}_${addr_deep_s}x${d_w_s}"

part="xczu28dr-ffvg1517-2-e"

make  mem  p_dir=${addr_s} top=${top}  d_w=${d_w}  addr_w=${addr_w}  type=${type}  part=${part}
