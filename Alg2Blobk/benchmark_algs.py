from Algorithm import Algorithm
from benchmark_space import * 

# Sample benchmark
custom_kernel_BSConv = Algorithm("BSConv", 
						{	"d":	None,
							"b":	[1,2,4],
							"k":	[32,64,128,256,512,1024],
							"c":	[3,32,64,128,256,512,1024],
							"y":	[2,4,8,16,32],
							"x":	[2,4,8,16,32],
							"fy":	[3,5,7,9],
							"fx":	[3,5,7,9]
						}, my_space)

custom_kernel_BDWConv = Algorithm("BDWConv", {
							"d":	[32,64,128,256,512,1024],
							"b":	[1,2,4],
							"k":	None,
							"c":	None,
							"y":	[2,4,8,16,32],
							"x":	[2,4,8,16,32],
							"fy":	[3,5,7,9],
							"fx":	[3,5,7,9]
						}, my_space)

custom_kernel_BPWConv = Algorithm("BPWConv", 
						{	"d":	None, 
							"b":	[1,2,4], 
							"k":	[32,64,128,256,512], 
							"c":	[32,64,128,256,512], 
							"y":	[2,4,8,16,32], 
							"x":	[2,4,8,16,32], 
							"fy":	None, 
							"fx":	None 
						}, my_space)

custom_kernel_BMM = Algorithm("BMM", 
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
custom_kernel_BSConv_light = Algorithm("BSConv", 
						{	"d":	None,
							"b":	[1,2,4],
							"k":	[32,64,128],
							"c":	[3,32,64,128],
							"y":	[2,8,32],
							"x":	[2,8,32],
							"fy":	[3,5,7],
							"fx":	[3,5,7]
						}, my_space)

custom_kernel_BDWConv_light = Algorithm("BDWConv", {
							"d":	[32,64,128,256],
							"b":	[1,2,4],
							"k":	None,
							"c":	None,
							"y":	[2,8,32],
							"x":	[2,8,32],
							"fy":	[3,5,7],
							"fx":	[3,5,7]
						}, my_space)

custom_kernel_BPWConv_light = Algorithm("BPWConv", 
						{	"d":	None, 
							"b":	[1,2,4], 
							"k":	[32,64,128,256], 
							"c":	[32,64,128,256], 
							"y":	[2,8,32], 
							"x":	[2,8,32], 
							"fy":	None, 
							"fx":	None 
						}, my_space)

custom_kernel_BMM_light = Algorithm("BMM", 
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


if __name__ == "__main__":

	for alg in custom_algs:
		alg.print_param_dic()
		print(alg.case_gen(5))
		print()

	for alg in custom_algs_light:
		alg.print_param_dic()
		print()
