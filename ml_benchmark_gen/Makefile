clean:
	mkdir -p results
	mkdir -p results/outputs
	mkdir -p results/temp
	rm -rf results/outputs/*
	rm -rf results/temp/*

dsp?=96
n_cores?=1
area_ratio_mode?="LP"
enable_exp?=1
dir_outputs?=./results/outputs
dir_temp?=./results/temp
run_script:
	chmod +x ./script.sh
	chmod +x ./exp.sh
	./script.sh ${dsp} ${n_cores} ${area_ratio_mode} ${enable_exp} ${dir_outputs} ${dir_temp}
	cp -r results/outputs results/DSP${dsp} 
	cp -r results/temp 	results/tempDSP${dsp} 

exp_dir?=./results/DSP120/
area_ratio_effect?=None 
plot_speedup_per_benchmarks:
	python3 plot_speedup_per_benchmarks.py --dir=${exp_dir} --area-ratio-effect=${area_ratio_effect}

plot_speedup_per_NumOfDSPs:
	python3 plot_speedup_per_NumOfDSPs.py
