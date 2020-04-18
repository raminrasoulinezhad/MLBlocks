#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/opt/Xilinx/SDK/2018.2/bin:/opt/Xilinx/Vivado/2018.2/ids_lite/ISE/bin/lin64:/opt/Xilinx/Vivado/2018.2/bin
else
  PATH=/opt/Xilinx/SDK/2018.2/bin:/opt/Xilinx/Vivado/2018.2/ids_lite/ISE/bin/lin64:/opt/Xilinx/Vivado/2018.2/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=/opt/Xilinx/Vivado/2018.2/ids_lite/ISE/lib/lin64
else
  LD_LIBRARY_PATH=/opt/Xilinx/Vivado/2018.2/ids_lite/ISE/lib/lin64:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/home/ramintp/MEGA/USYD/2018_R2/temp/Standard Cell/Verilog model/test/test.runs/synth_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

EAStep vivado -log DSP_proposed_RFless_freezer.vds -m64 -product Vivado -mode batch -messageDb vivado.pb -notrace -source DSP_proposed_RFless_freezer.tcl
