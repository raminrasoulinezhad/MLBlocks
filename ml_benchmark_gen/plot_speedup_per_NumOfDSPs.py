import numpy as np
import argparse
import pandas as pd
import matplotlib.pyplot as plt
import re
import csv
import os

def get_args():
	parser = argparse.ArgumentParser(description='')
	parser.add_argument('--dir', type=str, default='./results', 
							help='Directory of the cycle estimation results')
	return parser.parse_args()

if __name__ == "__main__":

	args = get_args()

	DSP_dirs = []
	for DSP_dir in os.listdir(args.dir):
		if re.match(r"DSP[0-9]+", DSP_dir):
			DSP_dirs.append(DSP_dir[3:])

	DSP_dirs = [int(DSP_dir) for DSP_dir in DSP_dirs]
	DSP_dirs = sorted(DSP_dirs)
	DSP_names = DSP_dirs
	DSP_dirs = ['%s' % (args.dir + '/DSP' + str(DSP_dir)) for DSP_dir in DSP_dirs]			
	num_DSPs = len(DSP_dirs)	
	print(DSP_dirs)
	print(num_DSPs)

	plot_table = np.zeros((num_DSPs, 4))
	for index in range(num_DSPs):
		DSP_dir = DSP_dirs[index]

		f_name = DSP_dir + '/plot_compressed.csv'
		temp = np.genfromtxt(f_name, delimiter=',')
		temp = [i for i in temp[-1]]
		plot_table[index] = temp [:-1]

	print(plot_table)
	
	df = pd.DataFrame(plot_table, columns=["MLBlock-12", "MLBlock-9", "MLBlock-8", "MLBlock-6"], index=DSP_names)
	df.plot.bar();
	plt.savefig(args.dir + '/plot_speedup_per_NumOfDSPs.png');
	#np.savetxt(args.dir + '/plot_speedup_per_NumOfDSPs.csv', plot_table, delimiter=",")
	df.to_csv(args.dir + '/plot_speedup_per_NumOfDSPs.csv', index=True, header=True, sep=',', index_label='NumOfDSPs')
	plt.show()
	