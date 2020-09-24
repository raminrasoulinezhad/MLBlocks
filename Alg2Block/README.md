# MLBlocks - a generalization for desiging FPGA compute units to accelerate nested loop-based computations 

### Benchmark to MLBlock: 
This framework explore the benchmark algorithm and finds a set of valid configurations which are able to impleemnt the benchmarks with the best tiling possible. This is a Heuristic approach which is based on pruning the non-beneficiary configuration among the valid configurations.

How:

	python3 main.py

Results: 
	
	../verilog/MLBlock_2Dflex_interconnects.sv
	../verilog/MLBlock_2Dflex_params.sv


### best MLBlock pareto:


# requirements 

    pip3 install mip numpy



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

