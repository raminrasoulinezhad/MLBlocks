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
							choices=['LP_config', 'LHP_config', 'None'], 
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
	
	mlb12_configs = mlb9_configs = mlb8_configs = mlb6_configs = mlb_xilinx_configs = 0
	for config in configs:
		if re.match(r"mlb12_c[0-9]_spec", config):
			mlb12_configs += 1
		elif re.match(r"mlb9_c[0-9]_spec", config):
			mlb9_configs += 1
		elif re.match(r"mlb8_c[0-9]_spec", config):
			mlb8_configs += 1
		elif re.match(r"mlb6_c[0-9]_spec", config):
			mlb6_configs += 1
		elif re.match(r"mlb_spec_xilinx_mode[0-9]", config):
			mlb_xilinx_configs += 1		
		 	
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
	xilinx = 	(scores[: , end		:	end + mlb_xilinx_configs]).min(axis=1)

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


	speed_up_mlb12 = (xilinx / mlb12) * (1/mlb12_area_ratio)
	speed_up_mlb9 = (xilinx / mlb9) * (1/mlb9_area_ratio)
	speed_up_mlb8 = (xilinx / mlb8) * (1/mlb8_area_ratio)
	speed_up_mlb6 = (xilinx / mlb6) * (1/mlb6_area_ratio)

	s = len(speed_up_mlb12)
	plot_array = np.ones((s,5))

	for i in range(s):
		plot_array[i,0] = speed_up_mlb12[i]
		plot_array[i,1] = speed_up_mlb9[i]
		plot_array[i,2] = speed_up_mlb8[i]
		plot_array[i,3] = speed_up_mlb6[i]
	print(plot_array)

	# https://pandas.pydata.org/pandas-docs/version/0.13/visualization.html
	# https://pandas.pydata.org/pandas-docs/stable/user_guide/visualization.html
	df2 = pd.DataFrame(plot_array, columns=["mlb12", "mlb9", "mlb8", "mlb6", "DSP48"], index=layers)
	df2.plot.bar();
	plt.savefig(args.dir + '/plot_detailed.png');
	np.savetxt(args.dir + '/plot_detailed.csv', plot_array, delimiter=",")

	conv_layers = mm_layers = rnn_layers = 0
	for layer in layers:
		if re.match(r"conv_t_[0-9]+", layer):
			conv_layers += 1
		elif re.match(r"mm_t_[0-9]+", layer):
			mm_layers += 1
		elif re.match(r"rnn_t_[0-9]+", layer):
			rnn_layers += 1

	print (conv_layers, mm_layers, rnn_layers)
	
	end = 0
	benchmark_convs	= 	(plot_array[end : end + conv_layers	, :]).mean(axis=0)
	end += conv_layers 
	benchmark_mms	=	(plot_array[end	: end + mm_layers	, :]).mean(axis=0)
	end += mm_layers
	benchmark_rnns 	=	(plot_array[end	: end + rnn_layers	, :]).mean(axis=0)
	benchmark_all	= 	(plot_array).mean(axis=0)

	plot_array_2 = np.ones((4,5))
	for i in range(5):
		plot_array_2[0,i] = benchmark_convs[i]
		plot_array_2[1,i] = benchmark_mms[i]
		plot_array_2[2,i] = benchmark_rnns[i]
		plot_array_2[3,i] = benchmark_all[i]
	print(plot_array_2)

	df2 = pd.DataFrame(plot_array_2, columns=["mlb12", "mlb9", "mlb8", "mlb6", "DSP48"], index=["Convs", "GEMM", "RNNs", "Average"])
	df2.plot.bar();
	plt.savefig(args.dir + '/plot_compressed.png');
	np.savetxt(args.dir + '/plot_compressed.csv', plot_array_2, delimiter=",")
	#plt.show()
	