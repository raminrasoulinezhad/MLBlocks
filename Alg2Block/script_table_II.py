import os

from Param import Param
from Space import Space
from Arch import Arch
from Algorithm import Algorithm
from Unrolling import Unrolling
from ImpConfig import ImpConfig 

from benchmark_space import * 
from benchmark_algs import * 
from benchmark_archs import * 

from tabulate import get_asic_results

print ('lets do synthesis for DSP48 which takes time. Please, be patient :) ')
os.system('cd ../asic && make clean && make asic_dsp  >/dev/null 2>&1')
area, freq, power = get_asic_results('../asic/', period=1333)
print ('area: %f\tfreq: %f\tpower: %f' % (area, freq, power))

# heuristic approach
arch_12.search_heuristic_v2(baidu_algs, MLblock_version='v2', period=1333, verbose=False)
arch_9.search_heuristic_v2 (baidu_algs, MLblock_version='v2', period=1333, verbose=False)
arch_8.search_heuristic_v2 (baidu_algs, MLblock_version='v2', period=1333, verbose=False)
arch_6.search_heuristic_v2 (baidu_algs, MLblock_version='v2', period=1333, verbose=False)

#arch_12.search_area_in_loop(baidu_algs, subset_length=2, do_gen_hdl=True, do_synthesis=True, period=1333, MLblock_version='v2', objective='obj')
#arch_9.search_area_in_loop (baidu_algs, subset_length=2, do_gen_hdl=True, do_synthesis=True, period=1333, MLblock_version='v2', objective='obj')
#arch_6.search_area_in_loop (baidu_algs, subset_length=2, do_gen_hdl=True, do_synthesis=True, period=1333, MLblock_version='v2', objective='obj')

