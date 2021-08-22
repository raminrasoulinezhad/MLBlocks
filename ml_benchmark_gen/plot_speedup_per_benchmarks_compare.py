import numpy as np
import argparse
import pandas as pd
import matplotlib.pyplot as plt
import re

def get_args():
	parser = argparse.ArgumentParser(description='')
	parser.add_argument('--dir', type=str, default='./results/outputs', 
							help='Directory of the cycle estimation results')
	parser.add_argument('--area-ratio-effect', type=str, default='LP_config', 
							choices=['LP_config', 'LHP_config', 'LP_config_total', 'LHP_config_total', 'None'], 
							help=' choose between these options: LP_config, LHP_config, None')
	return parser.parse_args()


if __name__ == "__main__":

	args = get_args()

	layers = []
	f = open(args.dir + '/layers_orders.out', "r")
	for x in f:
		if x != '\n':
			layers.append(x[:-6])
	num_of_layers = len(layers)
	print('%d number of layers: ' % (num_of_layers),  layers)

	configs = []
	f = open(args.dir + '/mlbs_orders.out', "r")
	for x in f:
		if x != '\n':
			configs.append(x[:-1])
	num_of_configs = len(configs)
	print('%d number of configurations: ' % (num_of_configs),  configs)
	
	mlb12_configs = mlb9_configs = mlb8_configs = mlb6_configs = mlb_DSP48E2_configs = mlb_DSP58_configs = mlb_PIRDSP_configs = mlb_Boutros_configs = 0
	for config in configs:
		if re.match(r"mlb12_c[0-9]_spec", config):
			mlb12_configs += 1
		elif re.match(r"mlb9_c[0-9]_spec", config):
			mlb9_configs += 1
		elif re.match(r"mlb8_c[0-9]_spec", config):
			mlb8_configs += 1
		elif re.match(r"mlb6_c[0-9]_spec", config):
			mlb6_configs += 1
		elif re.match(r"mlb_DSP48E2_mode[0-9]", config):
			mlb_DSP48E2_configs += 1		
		elif re.match(r"mlb_DSP58_mode[0-9]", config):
			mlb_DSP58_configs += 1	
		elif re.match(r"mlb_PIRDSP_mode[0-9]", config):
			mlb_PIRDSP_configs += 1	
		elif re.match(r"mlb_Boutros_mode[0-9]", config):
			mlb_Boutros_configs += 1	

	scores = []
	f = open(args.dir + '/scores.out', "r")
	for x in f:
		if x != '\n':
			scores.append(int(x[:-5]))
	scores = np.array(scores)
	scores = scores.reshape((num_of_layers, num_of_configs))	

	end = 0
	mlb12 = 	(scores[: , 		:	mlb12_configs			]).min(axis=1)
	end += mlb12_configs
	mlb6 = 		(scores[: , end		:	end + mlb6_configs		]).min(axis=1)
	end += mlb6_configs
	mlb8 = 		(scores[: , end		:	end + mlb8_configs		]).min(axis=1)
	end += mlb8_configs
	mlb9 = 		(scores[: , end		:	end + mlb9_configs		]).min(axis=1)
	end += mlb9_configs
	#Boutros = (scores[: , end		:	end + mlb_Boutros_configs]).min(axis=1)
	#end += mlb_Boutros_configs
	DSP48E2 = 	(scores[: , end		:	end + mlb_DSP48E2_configs]).min(axis=1)
	end += mlb_DSP48E2_configs
	DSP58 = 	(scores[: , end		:	end + mlb_DSP58_configs]).min(axis=1)
	end += mlb_DSP58_configs
	PIRDSP = 	(scores[: , end		:	end + mlb_PIRDSP_configs]).min(axis=1)
	end += mlb_PIRDSP_configs

	if args.area_ratio_effect == 'None':
		mlb12_area_ratio = 	1
		mlb9_area_ratio = 	1
		mlb8_area_ratio = 	1
		mlb6_area_ratio = 	1
	elif args.area_ratio_effect == 'LP_config':
		mlb12_area_ratio = 	0.85
		mlb9_area_ratio = 	0.66
		mlb8_area_ratio = 	0.56
		mlb6_area_ratio = 	0.46
	elif args.area_ratio_effect == 'LHP_config':
		mlb12_area_ratio = 	1.44
		mlb9_area_ratio = 	1.20
		mlb8_area_ratio = 	0.96
		mlb6_area_ratio = 	0.80
	elif args.area_ratio_effect == 'LP_config_total':
		mlb12_area_ratio = 	(1-(1-0.85)*0.05)
		mlb9_area_ratio = 	(1-(1-0.66)*0.05)
		mlb8_area_ratio = 	(1-(1-0.56)*0.05)
		mlb6_area_ratio = 	(1-(1-0.46)*0.05)
	elif args.area_ratio_effect == 'LHP_config_total':
		mlb12_area_ratio = 	(1-(1-1.44)*0.05)
		mlb9_area_ratio = 	(1-(1-1.20)*0.05)
		mlb8_area_ratio = 	(1-(1-0.96)*0.05)
		mlb6_area_ratio = 	(1-(1-0.80)*0.05)


	speed_up_mlb12 = (DSP48E2 / mlb12) * (1/mlb12_area_ratio)
	speed_up_mlb9 = (DSP48E2 / mlb9) * (1/mlb9_area_ratio)
	speed_up_mlb8 = (DSP48E2 / mlb8) * (1/mlb8_area_ratio)
	speed_up_mlb6 = (DSP48E2 / mlb6) * (1/mlb6_area_ratio)
	speed_up_DSP58 = (DSP48E2 / DSP58) * (1)
	#speed_up_Boutros = (DSP48E2 / Boutros) * (1)
	speed_up_PIRDSP = (DSP48E2 / PIRDSP) * (1)

	s = len(speed_up_mlb12)
	plot_array = np.ones((s,7))

	for i in range(s):
		plot_array[i,0] = speed_up_mlb12[i]
		plot_array[i,1] = speed_up_mlb9[i]
		plot_array[i,2] = speed_up_mlb8[i]
		plot_array[i,3] = speed_up_mlb6[i]
		plot_array[i,4] = speed_up_PIRDSP[i]
		#plot_array[i,5] = speed_up_Boutros[i]
		plot_array[i,5] = speed_up_DSP58[i]
	print(plot_array)

	# https://pandas.pydata.org/pandas-docs/version/0.13/visualization.html
	# https://pandas.pydata.org/pandas-docs/stable/user_guide/visualization.html
	df2 = pd.DataFrame(plot_array, columns=["mlb12", "mlb9", "mlb8", "mlb6", "PIRDSP", "DSP58", "DSP48E2"], index=layers)
	df2.plot.bar();
	plt.savefig(args.dir + '/plot_detailed.png');
	np.savetxt(args.dir + '/plot_detailed.csv', plot_array, delimiter=",")




	VGG_layers = ResNet_layers = 0
	for layer in layers:
		if re.match(r"VGG16_[0-9]+", layer):
			VGG_layers += 1
		elif re.match(r"ResNet18_[0-9]+", layer):
			ResNet_layers += 1

	print (VGG_layers, ResNet_layers)
	
	end = 0
	benchmark_VGG	= 	(plot_array[end : end + VGG_layers	, :]).mean(axis=0)
	end += VGG_layers 
	benchmark_ResNet=	(plot_array[end	: end + ResNet_layers	, :]).mean(axis=0)
	end += ResNet_layers
	benchmark_all	= 	(plot_array).mean(axis=0)

	plot_array_2 = np.ones((3,7))
	for i in range(7):
		plot_array_2[0,i] = benchmark_VGG[i]
		plot_array_2[1,i] = benchmark_ResNet[i]
		plot_array_2[2,i] = benchmark_all[i]
	print(plot_array_2)

	df2 = pd.DataFrame(plot_array_2, columns=["mlb12", "mlb9", "mlb8", "mlb6", "PIRDSP", "DSP58", "DSP48E2"], index=["VGG", "ResNet", "Average"])
	df2.plot.bar();
	plt.savefig(args.dir + '/plot_compressed.png');
	np.savetxt(args.dir + '/plot_compressed.csv', plot_array_2, delimiter=",")
	#plt.show()
	