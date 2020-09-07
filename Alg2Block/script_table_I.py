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

# heuristic approach
arch_12.search_heuristic_v2(baidu_algs, MLblock_version='v2', period=1333, verbose=False)

arch_12.search_area_in_loop(baidu_algs, subset_length=2, do_gen_hdl=True, do_synthesis=True, period=1333, MLblock_version='v2', objective='obj')
arch_12.search_area_in_loop(baidu_algs, subset_length=3, do_gen_hdl=True, do_synthesis=True, period=1333, MLblock_version='v2', objective='obj')
arch_12.search_area_in_loop(baidu_algs, subset_length=4, do_gen_hdl=False, do_synthesis=False, period=1333, MLblock_version='v2', objective='util')
arch_12.search_area_in_loop(baidu_algs, subset_length=5, do_gen_hdl=False, do_synthesis=False, period=1333, MLblock_version='v2', objective='util')
