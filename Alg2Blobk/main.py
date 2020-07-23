from models import *
from benchmark_space import * 
from benchmark_algs import * 
from benchmark_archs import * 
#arch.search_full(algs_light)
arch.search_heuristic(algs_light, prune_methode="old")
