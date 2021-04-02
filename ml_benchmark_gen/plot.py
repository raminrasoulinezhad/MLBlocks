import numpy as np

import pandas as pd
import matplotlib.pyplot as plt

mlb12_configs = 5 		# 9
mlb9_configs = 4 		# 8
mlb_xilinx_configs = 2 	# 4

layers = []
f = open('./results/outputs/layers_orders.out', "r")
for x in f:
	if x != '\n':
		layers.append(x[:-6])

num_of_layers = len(layers)
print(layers)
print(num_of_layers)

configs = []
f = open('./results/outputs/mlbs_orders.out', "r")
for x in f:
	if x != '\n':
		configs.append(x[:-1])
num_of_configs = len(configs)
print(configs)
print(num_of_configs)

scores = []
f = open('./results/outputs/scores.out', "r")
for x in f:
	if x != '\n':
		scores.append(int(x[:-5]))

scores = np.array(scores) 
scores = scores.reshape((num_of_layers, num_of_configs))
print(scores)

mlb12 = (scores[:,:mlb12_configs]).min(axis=1)
mlb9 = (scores[:,mlb12_configs:mlb12_configs+mlb9_configs]).min(axis=1)
xilinx = (scores[:,mlb12_configs+mlb9_configs:]).min(axis=1)

print(mlb12)
print(mlb9)
print(xilinx)

mlb12_area_ratio = 	1 # 0.85, 1.44
mlb9_area_ratio = 	1 # 0.66, 1.20
mlb8_area_ratio = 	1 # 0.56, 0.96
mlb6_area_ratio = 	1 # 0.46, 0.80

speed_up_mlb12 = (xilinx / mlb12) * (1/mlb12_area_ratio)
speed_up_mlb9 = (xilinx / mlb9) * (1/mlb9_area_ratio)

s = len(speed_up_mlb12)

plot_array = np.ones((s,3))

for i in range(s):
	plot_array[i,0] = speed_up_mlb12[i]
	plot_array[i,1] = speed_up_mlb9[i]
print(plot_array)

# https://pandas.pydata.org/pandas-docs/version/0.13/visualization.html
# https://pandas.pydata.org/pandas-docs/stable/user_guide/visualization.html

df2 = pd.DataFrame(plot_array, columns=["mlb12", "mlb9", "DSP48"], index=layers)
df2.plot.bar();
plt.show()


#df2 = pd.DataFrame(np.random.rand(10, 4), columns=["a", "b", "c", "d"])
#df2.plot.bar();
#plt.show()
#exit()
