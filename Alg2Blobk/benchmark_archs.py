from models import *
from benchmark_space import * 

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

arch_all = Arch("all", 
			None, 
			my_space,

			stationary="W",
			precisions=	{	"I" : 8,
							"W" : 8,
							"O" : 32,
						},
			nmac=8,
			limits= {	"IO_I" : 36,
						"IO_W" : None,
						"IO_O" : 32*4,

						"IO" : None,
						#"IO" : 48+30+18+27+48 # = DSP48_out + DSP48_A + DSP48_B + DSP48_C + DSP48_D
					}
			)

if __name__ == "__main__":

	arch_MLBlock.print_confs()
	print (arch_MLBlock.rate_arch(algs))
