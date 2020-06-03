from models import *
from benchmark_space import * 
from benchmark_algs import * 
from benchmark_archs import * 

arch_all.print_confs()
	
for counter in range(2):

	print (arch_all.rate_arch(algs_light))
	list_to_remove = []
	for conf in arch_all.confs:
		print(arch_all.confs[conf].score)
		
		if arch_all.confs[conf].score == 0:
			list_to_remove.append(conf)

	print (list_to_remove)
	for conf in list_to_remove:
		del arch_all.confs[conf]

	arch_all.reset_confs_score()
	arch_all.print_confs()

arch_all.print_confs(type="IW")

# main 
# setup space and algorithms.
# for loop for different architectures
#		measure the feasiblity and cost function for that
# pich top few ones. 