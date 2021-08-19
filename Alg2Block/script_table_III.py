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

# make sure out directory is created
os.system('mkdir -p ../out')

# heuristic approach
arch_12_16x16.search_heuristic_v2(baidu_algs, MLblock_version='v2', heuristic_mode='new', period=1333, verbose=False)
os.system('cp -r ../verilog ../out/arch_12_16x16')
arch_9_16x16.search_heuristic_v2 (baidu_algs, MLblock_version='v2', heuristic_mode='new', period=1333, verbose=False)
os.system('cp -r ../verilog ../out/arch_9_16x16')
arch_8_16x16.search_heuristic_v2 (baidu_algs, MLblock_version='v2', heuristic_mode='new', period=1333, verbose=False)
os.system('cp -r ../verilog ../out/arch_8_16x16')
arch_6_16x16.search_heuristic_v2 (baidu_algs, MLblock_version='v2', heuristic_mode='new', period=1333, verbose=False)
os.system('cp -r ../verilog ../out/arch_6_16x16')
