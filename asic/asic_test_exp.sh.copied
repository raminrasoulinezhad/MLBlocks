#!/usr/bin/sh

top=$1
a_w=$2
b_w=$3
a_s=$4
b_s=$5
c_w=$6

exp_name=${top}_${a_w}_${b_w}_${a_s}_${b_s}_${c_w}
exps_dir=./fixed_asic
exp_dir=$exps_dir/$exp_name
mkdir -p $exp_dir

cp -r ${exps_dir}/files ${exp_dir}/files

ConfFile="${top}.v"
sed -i "s/	parameter a_w = 8;*/	parameter a_w = ${a_w};/g" $exp_dir/files/$ConfFile
sed -i "s/	parameter b_w = 8;*/	parameter b_w = ${b_w};/g" $exp_dir/files/$ConfFile
sed -i "s/	parameter a_s = 1'b0;*/	parameter a_s = 1'b${a_s};/g" $exp_dir/files/$ConfFile
sed -i "s/	parameter b_s = 1'b0;*/	parameter b_s = 1'b${b_s};/g" $exp_dir/files/$ConfFile
sed -i "s/	parameter c_w = 20;*/	parameter c_w = ${c_w};/g" $exp_dir/files/$ConfFile

Sscript="fixed_asic.tcl"
cp $Sscript $exp_dir/$Sscript
sed -i "s|set\ basename\ fixed_mult;*|set\ basename\ ${top};|g" $exp_dir/$Sscript

cd $exp_dir
rc -f ./$Sscript

Sanswers="answers"
mkdir -p ../$Sanswers

Sfiles="${top}_initialtest_cell.rep"
temp="${exp_name}_initialtest_cell.rep"
cp -r  ./$Sfiles  ../$Sanswers/$temp

Sfiles="${top}_initialtest_power.rep"
temp="${exp_name}_initialtest_power.rep"
cp -r  ./$Sfiles  ../$Sanswers/$temp

Sfiles="${top}_initialtest_timing.rep"
temp="${exp_name}_initialtest_timing.rep"
cp -r  ./$Sfiles  ../$Sanswers/$temp

