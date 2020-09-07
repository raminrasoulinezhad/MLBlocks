from Arch import Arch
from benchmark_space import *

arch_12 = Arch("all", 
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

arch_9 = Arch("all", 
			None, 
			my_space,
			stationary="W",
			precisions={	
							"I" : 8,
							"W" : 8,
							"O" : 32,
						},
			nmac=9,
			limits= {	
						"IO_I" : 36,
						"IO_W" : None,
						"IO_O" : 32*4,
						"IO" : None, 	# 48+30+18+27+48 # = DSP48_out + DSP48_A + DSP48_B + DSP48_C + DSP48_D
					}
			)

arch_6 = Arch("all", 
			None, 
			my_space,
			stationary="W",
			precisions={	
							"I" : 8,
							"W" : 8,
							"O" : 32,
						},
			nmac=6,
			limits= {	
						"IO_I" : 36,
						"IO_W" : None,
						"IO_O" : 32*4,
						"IO" : None, 	# 48+30+18+27+48 # = DSP48_out + DSP48_A + DSP48_B + DSP48_C + DSP48_D
					}
			)


print ("\n-- Arch. descriptions are loaded\n")

if __name__ == "__main__":
	arch_12.print_confs()	 
	print (arch_12.rate_arch(algs))
