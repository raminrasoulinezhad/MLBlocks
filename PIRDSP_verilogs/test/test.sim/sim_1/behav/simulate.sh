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
ExecStep $xv_path/bin/xsim ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_tb_behav -key {Behavioral:sim_1:Functional:ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_tb} -tclbatch ALU_SIMD_Width_parameterized_HighLevelDescribed_auto_tb.tcl -log simulate.log
