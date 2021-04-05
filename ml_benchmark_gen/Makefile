clean:
	mkdir -p results
	mkdir -p results/outputs
	mkdir -p results/temp
	rm -rf results/outputs/*
	rm -rf results/temp/*

run_script:
	chmod +x ./script.sh
	./script.sh

run_script_t:
	chmod +x ./script_t.sh
	./script_t.sh

plot:
	python3 plot.py

plot_t:
	python3 plot.py --transpose
