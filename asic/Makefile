# Please source vivado / rc:
# Vivado:
#	source /opt/Xilinx/Vivado/2018.2/settings64.sh
# rc source:
# 	cd ~/setup/setup_working_dir_130nm/
#	source .cshrc_hcmos9a_v1 
#	cd ~/workspace/MLBlocks/asic
.PHONY:  asic_MLBlock_2Dflex_v2  asic_MLBlock_2Dflex  asic_MLBlock_sample  asic_MLBlobk  asic_dsp  asic_accumulator asic_shifter asic_pe asic_adder asic_mux clean  

asic_MLBlock_2Dflex_v2:	
	rc -f ./asic_MLBlock_2Dflex_v2.tcl

asic_MLBlock_2Dflex:	
	rc -f ./asic_MLBlock_2Dflex.tcl

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

# for test
asic_adder:
	rc -f ./asic_adder.tcl

asic_mux:
	rc -f ./asic_mux.tcl

# clean
clean:
	rm -rf rc.cmd* rc.log* *initialtest* fv

# experiments
asic_all:
	rm -rf rc.* MLBlock_sample_dir 
	bash ./asic_MLBlock_sample_run.sh
	
tabulate:
	python3 tabulate.py --dir=MLBlock_sample_dir_1000  --clk=1000  --dsp_area=7958
	python3 tabulate.py --dir=MLBlock_sample_dir_750   --clk=1333  --dsp_area=7208
