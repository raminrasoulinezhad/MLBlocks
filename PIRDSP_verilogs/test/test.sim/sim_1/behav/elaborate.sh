#!/bin/bash -f
xv_path="/opt/Xilinx/SDx/2017.2/Vivado"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xelab -wto 9e37860ad1714a2c91844ee4016b96d2 -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_tb_behav xil_defaultlib.ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_tb xil_defaultlib.glbl -log elaborate.log
