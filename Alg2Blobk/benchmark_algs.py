from Algorithm import Algorithm
from benchmark_space import * 

# ############################################################################################################################################
# Custom benchmarks
# ############################################################################################################################################

# Sample benchmark
custom_kernel_BSConv = Algorithm("custom_kernel_BSConv", 
						{	"d":	None,
							"b":	[1,2,4],
							"k":	[32,64,128,256,512,1024],
							"c":	[3,32,64,128,256,512,1024],
							"y":	[2,4,8,16,32],
							"x":	[2,4,8,16,32],
							"fy":	[3,5,7,9],
							"fx":	[3,5,7,9]
						}, my_space)

custom_kernel_BDWConv = Algorithm("custom_kernel_BDWConv", {
							"d":	[32,64,128,256,512,1024],
							"b":	[1,2,4],
							"k":	None,
							"c":	None,
							"y":	[2,4,8,16,32],
							"x":	[2,4,8,16,32],
							"fy":	[3,5,7,9],
							"fx":	[3,5,7,9]
						}, my_space)

custom_kernel_BPWConv = Algorithm("custom_kernel_BPWConv", 
						{	"d":	None, 
							"b":	[1,2,4], 
							"k":	[32,64,128,256,512], 
							"c":	[32,64,128,256,512], 
							"y":	[2,4,8,16,32], 
							"x":	[2,4,8,16,32], 
							"fy":	None, 
							"fx":	None 
						}, my_space)

custom_kernel_BMM = Algorithm("custom_kernel_BMM", 
						{	"d":	None, 
							"b":	[1,2,4], 
							"k":	[32,64,128,256,512,1024,2048], 
							"c":	[32,64,128,256,512,1024,2048], 
							"y":	None, 
							"x":	[32,64,128,256,512,1024,2048], 
							"fy":	None, 
							"fx":	None 
						}, my_space)



# Sample benchmark - light versions
custom_kernel_BSConv_light = Algorithm("custom_kernel_BSConv_light", 
						{	"d":	None,
							"b":	[1,2,4],
							"k":	[32,64,128],
							"c":	[3,32,64,128],
							"y":	[2,8,32],
							"x":	[2,8,32],
							"fy":	[3,5,7],
							"fx":	[3,5,7]
						}, my_space)

custom_kernel_BDWConv_light = Algorithm("custom_kernel_BDWConv_light", {
							"d":	[32,64,128,256],
							"b":	[1,2,4],
							"k":	None,
							"c":	None,
							"y":	[2,8,32],
							"x":	[2,8,32],
							"fy":	[3,5,7],
							"fx":	[3,5,7]
						}, my_space)

custom_kernel_BPWConv_light = Algorithm("custom_kernel_BPWConv_light", 
						{	"d":	None, 
							"b":	[1,2,4], 
							"k":	[32,64,128,256], 
							"c":	[32,64,128,256], 
							"y":	[2,8,32], 
							"x":	[2,8,32], 
							"fy":	None, 
							"fx":	None 
						}, my_space)

custom_kernel_BMM_light = Algorithm("custom_kernel_BMM_light", 
						{	"d":	None, 
							"b":	[1,2,4], 
							"k":	[32,64,128], 
							"c":	[32,64,128], 
							"y":	None, 
							"x":	[32,64,128], 
							"fy":	None, 
							"fx":	None 
						}, my_space)

custom_algs = [custom_kernel_BSConv, custom_kernel_BDWConv, custom_kernel_BPWConv, custom_kernel_BMM]
custom_algs_light = [custom_kernel_BSConv_light, custom_kernel_BDWConv_light, custom_kernel_BPWConv_light, custom_kernel_BMM_light]


# ############################################################################################################################################
# Baidu - DeepBench
# ############################################################################################################################################

# --- GEM --- source: https://github.com/baidu-research/DeepBench
# 	Various conditions:  
#		1) training  
# 		2) Inference Server  
# 		3) Inference Server+sparce  
# 		4) Inference Device  
# 		5) Inference Device+sparce
# 			few of them are repeated which we also repeated them. 
baidu_kernel_GEMM = Algorithm("baidu_kernel_GEMM", 
						{	"d":	None,
							"b":	None,
							"k":	[128,	64,		64,		9124,	128,		700,	700,	3000,	6000,		1,		2,		1500,	1,			700,	700,	1500,		1,		1500,	1	],
							"c":	[1760,	2560,	2560,	2560,	1024,		2048,	2048,	1024,	2816,		2560,	2560,	2560,	3584,		2048,	2048,	1024,		2560,	2560,	2560],
							"y":	None,
							"x":	[1760,	7860,	2560,	5124,	3072,		5124,	35,		3072,	512,		7680,	7680,	7680,	10752,		5124,	35,		3072,		7680,	7680,	7680],
							"fy":	None,
							"fx":	None
						}, my_space, case_gen_method="specific_samples")

# --- CNNs --- 
# 	Various conditions:  
# 		1) Training Results  
#		2) Inference Server  
# 		3) Inference Device

baidu_kernel_BSConv = Algorithm("baidu_kernel_BSConv", 
						{	"d":	None,
							"b":	[32,	8,		16,		16,		16,				4,	1,		1,	2,				1,	1,	1	],
							"k":	[32,	64,		64,		512,	32,				32,	64,		128,2048,			64,	128,2048],
							"c":	[1,		64,		3,		512,	192,			32,	3,		256,512,			64,	256,512	],
							"y":	[161,	1+54+1,	1+224+1,1+7+1,	2+28+2,			79,	3+224+3,56,	7,				112,56,	7	],
							"x":	[700,	1+54+1,	1+224+1,1+7+1,	2+28+2,			341,3+224+3,56,	7,				112,56,	7	],
							"fy":	[20,	3,		3,		3,		5,				10,	7,		1,	1,				1,	1,	1	],
							"fx":	[5,		3,		3,		3,		5,				5,	7,		1,	1,				1,	1,	1	]
						}, my_space, case_gen_method="specific_samples")
# 	stride: 						 2,		1,		1,		1,		1,				2,	2,		2,	1				1,	2,	1	

# --- RNNs --- 
# Inference Server
# majority of the LSTM computation: [] = [4h x (in | h)]  x  [(in / h) x B] --> (4h x in+h) x (in+h x B) --in our case In is equal to h --> (4h x 2h) x (2h x B) 
# majority of the GRU computation: 	[] = [3h x (in | h)]  x  [(in / h) x B] --> (3h x in+h) x (in+h x B) --in our case In is equal to h --> (3h x 2h) x (2h x B) 
# 
# 			Hidden, 	Batch, 	Time
#	LSTM:	1536,		4,		50		-->	(4x1536	 x  2x1536)	 	x 	(2x1536	 x  4)
#	LSTM:	256,		4,		150		-->	(4x256	 x  2x256) 		x 	(2x256	 x  4)
#	GRU:	2816,		1, 		1500	-->	(3x2816	 x  2x2816)	 	x 	(2x2816	 x  1)
#	GRU:	2560, 		2, 		375		-->	(3x2560	 x  2x2560)	 	x 	(2x2560	 x  2)
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

# ############################################################################################################################################
# UTDSP_test_suite
# ############################################################################################################################################
# it includes:
# 	1- FIR (256,64) and (32,1)
#	2- mmult (10,10,10) and (4,4,4)
# 	
# 	We don't include 
#		-- fft:		low data reusement and none sequentive data access pattern
#		-- IIR: 	To support that we need to add by pass to the windowing register circuit. 
# 		-- LATNRM:	loop dependency
#		-- lmsfir:	weight stationary does not support adaptive filters
utdsp_kernels = Algorithm("utdsp_kernels", 
						{	"d":	[1,		1,		1,	1],
							"b":	[1,		1,		1,	1],
							"k":	[1,		1,		10,	4],
							"c":	[1,		1,		10,	4],
							"y":	[1,		1,		1,	1],
							"x":	[64,	1,		10,	4],
							"fy":	[1,		1,		1,	1],
							"fx":	[256,	32,		1,	1]
						}, my_space, case_gen_method="specific_samples")

# ############################################################################################################################################
# A general 3-level Blass benchmark
# ############################################################################################################################################
# it includes:
# 	1- GEMM (B = 1 or 2)
#	2- GEMV (B = 1 or 2)
#	3- Dot product (B = 1 or 2)
#	4- Pointwise multiplication 
# #####################################
general_blass_kernels = Algorithm("general_blass_kernels", 
						{	"d":	[1,	1,	1,	1,	1,		1,	1,	1,	1,	1,		1,	1,	1,	1,	1,			1,	1,	1,	1,	1,		1,	1,	1,	1,	1,		1,	1,	1,	1,	1,			1,	1,	1,	1,	1	],
							"b":	[1,	1,	1,	1,	1,		1,	1,	1,	1,	1,		1,	1,	1,	1,	1,			2,	2,	2,	2,	2,		2,	2,	2,	2,	2,		2,	2,	2,	2,	2,			1,	1,	1,	1,	1	],
							"k":	[32,64,	128,256,512,	1,	1,	1,	1,	1,		1,	1,	1,	1,	1,			32,64,	128,256,512,	1,	1,	1,	1,	1,		1,	1,	1,	1,	1,			1,	1,	1,	1,	1	],
							"c":	[32,64,	128,256,512,	32,64,	128,256,512,	32,64,	128,256,512,		32,64,	128,256,512,	32,64,	128,256,512,	32,64,	128,256,512,		1,	1,	1,	1,	1	],
							"y":	[1,	1,	1,	1,	1,		1,	1,	1,	1,	1,		1,	1,	1,	1,	1,			1,	1,	1,	1,	1,		1,	1,	1,	1,	1,		1,	1,	1,	1,	1,			32,64,	128,256,512	],
							"x":	[32,64,	128,256,512,	32,64,	128,256,512,	1,	1,	1,	1,	1,			32,64,	128,256,512,	32,64,	128,256,512,	1,	1,	1,	1,	1,			32,64,	128,256,512	],
							"fy":	[1,	1,	1,	1,	1,		1,	1,	1,	1,	1,		1,	1,	1,	1,	1,			1,	1,	1,	1,	1,		1,	1,	1,	1,	1,		1,	1,	1,	1,	1,			1,	1,	1,	1,	1	],
							"fx":	[1,	1,	1,	1,	1,		1,	1,	1,	1,	1,		1,	1,	1,	1,	1,			1,	1,	1,	1,	1,		1,	1,	1,	1,	1,		1,	1,	1,	1,	1,			1,	1,	1,	1,	1	]
						}, my_space, case_gen_method="specific_samples")


if __name__ == "__main__":

	for alg in custom_algs:
		alg.print_param_dic()
		print(alg.case_gen(5))
		print()

	for alg in custom_algs_light:
		alg.print_param_dic()
		print()
