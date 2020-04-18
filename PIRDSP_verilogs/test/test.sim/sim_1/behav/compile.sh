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
echo "xvlog -m64 --relax -prj ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_tb_vlog.prj"
ExecStep $xv_path/bin/xvlog -m64 --relax -prj ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_tb_vlog.prj 2>&1 | tee compile.log
