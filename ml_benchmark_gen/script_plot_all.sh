make clean
for dsp in {96..12288..96}
do 
    make run_script dsp=${dsp}    n_cores=35
	make clean
done

python3 plot_speedup_per_NumOfDSPs.py
Rscript plot_speedup_per_NumOfDSPs.R
