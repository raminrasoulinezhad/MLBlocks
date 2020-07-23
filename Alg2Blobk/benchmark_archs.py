from models import *
from benchmark_space import * 


arch = Arch("all", 
			None, 
			my_space,
			stationary="W",
			precisions={	
							"I" : 8,
							"W" : 8,
							"O" : 32,
						},
			nmac=12,
			limits= {	
						"IO_I" : 36,
						"IO_W" : None,
						"IO_O" : 32*4,
						"IO" : None, 	# 48+30+18+27+48 # = DSP48_out + DSP48_A + DSP48_B + DSP48_C + DSP48_D
					}
			)

if __name__ == "__main__":
	arch_MLBlock.print_confs()
	print (arch_MLBlock.rate_arch(algs))
