#!/usr/bin/zsh

NUM_CORES=12


############# ram_mlut #############
#parallel --bar --gnu -j${NUM_CORES} --header : \
#    './exp.sh {top} {type} {d_w} {addr_w}' \
#    ::: top "ram_mlut" \
#    ::: type "S" "D" "Q" "SD" \
#    ::: d_w 1 2 3 4 5 6 16 18 \
#    ::: addr_w 5 6 7 8 9 10 11 12 13 14  
   
############# ram_uram #############
parallel --bar --gnu -j${NUM_CORES} --header : \
    './exp.sh {top} {type} {d_w} {addr_w}' \
    ::: top "ram_uram" \
    ::: type "SSD" \
    ::: d_w 72 144 288\
    ::: addr_w 9 10 11 12 13 14 15 16 17 18 19

