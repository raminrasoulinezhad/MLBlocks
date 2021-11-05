# Alg2Block - MLBlock generation tool 

MLBlock architecture is a generalization for FPGA coarse-grained compute units to accelerate nested loop-based computations. Alg2Block is our suggested framework, which 1) analysis the input `benchmark` algorithms, 2) finds a set of valid `unrollings` and 3) computation `configurations` which an ideal block shall provide. Then, 4) using Heuristic `Selection` processes prune the configurations, and finally, 5) generates the block Verilog models. 

## requirements 

    pip3 install mip numpy

## How to use it:

### Code architecture:

```
Main Models:
├───Mains:
│	├──Algorithm.py
│	│   └─── Models the input algorithm by `Algorithm` class 
│	├───Arch.py
│	│   └─── Models the MLBlock architecture, and selections by `Arch` class 
│	├───Unrolling.py
│	│   └─── Models the MLBlock unrollings by `Unrolling` class
│	├───ImpConfig.py
│	│   └─── Models the MLBlock configurations by `ImpConfig` class
│	├───ImpConfig.py
│	│   └─── Models the MLBlock configurations by `ImpConfig` class
│	└───MLBlock_2Dflex.py
│	    └─── Generates Verilog models (interconnections and parameters)
│	
└───Minors:
	├───Param.py
	│   └─── Models a iteration variable
	├───Space.py
	│   └─── Models a nested loops variable
	└───utils.py
	    └─── usefull functions

Experiments:
├───Benchmarks (Define various study cases): 
│	├──benchmark_algs.py
│	│   └─── Defines input algorithm study cases. 
│	├──benchmark_archs.py
│	│   └─── Defines MLBlock architecture constraints
│	└──benchmark_space.py
│	    └─── Defines input algorithm nested loop space (dimentionality). 
│
│
├───Main Scripts (Generate results utilizing the right architecture, benchmark, and selection process): 
│	├──script_table_I.py
│	│   └─── To generate Table 2 in the manuscript.
│	├──script_table_II.py
│	│   └─── To generate Figure 12 and Table 3 in the manuscript.
│	├──script_table_III.py
│	│   └─── To generate Figure 13 in the manuscript.
│	├──script_scatter_plot.py
│	│   └─── To generate Figure 11 in the manuscript.
│	├──script_table_intel.py
│	│   └─── Not used in the paper. To explore intel-like EB architectures. 
│	└──main.py
│	    └─── Not used in the paper. To test the framwork. 
|
└───ASIC Scripts (custom API using RTL Encounter): 
	├──exp.sh*
	├──exp.tcl
	├──exp_v2.tcl
	├──tabulate.py
	└──Makefile
```

### Result re-production: 

To re-generate the results of the paper, please use the following commands: 

	python3 script_table_I.py 			# Table 2		
	python3 script_table_II.py 			# Table 3 and Figure 12
	python3 script_table_III.py 		# Figure 13
	python3 script_scatter_plot.py 		# Figure 14

Each commands produce enough logs which can be used to draw the Figures / plots / tables. Plese note some scripts requires accessing RTL Encounter on background. If it is not installed, it will pass the synthesis without generating the area/timing results. 

**The outputs are:**

1. verilog `interconnection` and `parameters` which will be generated per case in `../verilog` directory. Using the other files in `../verilog` directory you can synthesis the MLBlock architecture.  

		../verilog/MLBlock_2Dflex_interconnects.sv
		../verilog/MLBlock_2Dflex_params.sv

2. Some scripts copy the verilog and reports into the `../out` directory to be saved for additional experiments. This creats a new folder in `../out` keeping these files. For instance, the FPGA resouce experiments (Table 4) requires verilog files to synthesis them using vivado. 


### How to read the scripts (For instance: `python3 script_table_I.py`):

The scripts are responsible to instanciate the right architecture exploration, settings, configurations, constraints, etc. This starts by importing modules, classes, and usual libraries: like the followings: 

1. General libraries:

		import os

2. Alg2Block models:

		from Param import Param
		from Space import Space
		from Arch import Arch
		from Algorithm import Algorithm 		
		from Unrolling import Unrolling
		from ImpConfig import ImpConfig 

3. Pre-defined model instances:

		from benchmark_space import * 			# includes design space exploration definition (Dimentionality)
		from benchmark_algs import * 			# includes input algorithm definitions, using different benchmarks, i.e. Baidu DeepBench
		from benchmark_archs import * 			# includes architectural constraint definisions, using different EB targets, i.e. arch_12 defines the IO, MAC, .. constraints for a Xilinx EB with 12 MACs

4. Design space exploration & Block generation:

Then, the design exploration command is called. To do so, first the target architecture constraints is selected and the search technique is called over that. Look at the following sample:

	do_gen_hdl, do_synthesis = False, False 
	# heuristic approach  
	arch_12.search_heuristic_v2(baidu_algs, MLblock_version='v2', heuristic_mode='old', period=1333, verbose=False)

In this example, the flow will use heuristic approach (v2) for design space exploration, architecture constraints defined in `arch_12`, and `baidu` benchmark. In `python3 script_table_I.py` there are more design exploration commands, which search the ideal architecture using the same architecture constraints, but different search technques and settings. As shown the N-Config technique with different `subset_length` is used. Also, note, due to the compute intensity of searching with`subset_length > 3`, in the last two cases `do_gen_hdl` and `do_synthesis` flags are both off. 

	# N-Config seaches
	arch_12.search_area_in_loop(baidu_algs, subset_length=1, do_gen_hdl=do_gen_hdl, do_synthesis=do_synthesis, period=1333, MLblock_version='v2', objective='obj', verbose=False)
	arch_12.search_area_in_loop(baidu_algs, subset_length=2, do_gen_hdl=do_gen_hdl, do_synthesis=do_synthesis, period=1333, MLblock_version='v2', objective='obj', verbose=False)
	arch_12.search_area_in_loop(baidu_algs, subset_length=3, do_gen_hdl=do_gen_hdl, do_synthesis=do_synthesis, period=1333, MLblock_version='v2', objective='obj', verbose=False)
	arch_12.search_area_in_loop(baidu_algs, subset_length=4, do_gen_hdl=False, do_synthesis=False, period=1333, MLblock_version='v2', objective='util', verbose=False)
	arch_12.search_area_in_loop(baidu_algs, subset_length=5, do_gen_hdl=False, do_synthesis=False, period=1333, MLblock_version='v2', objective='util', verbose=False)


the same happends in other scripts. 

### How to read/modify the benchmark files:

**benchmark_space**

This defines the search space of benchmark algorithms which will be used to analyse the benchmark cases. In out case we have a 8-D space where each iteration variable group (R, E, B, and G) has different contributions (in our case 3, 1, 3, and 1 respectively). 

	my_space = Space("space",
		{	"d":	Param("IWO"),
			"b":	Param("IO"),
			"k":	Param("WO"),
			"c":	Param("IW"),
			"y":	Param("IO"),
			"x":	Param("IO", 	window_accompany=True),
			"fy":	Param("IW"),	# logically can be windowed as well
			"fx":	Param("IW",		windowed=True)			
		})


**benchmark_algs**

This defines the benchmarks for the design explorations, where a benchmark includes one or more algorithm samples, defined over the shared space. For instance, some RNN kernels from DeepBench, Baidu, can be defined as follows. Note, each column represent an algorithm case, where each entry shows the variable iterations for that loop, considering the defined space.

	baidu_kernel_LSTM = Algorithm("baidu_kernel_LSTM", 
		{	"d":	None,
			"b":	None,
			"k":	[4,		4,		1,		2],
			"c":	[3072,	512,	5632,	5120],
			"y":	None,
			"x":	[6144, 	1024,	8448,	7680],
			"fy":	None,
			"fx":	None
		}, my_space, case_gen_method="specific_samples")

In case, there is an stride for a variable, it can be defined by a tuple, `(# of iterations, stride)`. the following shows a sample fow Conv layers with stride: 
	
	
	baidu_kernel_BSConv = Algorithm("baidu_kernel_BSConv", 
		{	"d":	None,
			"b":	[32,		8,		16,		16,		16,			4,		1,			1,		2,				1,	1,		1	],
			"k":	[32,		64,		64,		512,	32,			32,		64,			128,	2048,			64,	128,	2048],
			"c":	[1,			64,		3,		512,	192,		32,		3,			256,	512,			64,	256,	512	],
			"y":	[(81,2),	54,		224,	7,		28,			(40,2),	(112,2),	(28,2),	7,				112,(28,2),	7	],
			"x":	[(350,2),	54,		224,	7,		28,			(171,2),(112,2),	(28,2),	7,				112,(28,2),	7	],
			"fy":	[20,		3,		3,		3,		5,			10,		7,			1,		1,				1,	1,		1	],
			"fx":	[5,			3,		3,		3,		5,			5,		7,			1,		1,				1,	1,		1	]
		}, my_space, case_gen_method="specific_samples")


**benchmark_archs**

This carries object instances of `Arch` class. For more details please chekc the `Arch` class in `Arch.py`. As a sample let's explore `arch_12` which is as follows:

	arch_12 = Arch("all_arch_12", 
			None, 
			my_space,
			stationary="W",
			precisions={	
							"I" : 8,
							"W" : 8,
							"O" : 32,
						},
			nmac=12,
			limits= {	
						"IO_I" : 36,
						"IO_W" : None,
						"IO_O" : 32*4,
						"IO" : None, 	
					}
			)

As shown after setting the object name, space, the stationary type is defined. Currently, we only support Weight-stationary as defined by "W". The precisions defines the MAC computaiton IO precisions which also defines the input/output signal precisions. `nmac` defines the number of MACs in the EB, which in this case should be `12`. `limits` defines the IO constraints which can be defined per input/output signals and/or in total. 

**Serial multiplier** 

To support serial multiplier, you need to add `subprecisions`, which defines 1) the shifter, 2) buffers, and 3) sequencer circuits. 

			subprecisions=	{	
				"I_D" : 4,
				"W_D" : 2,
				"RES_D" : 1,
				"SHIFTER_TYPE" : "2Wx2V_by_WxV",	
			},

Assuming the MAC precision as `AxB`, use this cheatsheet:

To support `AxB`:

	I_D		= 2
	W_D		= 1
	Res_D 	= 1

To support `AxB` and `Ax2B`:

	I_D		= 2
	W_D		= 2
	Res_D 	= 1

To support `AxB` and `2AxB`:

	I_D		= 4
	W_D		= 1
	Res_D 	= 1

To support `AxB`, `Ax2B`, `2AxB`, and `2Ax2B`:

	I_D		= 4
	W_D		= 2
	Res_D 	= 1

Also note, "2Wx2V_by_WxV" is the only supported shifer for serial multiplier feature.


**To support multiple weight buffering - data reusement (such as K weight for reusing the inputs K times):** 

	I_D		= I_D
	W_D		= W_D * K
	Res_D 	= Res_D * K


# TODO:

1. Full search, is not working. 

2. 1D superflex architecture is not explored. 

3. Among window-able parameters, fx is now the only which can be windowed. Although it is fine for our explorations, it is not generalized. 

4. the Best MLBlock - pareto:

<!--
### Utilization rate:

	util = V^{count} / \hat{V}^{count}
	if (V^{s} is multiple of \hat{V}^{s})
		util *= \hat{V}^{s} / V^{s}
	else:
	 	util = 0
-->
