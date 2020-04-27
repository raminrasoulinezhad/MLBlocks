# Please source vivado first:
#	source /opt/Xilinx/Vivado/2018.2/settings64.sh
# the source rc
# 	cd setup/setup_working_dir_130nm/
#	source .cshrc_hcmos9a_v1 

.PHONY: clean asic_test asic_dsp

clean:
	rm -rf ./asic_test

asic_test:
	rm -rf ./asic_test
	rc -f ./asic_test.tcl
	#bash ./asic_test_run.sh

asic_dsp:
	rm -rf ./asic_dsp
	rc -f ./asic_dsp.tcl


