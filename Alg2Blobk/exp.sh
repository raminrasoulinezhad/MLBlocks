#!/usr/bin/sh

directory=$1
period=$2
index=$3

#echo ${directory}
#echo ${period}
#echo ${index}

exp_addr=${directory}/index_${index}

#echo ${exp_addr}

cd ${exp_addr} && pwd && rc -f exp.tcl -ex "array set paramters [list period $(period)]" -E
