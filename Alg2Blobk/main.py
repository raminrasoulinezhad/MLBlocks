from models import *
from benchmark_space import * 
from benchmark_algs import * 
from benchmark_archs import * 

arch_all.explore_config(algs_light, prune_methode="old", implementation_methode="new")
