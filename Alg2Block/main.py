from Param import Param
from Space import Space
from Arch import Arch
from Algorithm import Algorithm
from Unrolling import Unrolling
from ImpConfig import ImpConfig 

from benchmark_space import * 
from benchmark_algs import * 
from benchmark_archs import * 

#arch.search_full(custom_algs_light, randomness=False, MLblock_version='v2')
#arch.search_full(custom_algs_light, randomness=True, MLblock_version='v2')
#arch.search_heuristic(custom_algs_light, prune_methode="old", MLblock_version='v2')

#arch.search_heuristic_v2(baidu_algs, MLblock_version='v2')

arch.search_area_in_loop(baidu_algs, subset_length=2, do_gen_hdl=False, do_synthesis=False, period=1333, MLblock_version='v2')


