import os
import pickle
import matplotlib.pyplot as plt

from Param import Param
from Space import Space
from Arch import Arch
from Algorithm import Algorithm
from Unrolling import Unrolling
from ImpConfig import ImpConfig 

from benchmark_space import * 
from benchmark_algs import * 
from benchmark_archs import * 

arch_12.search_area_in_loop(baidu_algs, subset_length=2, do_gen_hdl=False, do_synthesis=False, period=1333, MLblock_version='v2', objective='obj', verbose=False)
arch_12.search_area_in_loop(baidu_algs, subset_length=3, do_gen_hdl=False, do_synthesis=False, period=1333, MLblock_version='v2', objective='obj', verbose=False)

plt.figure(figsize=(8, 4))
plt.subplot(1, 2, 1)
subsetsearch = pickle.load(open("../experiments/MLBlock_2Dflex_12_2configs/subsetsearch.pkl", "rb"))
x_list, y_list, color = subsetsearch.plot_list_gen('area','util', [subsetsearch.best_index])
plt.scatter(x_list, y_list, color=color)
plt.title('2-Config')
plt.ylabel('Utilization rate')
plt.xlabel('Area')


plt.subplot(1, 2, 2)
subsetsearch = pickle.load(open("../experiments/MLBlock_2Dflex_12_3configs/subsetsearch.pkl", "rb"))
x_list, y_list, color = subsetsearch.plot_list_gen('area','util', [subsetsearch.best_index])
plt.scatter(x_list, y_list, color=color)
plt.title('3-Config')
plt.ylabel('Utilization rate')
plt.xlabel('Area')
#plt.show()
plt.savefig('Figure_3_autosave.png')
