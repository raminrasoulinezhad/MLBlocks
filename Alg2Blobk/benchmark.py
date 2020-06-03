from models import *

my_space = Space("space",
				{	"d":	Param("IOW",	window_en=False),
					"b":	Param("IO",		window_en=False),
					"k":	Param("WO",		window_en=False),
					"c":	Param("IW",		window_en=False),
					"y":	Param("IO",		window_en=False),
					"x":	Param("IO",		window_en=False),
					"fy":	Param("IW",		window_en=False),	# logically True
					"fx":	Param("IW",		window_en=True)			
				})



alg_BSConv = Algorithm("BSConv", 
						{	"d":	None,
							"b":	[1,2,4],
							"k":	[32,64,128,256,512,1024],
							"c":	[3,32,64,128,256,512,1024],
							"y":	[2,4,8,16,32],
							"x":	[2,4,8,16,32],
							"fy":	[3,5,7,9],
							"fx":	[3,5,7,9]
						}, my_space)

alg_BDWConv = Algorithm("BDWConv", {
							"d":	[32,64,128,256,512,1024],
							"b":	[1,2,4],
							"k":	None,
							"c":	None,
							"y":	[2,4,8,16,32],
							"x":	[2,4,8,16,32],
							"fy":	[3,5,7,9],
							"fx":	[3,5,7,9]
						}, my_space)

alg_BPWConv = Algorithm("BPWConv", 
						{	"d":	None, 
							"b":	[1,2,4], 
							"k":	[32,64,128,256,512], 
							"c":	[32,64,128,256,512], 
							"y":	[2,4,8,16,32], 
							"x":	[2,4,8,16,32], 
							"fy":	None, 
							"fx":	None 
						}, my_space)

alg_BMM = Algorithm("BMM", 
						{	"d":	None, 
							"b":	[1,2,4], 
							"k":	[32,64,128,256,512,1024,2048], 
							"c":	[32,64,128,256,512,1024,2048], 
							"y":	None, 
							"x":	[32,64,128,256,512,1024,2048], 
							"fy":	None, 
							"fx":	None 
						}, my_space)



# light versions
alg_BSConv_light = Algorithm("BSConv", 
						{	"d":	None,
							"b":	[1,2,4],
							"k":	[32,64,128],
							"c":	[3,32,64,128],
							"y":	[2,8,32],
							"x":	[2,8,32],
							"fy":	[3,5,7],
							"fx":	[3,5,7]
						}, my_space)

alg_BDWConv_light = Algorithm("BDWConv", {
							"d":	[32,64,128,256],
							"b":	[1,2,4],
							"k":	None,
							"c":	None,
							"y":	[2,8,32],
							"x":	[2,8,32],
							"fy":	[3,5,7],
							"fx":	[3,5,7]
						}, my_space)

alg_BPWConv_light = Algorithm("BPWConv", 
						{	"d":	None, 
							"b":	[1,2,4], 
							"k":	[32,64,128,256], 
							"c":	[32,64,128,256], 
							"y":	[2,8,32], 
							"x":	[2,8,32], 
							"fy":	None, 
							"fx":	None 
						}, my_space)

alg_BMM_light = Algorithm("BMM", 
						{	"d":	None, 
							"b":	[1,2,4], 
							"k":	[32,64,128], 
							"c":	[32,64,128], 
							"y":	None, 
							"x":	[32,64,128], 
							"fy":	None, 
							"fx":	None 
						}, my_space)


algs = [alg_BSConv, alg_BDWConv, alg_BPWConv, alg_BMM]
algs_light = [alg_BSConv_light, alg_BDWConv_light, alg_BPWConv_light, alg_BMM_light]


if __name__ == "__main__":

	for alg in algs:
		alg.print_param_dic()
		print(alg.case_gen(5))
		print()

	for alg in algs_light:
		alg.print_param_dic()
		print()
