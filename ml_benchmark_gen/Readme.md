## Regenerating our results:

1- download the `verilog_ml_benchmark_generator` repository.

	git clone https://github.com/eroor8/verilog_ml_benchmark_generator.git

2- creat an appropriate virtual python3 environment:

	pip install --upgrade pip
	virtualenv -p /usr/bin/python3.7 venv
	source venv/bin/activate
	pip install  click python_constraint numpy pymtl3 jsonschema pytest PyYAML prettytable 	pandas matplotlib

3- install the `verilog_ml_benchmark_generator` package
	
	cd verilog_ml_benchmark_generator
	git checkout 694fc9ced131cb44ebd3b8b0175599f6ab42882

you need to modify three points: 
P1: Makefile, line 36, modify, 
	
	find . -name '*.egg' -exec rm -fr {} +

<!-- P2: verilog_ml_benchmark_generator/constraint_evaluation.py, line 64, add

	print('Cycles\ttotal: ', total_cycles, '\tproduct: ', product_cycles, '\tpreload: ', preload_cycles, '\tpipe: ', pipeline_count)
-->

P3: verilog_ml_benchmark_generator/generate_modules.py, line 1043 (1036), add
	
	raise Exception ('ramin: I am done!')

then install the package

	make install
	cd ..

4- run the experiment script

first prepare the required directories:

	make clean

then run the script:

	make run_script

or the transposed one:

	make run_script_t

or if you have a good mahcine with high number of cpu cores

	make run_script_u

5- plt the result

	python3 plot.py


## Introduction and requirements:
This manual starts with commands using python3 rather than the executable files.

To run them, there is a requirements.txt file. 	

	pip install --upgrade pip
	virtualenv -p /usr/bin/python3.7 venv
	source venv/bin/activate
	pip install  click python_constraint numpy pymtl3 jsonschema pytest PyYAML prettytable		

<!---
	 Worked
	# worked with previous versions
	# python -m pip install -r requirements.txt
	# python -m pip install -r requirements_dev.txt 

--->

I've mostly been running the code by adding unit tests (all in /tests) 
- and the tests that run the user facing commands are in test_generate_modules.py. 

The unit test 'test_simulate_layer_intel' for example runs simulation with my model of the intel block and a specific projection, simulates the system and then validates the output. 

The test 'test_generate_layer_intel' generates verilog for three Mobilenet layers with the intel block and runs ODIN. On my machine these tests all pass, but some of them require ODIN or VTR to be installed. 


To run all unit tests that don't require odin or take a particularly long time: 

	pytest tests/ -k "not longtest and not requiresodin"
    
To run a small simulation test with the intel block: 

    pytest tests/test_generate_modules.py::test_simulate_layer_intel


To generate verilog for 3 layers of MobileNet + the intel block:  
	
	pytest tests/test_generate_modules::test_generate_layer_intel 
    
Right now this test assumes there are 1000 ML blocks available on the device, takes about 20 minutes to run, and doesn't run simulation

The command line hooks could use some work since I've mostly been using unit tests, which run things slightly differently. The latest commands for simulating the system and generating verilog are these though:

## Examples:

**To see the helps:**

	python3 ./verilog_ml_benchmark_generator/cli.py --help
	python3 ./verilog_ml_benchmark_generator/cli.py generate-accelerator-verilog --help

**To generate verilog (This generates test_module.v):**

Note (some modifications along time):

	mlb_definition --> eb_definition
Sample 1: (***Failed***)

	python3 ./verilog_ml_benchmark_generator/cli.py generate-accelerator-verilog \
		--module_name "test_module" \
		--eb_definition ./tests/mlb_spec_intel.yaml \
		--act_buffer_definition ./tests/input_spec_2.yaml \
		--weight_buffer_definition ./tests/weight_spec_1.yaml \
		--emif_definition ./tests/emif_spec_1.yaml \
		--mapping_vector_definition ./tests/projection_spec_cs.yaml

My sample 2: (***OK***)

	python3 ./verilog_ml_benchmark_generator/cli.py generate-accelerator-verilog \
		--module_name "test_module" \
		--eb_definition ./tests/mlb_spec_0.yaml \
		--act_buffer_definition ./tests/input_spec_2.yaml \
		--weight_buffer_definition ./tests/weight_spec_1.yaml \
		--emif_definition ./tests/emif_spec_1.yaml \
		--mapping_vector_definition ./tests/projection_spec_0.yaml

My sample 3: (***OK***) 

	python3 ./verilog_ml_benchmark_generator/cli.py generate-accelerator-verilog \
		--module_name "test_module" \
		--eb_definition ./tests/mlb_spec_0.yaml \
		--act_buffer_definition ./tests/input_spec_0.yaml \
		--weight_buffer_definition ./tests/weight_spec_0.yaml \
		--emif_definition ./tests/emif_spec_0.yaml \
		--mapping_vector_definition ./tests/projection_spec_0.yaml  

There is a issue with this command. There are few module names including "{}". probably it is used by python code to creat module names. However, it seems that it is not working. Sample of module names:
	
	HWB_Sim__spec_ml_block_input__projs_{}__sim_True__fast_gen_False
	MLB_Wrapper__spec_ml_block__projs_{}__sim_True__fast_gen_False


**To simulate the pyMTL system (this takes a couple minutes): (OK)**

	python3 ./verilog_ml_benchmark_generator/cli.py simulate-accelerator-with-random-input \
		--module_name "test_module" \
		--eb_definition ./tests/mlb_spec_0.yaml \
		--act_buffer_definition ./tests/input_spec_0.yaml \
		--weight_buffer_definition ./tests/weight_spec_0.yaml \
		--emif_definition ./tests/emif_spec_0.yaml \
		--mapping_vector_definition ./tests/projection_spec_0.yaml  

The automatic validation of the simulation output in this command works in this particular case but it is buggy in other cases. The unit tests validate the output separately and that version is more stable. 

## install Odin:
1) download VTR from github:

	https://github.com/verilog-to-routing/vtr-verilog-to-routing

2) open the main directory ($VTR_ROOT = vtr-verilog-to-routing):
	
	cd $VTR_ROOT

3) run the make file to install all (including odin, ...)
		
	make
	$VTR_ROOT/vtr_flow/scripts/run_vtr_task.pl basic_flow

Potential Errors:

Instalation requires cmake 3.9 or higher. to install cmake: https://stackoverflow.com/questions/49859457/how-to-reinstall-the-latest-cmake-version or https://graspingtech.com/upgrade-cmake/
	
	cmake --version
	
If you installed Xilinx products, the working address for cmake would be in the Xilinx directories. To see whether it is the case:  

	which cmake
To add the path of the installed app in /usr/bin (https://stackoverflow.com/questions/64346732/i-have-an-issue-about-cmake-version)

	export PATH=/usr/bin:$PATH
	which cmake
	cmake --version

If the installation rase inregard to EXECUTABLE_BISON:

	sudo apt-get install flex bison

## Draft of Foundings:

	MLB__fb3d2fc4582b5637
		MACWrapper__2570a742c0bec816
			MAC__16b56ee7dc61f181


	test_module_odin.v 					--> VTR (ODIN)
	test_module_pymtl.v 				--> Don't use it 
	test_module_quartus_vivado.sv 		--> Quartus and Vivado (the regression and unit tests test with modelsim)

The generated verilog instantiates three types of hard blocks: 

1- The ML Blocks (embedded tensor blocks or DSPs),
2- The memories 
3- EMIF 

My Error:

	This explains the problem you are seeing, since the circuit is instantiating the embedded block "ml_block_weights" (the name and input and output ports are specified in the **weight_buffer_definition** input file) which doesn't correspond to an actual Vivado block. This will also probably be a problem with the ML blocks and EMIF. 

Solution 1:

If you use VTR, then you would need to define embedded memory blocks, tensor blocks and EMIF in your VTR architecture definition .xml, which is pretty straightforward. 

With Quartus and Vivado, the names of the embedded blocks and their input and output ports (specified in the yaml files) need to be updated so the circuit correctly instantiates Quartus/Vivado embedded blocks or IPs. I'll work on adding an example that instantiates Quartus embedded blocks and IPs, and Vivado should be similar. 

Solution 2:

There is also the option to replace all these hardened blocks with soft logic, if you set --include_sv_sim_models "True". This should allow you to compile successfully, but it would create inefficient soft-logic simulation models of hard blocks instead of instantiating embedded blocks. 

You could also try running the examples in examples.sh, which compile using ODIN (instantiating the embedded blocks specified in the VTR architecture .xml) and modelsim (using soft logic simulation models of embedded blocks). Let me know if you have more questions!

	
### Set this before using VTR commands:
1- use absolute address

	VTR_FLOW_PATH=/home/ramintp/workspaces/vtr-verilog-to-routing/vtr_flow/scripts/run_vtr_flow.py

Use this to prevent memory leakage error (source: https://stackoverflow.com/questions/51060801/how-to-suppress-leaksanitizer-report-when-running-under-fsanitize-address):

	export ASAN_OPTIONS=detect_leaks=0


### Bechmark

CONV layers:

Input Size                                          # of Filters    Padding Stride (h, w)   
W = 700,H = 161,C = 1,      N = 32  R = 5, S = 20   32              0,0     2, 2 
W = 54, H = 54, C = 64,     N = 8   R = 3, S = 3    64              1,1     1, 1    
W = 224,H = 224,C = 3,      N = 16  R = 3, S = 3    64              1,1     1, 1 
W = 7,  H = 7,  C = 512,    N = 16  R = 3, S = 3    512             1,1     1, 1 
W = 28, H = 28, C = 192,    N = 16  R = 5, S = 5    32              2,2     1, 1 

W = 341,H = 79, C = 32,     N = 4   R = 5, S = 10   32              0,0     2, 2  
W = 224,H = 224,C = 3,      N = 1   R = 7, S = 7    64              3,3     2, 2 
W = 56, H = 56, C = 256,    N = 1   R = 1, S = 1    128             0,0     2, 2 
W = 7,  H = 7,  C = 512,    N = 2   R = 1, S = 1    2048            0,0     1, 1 


W = 112,H = 112,C = 64, 	N = 1 	R = 1, S = 1 	64 				0, 0 	1, 1
W = 56, H = 56, C = 256, 	N = 1 	R = 1, S = 1 	128 			0, 0 	2, 2
W = 7, 	H = 7, 	C = 512, 	N = 1 	R = 1, S = 1 	2048 			0, 0 	1, 1


GEMM:

Kernel 					A (T) 	B (T) 	
M=1760, N=128, 	K=1760 	N 		N 		
M=7860, N=64, 	K=2560 	N 		N 		
M=2560, N=64, 	K=2560 	N 		N 		
M=5124, N=9124, K=2560 	T 		N 		
M=3072, N=128, 	K=1024 	T 		N 		

M=5124, N=700, 	K=2048 	
M=35, 	N=700, 	K=2048 	
M=3072, N=3000, K=1024 	
M=512, 	N=6000, K=2816 	

M=7680, N=1, 	K=2560
M=7680, N=2, 	K=2560
M=7680, N=1500, K=2560
M=10752,N=1, 	K=3584

M=5124, N=700, 	K=2048
M=35, 	N=700, 	K=2048
M=3072, N=1500, K=1024

M=7680, N=1, 	K=2560
M=7680, N=1500, K=2560
M=7680, N=1, 	K=2560

RNNs:

Hidden 	Batch  	TimeSteps 	Type 		
1760 	16 		50 			Vanilla 	
2560 	32 		50 			Vanilla 	
1024 	128 	25 			LSTM 		
2816 	32 		1500 		GRU 		

1536 	4 		50 			LSTM
256 	4 		150 		LSTM
2816 	1 		1500 		GRU 
2560 	2 		375 		GRU 

Vanila RNN:  B [ h x 2h] x [2h x h]
LSTM:        B [4h x 2h] x [2h x h]
GRU:         B [3h x 2h] x [2h x h]