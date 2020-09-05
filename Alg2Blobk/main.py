from Param import Param
from Space import Space
from Arch import Arch
from Algorithm import Algorithm
from Unrolling import Unrolling
from ImpConfig import ImpConfig 

from benchmark_space import * 
from benchmark_algs import * 
from benchmark_archs import * 

#arch.search_full(custom_algs_light, randomness=False)
#arch.search_full(custom_algs_light, randomness=True)
#arch.search_heuristic(custom_algs_light, prune_methode="old")

#arch.search_heuristic_v2(baidu_algs)
arch.search_area_in_loop(baidu_algs, subset_length=2, do_synthesis=False)
