clean:
	mkdir -p results
	mkdir -p results/outputs
	mkdir -p results/temp
	rm -rf results/outputs/*
	rm -rf results/temp/*

dsp ?= 9024
n_cores ?= 1
run_script:
	chmod +x ./script.sh
	chmod +x ./exp.sh
	./script.sh ${dsp} ${n_cores}

exp_dir?=./results/DSP120/
plot_speedup_per_benchmarks:
	python3 plot_speedup_per_benchmarks.py --dir=${exp_dir}

plot_speedup_per_NumOfDSPs:
	python3 plot_speedup_per_NumOfDSPs.py
