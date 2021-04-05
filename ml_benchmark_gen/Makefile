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

plot:
	python3 plot.py
