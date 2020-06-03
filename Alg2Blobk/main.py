from models import *
import numpy as np
import copy
from utils import * 
from benchmark import * 



arch_all = Arch("all", 
			None, 
			my_space,

			stationary="W",
			precisions=	{	"I" : 8,
							"W" : 8,
							"O" : 32,
						},
			nmac=12,
			limits= {	"IO_I" : 36,
						"IO_W" : None,
						"IO_O" : None,
						"IO" : 48+30+18+27+48+50,
						#"IO" : 48+30+18+27+48 # = DSP48_out + DSP48_A + DSP48_B + DSP48_C + DSP48_D
					}
			)




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



exit()




arch_MLBlock = Arch("MLBlock", 
			{
				"conf_0_0" : {
					"d":	4,
					"b":	1,
					"k":	1,
					"c":	1,
					"y":	1,
					"x":	1,
					"fy":	1,
					"fx":	3
				},
				"conf_0_1" : {
					"d":	1,
					"b":	4,
					"k":	1,
					"c":	1,
					"y":	1,
					"x":	1,
					"fy":	1,
					"fx":	3
				},
				"conf_0_2" : {
					"d":	1,
					"b":	1,
					"k":	4,
					"c":	1,
					"y":	1,
					"x":	1,
					"fy":	1,
					"fx":	3
				},
				"conf_1" : {
					"d":	1,
					"b":	1,
					"k":	3,
					"c":	4,
					"y":	1,
					"x":	1,
					"fy":	1,
					"fx":	1
				},
			}, 
			my_space)

arch_MLBlock.print_confs()
print (arch_MLBlock.rate_arch(algs))







# main 
# setup space and algorithms.
# for loop for different architectures
#		measure the feasiblity and cost function for that
# pich top few ones. 