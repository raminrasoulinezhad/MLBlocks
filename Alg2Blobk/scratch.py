# ML benchmark - EfficientNet
custom_kernel_SConv_ML = Algorithm("SConv", 
						{	"d":	None,
							"b":	None,
							"k":	[32],
							"c":	[3],
							"y":	[224],
							"x":	[224],
							"fy":	[3],
							"fx":	[3]
						}, my_space, case_gen_method="specific_samples")