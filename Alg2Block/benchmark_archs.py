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


arch_12_16x16 = Arch("all", 
			None, 
			my_space,
			stationary="W",
			precisions={	
							"I" : 8,
							"W" : 8,
							"O" : 32,
						},
			subprecisions=	{	
						"I_D" : 4,
						"W_D" : 2,
						"RES_D" : 1,
						"SHIFTER_TYPE" : "BYPASS",	# "BYPASS", "2Wx2V_by_WxV", "2Wx2V_by_WxV_apx", "2Wx2V_by_WxV_apx_adv"
					},
			nmac=12,
			limits= {	
						"IO_I" : 36,
						"IO_W" : None,
						"IO_O" : 32*4,
						"IO" : None, 	# 48+30+18+27+48 # = DSP48_out + DSP48_A + DSP48_B + DSP48_C + DSP48_D
					}
			)

arch_9_16x16 = Arch("all", 
			None, 
			my_space,
			stationary="W",
			precisions={	
							"I" : 8,
							"W" : 8,
							"O" : 32,
						},
			subprecisions=	{	
						"I_D" : 4,
						"W_D" : 2,
						"RES_D" : 1,
						"SHIFTER_TYPE" : "BYPASS",	# "BYPASS", "2Wx2V_by_WxV", "2Wx2V_by_WxV_apx", "2Wx2V_by_WxV_apx_adv"
					},
			nmac=9,
			limits= {	
						"IO_I" : 36,
						"IO_W" : None,
						"IO_O" : 32*4,
						"IO" : None, 	# 48+30+18+27+48 # = DSP48_out + DSP48_A + DSP48_B + DSP48_C + DSP48_D
					}
			)

arch_6_16x16 = Arch("all", 
			None, 
			my_space,
			stationary="W",
			precisions={	
							"I" : 8,
							"W" : 8,
							"O" : 32,
						},
			subprecisions=	{	
						"I_D" : 4,
						"W_D" : 2,
						"RES_D" : 1,
						"SHIFTER_TYPE" : "BYPASS",	# "BYPASS", "2Wx2V_by_WxV", "2Wx2V_by_WxV_apx", "2Wx2V_by_WxV_apx_adv"
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
