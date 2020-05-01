# Please source vivado / rc:
# Vivado:
#	source /opt/Xilinx/Vivado/2018.2/settings64.sh
# rc source:
# 	cd ~/setup/setup_working_dir_130nm/
#	source .cshrc_hcmos9a_v1 
.PHONY:  asic_MLBlock_sample  asic_MLBlobk  asic_dsp  asic_accumulator clean

asic_MLBlock_sample:
	rc -f ./asic_MLBlock_sample.tcl

asic_MLBlock:
	rc -f ./asic_MLBlock.tcl

asic_dsp:
	rc -f ./asic_dsp.tcl

# sub modules 
asic_accumulator:
	rc -f ./asic_accumulator.tcl
	
asic_shifter:
	rc -f ./asic_shifter.tcl

asic_pe:
	rc -f ./asic_pe.tcl

# clean
clean:
	rm -rf rc.* *initialtest* fv

# experiments
asic_all:
	rm -rf rc.* MLBlock_sample_dir 
	bash ./asic_MLBlock_sample_run.sh
	