make clean
for dsp in {96..12288..96}
do 
    make run_script_v2  dsp=${dsp}  n_cores=4  area_ratio_mode=LP
	make clean
done

python3 plot_speedup_per_NumOfDSPs.py
Rscript plot_speedup_per_NumOfDSPs.R
