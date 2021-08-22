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

enable_exp=0
enable_dotout=0
enable_csv=1
enable_plot_all=0

DSP_start=360	#96
DSP_end=360		#9216
DSP_step=96

if [ $enable_exp -eq 1 ] ; then
	for (( dsp=${DSP_start}; dsp<=${DSP_end}; dsp+=${DSP_step} )); do
	    make clean
	    make run_script dsp=${dsp} \
	    				n_cores=${n_cores}	\
	    				area_ratio_mode=${area_ratio_mode} 
	done
fi

if [ $enable_dotout -eq 1 ] ; then
	for (( dsp=${DSP_start}; dsp<=${DSP_end}; dsp+=${DSP_step} )); do
		./script.sh ${dsp} \
					${n_cores} \
					${area_ratio_mode} \
					0 \
					./results/DSP${dsp} \
					./results/tempDSP${dsp}
	done
fi

if [ $enable_csv -eq 1 ] ; then
	for (( dsp=${DSP_start}; dsp<=${DSP_end}; dsp+=${DSP_step} )); do
	    make plot_speedup_per_benchmarks_compare 	exp_dir=./results/DSP${dsp} 	area_ratio_effect=${area_ratio_effect}
	done
fi

if [ $enable_plot_all -eq 1 ] ; then
	python3 plot_speedup_per_NumOfDSPs.py
	Rscript plot_speedup_per_NumOfDSPs.R
	Rscript plot_speedup_per_NumOfDSPs_line.R
fi
