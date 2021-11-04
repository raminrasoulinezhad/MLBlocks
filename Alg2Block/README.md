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
│	│   └─── To generate Figure 
│	├──script_table_II.py
│	│   └─── To generate Figure 
│	├──script_table_III.py
│	│   └─── To generate Figure 
│	├──script_scatter_plot.py
│	│   └─── To generate Figure 
│	├──script_table_intel.py
│	│   └─── To generate Figure 
│	└──main.py
│	    └─── To test the framwork
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

	python3 script_table_I.py 			
	python3 script_table_II.py
	python3 script_table_III.py
	python3 script_scatter_plot.py

Results: 
	
	../verilog/MLBlock_2Dflex_interconnects.sv
	../verilog/MLBlock_2Dflex_params.sv

Using the other files in `../verilog` directory you can synthesis the MLBlock architecture. 





# TODO:

### full search 

### 1D superflex architecture

### among window-able parameters, fx is now the only which can be windowed. 

It is fine in our case. However, this is wrong in general. Any parameter, 1) which is used for indexing the Inputs (I, W, O) and 2) does not appear in the output (O), while is accompanied by another parameter(s) in an input indexing, can be windowed. 

In our eight-nested loop supermodel, **fx** and **fy** are those candidates. However, windowing both **fx** and **fy** does not make sense in practice. Since a line buffer per dot-product is required. Thus, we decided to make fx the only window-able parameter. (**fy** is not appearing in 1D algorithms). Note, **fx**, **fy** and **fz** are parameters different dimensions of the same characteristics)

# File notes:

### benchmark_archs

To define the configurations use a dictionary of configurations (key: name, value: dictionary of unrollings). Dictionary of unroolings is a dictionary (key: parameter name, value: unroling of that parameter in that configuration). like this:

	configs={
		"conf_0" : {
			"d":	4,
			"b":	1,
			"k":	1,
			"c":	1,
			"y":	1,
			"x":	1,
			"fy":	1,
			"fx":	3
		},
	}			

### Buffer sizes:

To support 8x8:

	I_D		= 2
	W_D		= 1
	Res_D 	= 1

To support 8x8 and 8x16:

	I_D		= 2
	W_D		= 2
	Res_D 	= 1

To support 8x8 and 16x8:

	I_D		= 4
	W_D		= 1
	Res_D 	= 1

To support 8x8, 8x16, 16x8, and 16x16:

	I_D		= 4
	W_D		= 2
	Res_D 	= 1

** To support multiple weight buffer (such as K weight): **

	I_D		= I_D
	W_D		= W_D * K
	Res_D 	= Res_D * K

### Utilization rate:

	util = V^{count} / \hat{V}^{count}
	if (V^{s} is multiple of \hat{V}^{s})
		util *= \hat{V}^{s} / V^{s}
	else:
	 	util = 0

### best MLBlock pareto:
