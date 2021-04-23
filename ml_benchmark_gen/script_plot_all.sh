# Approach 1 (Same number of EB experiments - area affect on column width): 
#	1- without the area ratio efects:
#		area_ratio_mode=None 	
#		area_ratio_effect=None
#	2- by considering total IC area changes
#		area_ratio_mode=None 	
#		area_ratio_effect=LP_config_total 
#
# Approach 2 (Scaled number of EBs - area affect on EB height): 
#		area_ratio_mode=LP 	
#		area_ratio_effect=None

n_cores=8
area_ratio_mode=None 	
area_ratio_effect=None 

DSP_start=96
DSP_end=5664
DSP_step=96

make clean
for (( dsp=${DSP_start}; dsp<=${DSP_end}; dsp+=${DSP_step} )); do
    make run_script 	dsp=${dsp}   	n_cores=${n_cores}		area_ratio_mode={area_ratio_mode}
	make clean
done

for (( dsp=${DSP_start}; dsp<=${DSP_end}; dsp+=${DSP_step} )); do
    make plot_speedup_per_benchmarks 	exp_dir=./results/DSP${dsp} 	area_ratio_effect=${area_ratio_effect}
done

python3 plot_speedup_per_NumOfDSPs.py
Rscript plot_speedup_per_NumOfDSPs.R
Rscript plot_speedup_per_NumOfDSPs_line.R
