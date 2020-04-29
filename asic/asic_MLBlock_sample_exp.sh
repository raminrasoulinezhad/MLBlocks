#!/usr/bin/sh

PE_W=$1
PE_H=$2
TYPE=$3
REUSE=$4

if [ "$TYPE" -eq 0 ]; then
    A_D=2
    B_D=1
    ACC_D=1
    SHIFTER_TYPE="BYPASS"
elif [ "$TYPE" -eq 1 ]; then
    A_D=4
    B_D=2
    ACC_D=1
    SHIFTER_TYPE="2Wx2V_by_WxV_apx"
elif [ "$TYPE" -eq 2 ]; then
	A_D=4
    B_D=2
    ACC_D=1
    SHIFTER_TYPE="2Wx2V_by_WxV"
elif [ "$TYPE" -eq 3 ]; then
	A_D=6
    B_D=2
    ACC_D=1
    SHIFTER_TYPE="2Wx2V_by_WxV"
elif [ "$TYPE" -eq 4 ]; then
	A_D=6
    B_D=3
    ACC_D=1
    SHIFTER_TYPE="2Wx2V_by_WxV"
else
    exit
fi

if [ "$REUSE" -eq 1 ]; then
    #B_D=2*${B_D}
    B_D=$(( 2*B_D ))
    #ACC_D=2*${ACC_D}
    ACC_D=$(( 2*ACC_D ))
fi

exp_name=${PE_W}x${PE_H}_A${A_D}_B${B_D}_ACC${ACC_D}_${SHIFTER_TYPE}
exps_dir=./MLBlock_sample_dir
exp_dir=$exps_dir/$exp_name
mkdir -p $exp_dir

cp -r ${exps_dir}/files ${exp_dir}/files

top="MLBlock_sample"
ConfFile="${top}.v"
sed -i "s/	parameter PE_W = 3;*/	parameter PE_W = ${PE_W};/g" $exp_dir/files/$ConfFile
sed -i "s/	parameter PE_H = 4;*/	parameter PE_H = ${PE_H};/g" $exp_dir/files/$ConfFile
sed -i "s/	parameter A_D = 6;*/	parameter A_D = ${A_D};/g" $exp_dir/files/$ConfFile
sed -i "s/	parameter B_D = 4;*/	parameter B_D = ${B_D};/g" $exp_dir/files/$ConfFile
sed -i "s/	parameter SHIFTER_TYPE = \"2Wx2V_by_WxV\";*/	parameter SHIFTER_TYPE = \"${SHIFTER_TYPE}\";/g" $exp_dir/files/$ConfFile
sed -i "s/	parameter ACC_D = 2;*/	parameter ACC_D = ${ACC_D};/g" $exp_dir/files/$ConfFile

Sscript="asic_MLBlock_sample_parallel.tcl"
cp $Sscript $exp_dir/$Sscript
#sed -i "s|set\ basename\ fixed_mult;*|set\ basename\ ${top};|g" $exp_dir/$Sscript

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

