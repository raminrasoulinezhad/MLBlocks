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


do_gen_hdl, do_synthesis = False, False 

# heuristic approach  
arch_12.search_heuristic_v2(baidu_algs, MLblock_version='v2', heuristic_mode='old', period=1333, verbose=False)

# N-Config seaches
arch_12.search_area_in_loop(baidu_algs, subset_length=1, do_gen_hdl=do_gen_hdl, do_synthesis=do_synthesis, period=1333, MLblock_version='v2', objective='obj', verbose=False)
arch_12.search_area_in_loop(baidu_algs, subset_length=2, do_gen_hdl=do_gen_hdl, do_synthesis=do_synthesis, period=1333, MLblock_version='v2', objective='obj', verbose=False)
arch_12.search_area_in_loop(baidu_algs, subset_length=3, do_gen_hdl=do_gen_hdl, do_synthesis=do_synthesis, period=1333, MLblock_version='v2', objective='obj', verbose=False)
arch_12.search_area_in_loop(baidu_algs, subset_length=4, do_gen_hdl=False, do_synthesis=False, period=1333, MLblock_version='v2', objective='util', verbose=False)
arch_12.search_area_in_loop(baidu_algs, subset_length=5, do_gen_hdl=False, do_synthesis=False, period=1333, MLblock_version='v2', objective='util', verbose=False)
