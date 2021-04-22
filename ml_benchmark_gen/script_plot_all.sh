# Approach 1: area_ratio_mode=None
# Approach 2: area_ratio_mode=LP

make clean
for dsp in {96..9216..96}
do 
    make run_script 	dsp=${dsp}   	n_cores=8		area_ratio_mode=None
	make clean
done

for dsp in {96..9216..96}
do 
    make plot_speedup_per_benchmarks exp_dir=./results/DSP${dsp} area_ratio_effect=None
done

python3 plot_speedup_per_NumOfDSPs.py
Rscript plot_speedup_per_NumOfDSPs.R
Rscript plot_speedup_per_NumOfDSPs_line.R
